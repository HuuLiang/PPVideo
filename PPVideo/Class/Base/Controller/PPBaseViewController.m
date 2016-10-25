//
//  PPBaseViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"
#import "PPSystemConfigModel.h"
#import "PPDetailViewController.h"
#import "PPPaymentViewController.h"
#import "PPVideoPlayerController.h"
#import "PPVideoTokenManager.h"

#import <AVFoundation/AVPlayer.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PPBaseViewController ()
@property (nonatomic,weak) UIButton *refreshBtn;
@end

@implementation PPBaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)pushDetailViewControllerWithColumnId:(NSInteger)columnId
                                RealColumnId:(NSInteger)realColumnId
                                  columnType:(NSInteger)columnType
                             programLocation:(NSInteger)programLocation
                              andProgramInfo:(PPProgramModel *)programModel {
    QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:[NSNumber numberWithInteger:realColumnId]
                                                           channelType:[NSNumber numberWithInteger:columnType]
                                                             programId:[NSNumber numberWithInteger:programModel.programId]
                                                           programType:[NSNumber numberWithInteger:programModel.type]
                                                       programLocation:[NSNumber numberWithInteger:programLocation]];
    [[QBStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound];
    PPDetailViewController *detailVC = [[PPDetailViewController alloc] initWithBaseModelInfo:baseModel ColumnId:columnId programInfo:programModel];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)presentPayViewControllerWithBaseModel:(QBBaseModel *)baseModel{
    if ([PPUtil currentVipLevel] == PPVipLevelVipC) {
        [[PPHudManager manager] showHudWithText:@"您已经是尊贵的顶级会员了!"];
        return;
    }
    
    PPPaymentViewController *paymentVC = [[PPPaymentViewController alloc] initWithBaseModel:baseModel];
    UINavigationController *payNav = [[UINavigationController alloc] initWithRootViewController:paymentVC];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self presentViewController:payNav animated:YES completion:nil];
}

- (void)playVideoWithUrl:(PPProgramModel *)programModel baseModel:(QBBaseModel *)baseModel vipLevel:(PPVipLevel)vipLevel hasTomeControl:(BOOL)hasTomeControl {
    [[QBStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:[PPUtil currentTabPageIndex] subTabIndex:[PPUtil currentSubTabPageIndex]];
    
    if ([PPUtil currentVipLevel] == PPVipLevelVipC) {
        @weakify(self);
        [[PPVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
            @strongify(self);
            if (!self) {
                return ;
            }
            [self.view endProgressing];
            
            [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:[[PPVideoTokenManager sharedManager] videoLinkWithOriginalLink:programModel.videoUrl] cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
            
            if (success) {
                UIViewController *videoPlayVC = [self playerVCWithVideo:[[PPVideoTokenManager sharedManager] videoLinkWithOriginalLink:programModel.videoUrl]];
                videoPlayVC.hidesBottomBarWhenPushed = YES;
                [self presentViewController:videoPlayVC animated:YES completion:nil];
            } else {
                [UIAlertView bk_showAlertViewWithTitle:@"无法获取视频信息" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }
        }];
    } else {
//        if (programModel.isFree == YES || [PPUtil currentVipLevel] > PPVipLevelNone) {
            @weakify(self);
            PPVideoPlayerController *videoVC = [[PPVideoPlayerController alloc] initWithVideo:programModel.videoUrl forVipLevel:vipLevel hasTimeControl:hasTomeControl];
            videoVC.baseModel = baseModel;
            videoVC.popPayView = ^ (id obj) {
                @strongify(self);
                [self presentPayViewControllerWithBaseModel:baseModel];
            };
            [self presentViewController:videoVC animated:YES completion:nil];
//        } else {
//            [self presentPayViewControllerWithBaseModel:baseModel];
//        }
    }
}

- (UIViewController *)playerVCWithVideo:(NSString *)videoUrl {
    UIViewController *retVC;
    if (NSClassFromString(@"AVPlayerViewController")) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
        [playerVC aspect_hookSelector:@selector(viewDidAppear:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo){
                               AVPlayerViewController *thisPlayerVC = [aspectInfo instance];
                               [thisPlayerVC.player play];
                           } error:nil];
        
        retVC = playerVC;
    } else {
        retVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoUrl]];
    }
    
    [retVC aspect_hookSelector:@selector(supportedInterfaceOrientations) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
        [[aspectInfo originalInvocation] setReturnValue:&mask];
    } error:nil];
    
    [retVC aspect_hookSelector:@selector(shouldAutorotate) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        BOOL rotate = YES;
        [[aspectInfo originalInvocation] setReturnValue:&rotate];
    } error:nil];
    return retVC;
}

#pragma mark - refreshButton

- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(QBAction) action;{
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn = refreshBtn;
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(18.)];
    [refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(kScreenWidth/2.-kWidth(40.), (kScreenHeight-113.)/2. -kWidth(40.), kWidth(80.),kWidth(80.));
    refreshBtn.backgroundColor = [UIColor clearColor];
    [view addSubview:refreshBtn];
    [UIView animateWithDuration:0.4 animations:^{
        refreshBtn.transform = CGAffineTransformMakeScale(1.8, 1.8);
    }];
    [refreshBtn bk_addEventHandler:^(id sender) {
        if (action) {
            action(refreshBtn);
        }
        refreshBtn.transform = CGAffineTransformMakeScale(0.56, 0.56);
        [UIView animateWithDuration:0.4 animations:^{
            refreshBtn.transform = CGAffineTransformMakeScale(1.8, 1.8);
        }];
        
        if (![PPSystemConfigModel sharedModel].loaded) {
            [[PPSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:nil];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)removeCurrentRefreshBtn{
    if (self.refreshBtn) {
        [self.refreshBtn removeFromSuperview];
        self.refreshBtn = nil;
    }
}

@end
