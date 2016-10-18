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

#import "PPActivateModel.h"
#import "PPSystemConfigModel.h"
#import "PPUserAccessModel.h"

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
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[PPUtil isIpad] ? 21 : kWidth(36)],
                                                           NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   if (thisVC.navigationController.viewControllers.count > 1) {
                                       thisVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
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
    
//    [UIImageView aspect_hookSelector:@selector(init)
//                         withOptions:AspectPositionAfter
//                          usingBlock:^(id<AspectInfo> aspectInfo) {
//                              UIImageView *thisImgV = [aspectInfo instance];
//                              [thisImgV setContentMode:UIViewContentModeScaleAspectFill];
//                              thisImgV.clipsToBounds = YES;
//                          } error:nil];
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PPUtil registerVip:PPVipLevelNone];
    
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = PP_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([PP_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = PP_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = PP_BASE_URL;
    
#ifdef DEBUG
    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    
    [PPUtil accumateLaunchSeq];
    [self setupCommonStyles];
    
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:PP_REST_APPID
                                                     paymentPv:@([PP_PAYMENT_PV integerValue])
                                                     channelNo:PP_CHANNEL_NO
                                                     urlScheme:kAliPaySchemeUrl];
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
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
        requestedSystemConfig = [[PPSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            [self.window endProgressing];
            
            if (success) {
                NSString *fetchedToken = [PPSystemConfigModel sharedModel].imageToken;
                [PPUtil setImageToken:fetchedToken];
                if (fetchedToken) {
                    [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
                }
                
            }
            self.window.rootViewController = self.rootViewController;
        }];
    }
    
    if (![PPUtil isRegistered]) {
        [[PPActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            if (success) {
                [PPUtil setRegisteredWithUserId:userId];
            }
        }];
    } else {
        [[PPUserAccessModel sharedModel] requestUserAccess];
    }
    if (!requestedSystemConfig) {
        [[PPSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            if (success) {
                [PPUtil setImageToken:[PPSystemConfigModel sharedModel].imageToken];
            }
        }];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
