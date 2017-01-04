//
//  PPTabBarController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTabBarController.h"
#import "PPNavigationController.h"

#import "PPTrialViewController.h"
#import "PPVipViewController.h"
#import "PPSexViewController.h"
#import "PPLiveViewController.h"
#import "PPForumViewController.h"
#import "PPHotViewController.h"
#import "PPMineViewController.h"

typedef enum : NSUInteger {
    Fade = 1,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    SuckEffect,                 //吮吸
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
    CameraIrisHollowOpen,       //开镜头
    CameraIrisHollowClose,      //关镜头
    CurlDown,                   //下翻页
    CurlUp,                     //上翻页
    FlipFromLeft,               //左翻转
    FlipFromRight,              //右翻转
    
} AnimationType;

@interface PPTabBarController () <UITabBarControllerDelegate>
{
    UINavigationController *_hotNav;
}
@property (nonatomic,strong) NSMutableArray * childVCs;
@end

@implementation PPTabBarController
QBDefineLazyPropertyInitialization(NSMutableArray, childVCs)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([PPUtil launchSeq] > 1 && ![PP_CHANNEL_NO isEqualToString:@"IOS_XIUXIU_0001"]) {
        [PPUtil showSpreadBanner];
    } else {
        [PPUtil getSpreadeBannerInfo];
    }
    
    [self addChildViewControllers];
    
    [PPUtil checkVersionUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self tabBarController:self didSelectViewController:[self.childVCs firstObject]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentWindow:) name:kPaidNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentHotVC:) name:kPopSearchNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHotVC:) name:kHideSearchNotificationName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)presentWindow:(NSNotification *)notification {
    [self addChildViewControllers];
    
    PPTabBarController *tabBar = [[PPTabBarController alloc] init];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"suckEffect";
    
    //animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self presentViewController:tabBar animated:NO completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tabBar dismissViewControllerAnimated:NO completion:nil];
        });
    }];
}

- (void)presentHotVC:(NSNotification *)notification {
    PPHotViewController *hotVC = [[PPHotViewController alloc] init];
    _hotNav = [[UINavigationController alloc] initWithRootViewController:hotVC];
    [_hotNav setNavigationBarHidden:YES];
    [self presentViewController:_hotNav animated:YES completion:nil];
}

- (void)hideHotVC:(NSNotification *)notification {
    [_hotNav dismissViewControllerAnimated:YES completion:nil];
}


- (void)addTrendsViewControllers {
    
    NSDictionary *photoDic = @{@(PPVipLevelNone):@"trial",
                               @(PPVipLevelVipA):@"avip",
                               @(PPVipLevelVipB):@"bvip",
                               @(PPVipLevelVipC):@"cvip"};
    
    NSDictionary *titleDic = @{@(PPVipLevelNone):@"初探",
                               @(PPVipLevelVipA):@"黄金",
                               @(PPVipLevelVipB):@"钻石",
                               @(PPVipLevelVipC):@"黑金"};
    
    
    
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        PPTrialViewController *trialVC = [[PPTrialViewController alloc] initWithTitle:titleDic[@([PPUtil currentVipLevel])]];
        PPNavigationController *trialNav = [[PPNavigationController alloc] initWithRootViewController:trialVC];
        
        trialNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:trialVC.title
                                                            image:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_normal",photoDic[@([PPUtil currentVipLevel])]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                    selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected",photoDic[@([PPUtil currentVipLevel])]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.childVCs addObject:trialNav];
    }
    
    PPVipViewController *vipVC = [[PPVipViewController alloc] initWithTitle:titleDic[@([PPUtil currentVipLevel] + ([PPUtil isVip] ? 0 : 1))] vipLevel:[PPUtil currentVipLevel] + ([PPUtil isVip] ? 0 : 1)];
    PPNavigationController *vipNav = [[PPNavigationController alloc] initWithRootViewController:vipVC];
    vipNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:vipVC.title
                                                      image:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_normal",photoDic[@([PPUtil currentVipLevel] + ([PPUtil isVip] ? 0 : 1))]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected",photoDic[@([PPUtil currentVipLevel] + ([PPUtil isVip] ? 0 : 1))]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.childVCs addObject:vipNav];
    
    if (photoDic[@([PPUtil currentVipLevel] + 1)] && self.childVCs.count != 2) {
        PPVipViewController *SVipVC = [[PPVipViewController alloc] initWithTitle:titleDic[@([PPUtil currentVipLevel] + 1)] vipLevel:[PPUtil currentVipLevel] + 1];
        PPNavigationController *SVipNav = [[PPNavigationController alloc] initWithRootViewController:SVipVC];
        SVipNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:SVipVC.title
                                                           image:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_normal",photoDic[@([PPUtil currentVipLevel] + 1)]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected",photoDic[@([PPUtil currentVipLevel] + 1)]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.childVCs addObject:SVipNav];
    }
}

- (void)addChildViewControllers {
    [self.childVCs removeAllObjects];
    
    [self addTrendsViewControllers];
    
    PPSexViewController *sexVC = [[PPSexViewController alloc] initWithTitle:@"撸点"];
    PPNavigationController *sexNav = [[PPNavigationController alloc] initWithRootViewController:sexVC];
    
//    UIImage *image = nil;
//    if ([PPUtil currentVipLevel] != PPVipLevelVipC) {
//        sexNav.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 0, -10, 0);
//        image = [[UIImage imageNamed:@"tabbar_sex"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    } else {
//        image = [UIImage imageNamed:@"tabbar_sex_normal"];
//    }
//    sexNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:[PPUtil currentVipLevel] == PPVipLevelVipC ? @"撸点" : nil
//                                                      image:image
//                                              selectedImage:[[UIImage imageNamed:[PPUtil currentVipLevel] == PPVipLevelVipC ? @"tabbar_sex_selected" : @"tabbar_sex"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    sexNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                      image:[[UIImage imageNamed:@"tabbar_sex_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"tabbar_sex_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    sexNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    PPLiveViewController *liveVC = [[PPLiveViewController alloc] initWithTitle:@"直播"];
    PPNavigationController *liveNav = [[PPNavigationController alloc] initWithRootViewController:liveVC];
    liveNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:liveVC.title
                                                       image:[[UIImage imageNamed:@"tabbar_live_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_live_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    PPForumViewController *forumVC = [[PPForumViewController alloc] initWithTitle:@"论坛"];
    PPNavigationController *forumNav = [[PPNavigationController alloc] initWithRootViewController:forumVC];
    forumNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:forumVC.title
                                                       image:[[UIImage imageNamed:@"tabbar_forum_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_forum_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.childVCs addObject:sexNav];
    [self.childVCs addObject:liveNav];
    [self.childVCs addObject:forumNav];
    
    self.viewControllers = self.childVCs;
    self.tabBar.translucent = NO;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([PPUtil currentTabPageIndex] != 5 && [PPUtil currentTabPageIndex] != 7) {
        [[PPSearchView showView] showInSuperView:self.view animated:[PPUtil currentTabPageIndex] == 0];
    } else {
        [[PPSearchView showView] hideFormSuperView];
    }
    [[QBStatsManager sharedManager] statsTabIndex:[PPUtil currentTabPageIndex] subTabIndex:[PPUtil currentSubTabPageIndex] forClickCount:1];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[QBStatsManager sharedManager] statsStopDurationAtTabIndex:[PPUtil currentTabPageIndex] subTabIndex:[PPUtil currentSubTabPageIndex]];
    return YES;
}

@end
