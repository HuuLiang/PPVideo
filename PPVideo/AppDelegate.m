//
//  AppDelegate.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "AppDelegate.h"
#import "PPTabBarController.h"
#import <QBPaymentManager.h>
#import <QBPaymentConfig.h>

#import "PPActivateModel.h"
#import "PPSystemConfigModel.h"
#import "PPUserAccessModel.h"

#import "MobClick.h"

static NSString *const kAliPaySchemeUrl = @"paoPaoYingyuanAliPayUrlScheme";

@interface AppDelegate () <UITabBarControllerDelegate>
@property (nonatomic) UIViewController *rootViewController;
@end

@implementation AppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    return _window;
}

- (UIViewController *)rootViewController {
    if (_rootViewController) {
        return _rootViewController;
    }
    PPTabBarController *tabBarVC = [[PPTabBarController alloc] init];
    tabBarVC.delegate = self;
    _rootViewController = tabBarVC;
    return _rootViewController;
}

- (void)setupCommonStyles {
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#21243F"]];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#1F233E"]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[PPUtil isIpad] ? 21 : kWidth(36)],
                                                           NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   if (thisVC.navigationController.viewControllers.count > 1) {
                                       thisVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStyleBordered handler:^(id sender) {
                                           [thisVC.navigationController popViewControllerAnimated:YES];
                                       }];
                                   }
                                   thisVC.navigationController.navigationBar.translucent = NO;
                               } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(hidesBottomBarWhenPushed)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo)
     {
         UIViewController *thisVC = [aspectInfo instance];
         BOOL hidesBottomBar = NO;
         if (thisVC.navigationController.viewControllers.count > 1) {
             hidesBottomBar = YES;
         }
         [[aspectInfo originalInvocation] setReturnValue:&hidesBottomBar];
     } error:nil];
    
    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
                                    withOptions:AspectPositionInstead
                                     usingBlock:^(id<AspectInfo> aspectInfo){
                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                                     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                               } error:nil];
    
    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
                          withOptions:AspectPositionInstead
                           usingBlock:^(id<AspectInfo> aspectInfo)
     {
         BOOL bShow = NO;
         [[aspectInfo originalInvocation] setReturnValue:&bShow];
     } error:nil];
    
    [[PPUserAccessModel sharedModel] aspect_hookSelector:@selector(requestUserAccess)
                                             withOptions:AspectPositionAfter
                                              usingBlock:^(id<AspectInfo> aspetInfo)
    {
        [[QBStatsManager sharedManager] registStatsManagerWithUserId:[PPUtil userId] restAppId:PP_REST_APPID restPv:PP_REST_PV launchSeq:[PPUtil launchSeq]];
    }error:nil];
    
//    [UIImageView aspect_hookSelector:@selector(init)
//                         withOptions:AspectPositionAfter
//                          usingBlock:^(id<AspectInfo> aspectInfo) {
//                              UIImageView *thisImgV = [aspectInfo instance];
//                              [thisImgV setContentMode:UIViewContentModeScaleAspectFill];
//                              thisImgV.clipsToBounds = YES;
//                          } error:nil];
}

- (QBPaymentConfig *)setDefaultPaymentConfig {
    QBPaymentConfig *config = [[QBPaymentConfig alloc] init];
    
    QBPaymentConfigDetail *configDetails = [[QBPaymentConfigDetail alloc] init];
    //爱贝默认配置
    QBIAppPayConfig * iAppPayConfig = [[QBIAppPayConfig alloc] init];
    iAppPayConfig.appid = @"3006339410";
    iAppPayConfig.privateKey = @"MIICWwIBAAKBgQCHEQCLCZujWicF6ClEgHx4L/OdSHZ1LdKi/mzPOIa4IRfMOS09qDNV3+uK/zEEPu1DgO5Cl1lsm4xpwIiOqdXNRxLE9PUfgRy4syiiqRfofAO7w4VLSG4S0VU5F+jqQzKM7Zgp3blbc5BJ5PtKXf6zP3aCAYjz13HHH34angjg0wIDAQABAoGASOJm3aBoqSSL7EcUhc+j2yNdHaGtspvwj14mD0hcgl3xPpYYEK6ETTHRJCeDJtxiIkwfxjVv3witI5/u0LVbFmd4b+2jZQ848BHGFtZFOOPJFVCylTy5j5O79mEx0nJN0EJ/qadwezXr4UZLDIaJdWxhhvS+yDe0e0foz5AxWmkCQQDhd9U1uUasiMmH4WvHqMfq5l4y4U+V5SGb+IK+8Vi03Zfw1YDvKrgv1Xm1mdzYHFLkC47dhTm7/Ko8k5Kncf89AkEAmVtEtycnSYciSqDVXxWtH1tzsDeIMz/ZlDGXCAdUfRR2ZJ2u2jrLFunoS9dXhSGuERU7laasK0bDT4p0UwlhTwJAVF+wtPsRnI1PxX6xA7WAosH0rFuumax2SFTWMLhGduCZ9HEhX97/sD7V3gSnJWRsDJTasMEjWtrxpdufvPOnDQJAdsYPVGMItJPq5S3n0/rv2Kd11HdOD5NWKsa1mMxEjZN5lrfhoreCb7694W9pI31QWX6+ZUtvcR0fS82KBn3vVQJAa0fESiiDDrovKHBm/aYXjMV5anpbuAa5RJwCqnbjCWleZMwHV+8uUq9+YMnINZQnvi+C62It4BD+KrJn5q4pwg==";
    iAppPayConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbNQyxdpLeMwE0QMv/dB3Jn1SRqYE/u3QT3ig2uXu4yeaZo4f7qJomudLKKOgpa8+4a2JAPRBSueDpiytR0zN5hRZKImeZAu2foSYkpBqnjb5CRAH7roO7+ervoizg6bhAEx2zlltV9wZKQZ0Di5wCCV+bMSEXkYqfASRplYUvHwIDAQAB";
    iAppPayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyIpay.json";
    iAppPayConfig.waresid = @(1);
    configDetails.iAppPayConfig = iAppPayConfig;
    
    //海豚默认配置
    QBHTPayConfig *htpayConfig = [[QBHTPayConfig alloc] init];
    htpayConfig.mchId = @"10014";
    htpayConfig.key = @"55f4f728b7a01c2e57a9f767fd34cb8e";
    htpayConfig.appid = @"wx76a599c65c73cb3f";
    htpayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyHtPay.json";
    configDetails.htpayConfig = htpayConfig;
    
    //支付方式
    QBPaymentConfigSummary *payConfig = [[QBPaymentConfigSummary alloc] init];
    payConfig.alipay = @"IAPPPAY";
    payConfig.wechat = @"HAITUN";
    
    config.configDetails = configDetails;
    config.payConfig = payConfig;
    
    [config setAsCurrentConfig];
    return config;
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    if (XcodeAppVersion) {
        [MobClick setAppVersion:XcodeAppVersion];
    }
    UMConfigInstance.appKey = PP_UMENG_APP_ID;
    UMConfigInstance.channelId = PP_CHANNEL_NO;
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = PP_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([PP_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = PP_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = PP_BASE_URL;
    
#ifdef DEBUG
    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    
    //读取缓存价格配置
    [PPCacheModel getSystemConfigModelInfo];
    
    [PPUtil accumateLaunchSeq];
    
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:PP_REST_APPID
                                                     paymentPv:@([PP_PAYMENT_PV integerValue])
                                                     channelNo:PP_CHANNEL_NO
                                                     urlScheme:kAliPaySchemeUrl
                                                 defaultConfig:[self setDefaultPaymentConfig]];
    
    [self setupCommonStyles];
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^(BOOL reachable) {
        if (reachable && ![PPSystemConfigModel sharedModel].loaded) {
            [self fetchSystemConfigWithCompletionHandler:nil];
        }
        if (reachable && ![PPUtil isRegistered]) {
            [[PPActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
                if (success) {
                    [PPUtil setRegisteredWithUserId:userId];
                    [[PPUserAccessModel sharedModel] requestUserAccess];
                }
            }];
        } else {
            [[PPUserAccessModel sharedModel] requestUserAccess];
        }
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![PPUtil isRegistered] || ![PPSystemConfigModel sharedModel].loaded)) {
            if ([PPUtil isIpad]) {
                [UIAlertView bk_showAlertViewWithTitle:@"请检查您的网络连接!" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil handler:nil];
            }else{
                [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
            }}
    };
    
    BOOL requestedSystemConfig = NO;
    //#ifdef JF_IMAGE_TOKEN_ENABLED
    NSString *imageToken = [PPUtil imageToken];
    if (imageToken) {
        [[SDWebImageManager sharedManager].imageDownloader setValue:imageToken forHTTPHeaderField:@"Referer"];
        self.window.rootViewController = self.rootViewController;
    } else {
        self.window.rootViewController = [[UIViewController alloc] init];
        [self.window makeKeyAndVisible];
        
        [self.window beginProgressingWithTitle:@"更新系统配置..." subtitle:nil];
        
        requestedSystemConfig = [self fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            [self.window endProgressing];
            self.window.rootViewController = self.rootViewController;
        }];
        
    }
    
    if (!requestedSystemConfig) {
        [[PPSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            if (success) {
                [PPUtil setImageToken:[PPSystemConfigModel sharedModel].imageToken];
            }
            NSUInteger statsTimeInterval = 180;
            [[QBStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        }];
    }
    
    [self.window makeKeyAndVisible];
    [self setupMobStatistics];
    return YES;
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    return [[PPSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSString *fetchedToken = [PPSystemConfigModel sharedModel].imageToken;
            [PPUtil setImageToken:fetchedToken];
            if (fetchedToken) {
                [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
            }
        }
        NSUInteger statsTimeInterval = 180;
        [[QBStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        
        QBSafelyCallBlock(completionHandler, success);
    }];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[QBPaymentManager sharedManager] applicationWillEnterForeground:application];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[QBStatsManager sharedManager] statsTabIndex:tabBarController.selectedIndex subTabIndex:[PPUtil currentSubTabPageIndex] forClickCount:1];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[QBStatsManager sharedManager] statsStopDurationAtTabIndex:tabBarController.selectedIndex subTabIndex:[PPUtil currentSubTabPageIndex]];
    return YES;
}


@end
