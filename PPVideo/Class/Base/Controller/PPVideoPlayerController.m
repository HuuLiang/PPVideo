//
//  PPVideoPlayerController.m
//  PPVideo
//
//  Created by Liang on 2016/10/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVideoPlayerController.h"
#import "PPVideoPlayer.h"
#import "PPVideoTokenManager.h"

@interface PPVideoPlayerController ()
{
    PPVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
    PPVipLevel _vipLevel;
    BOOL _hasTimeControl;
}
@end

@implementation PPVideoPlayerController

- (instancetype)initWithVideo:(NSString *)videoUrl forVipLevel:(PPVipLevel)vipLevel hasTimeControl:(BOOL)hasTimeControl{
    self = [self init];
    if (self) {
        _videoUrl = videoUrl;
        _vipLevel = vipLevel;
        _hasTimeControl = hasTimeControl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    @weakify(self);
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"video_close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
    {
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(30);
        }];
    }
    
    [_closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self->_videoPlayer pause];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self dismissAndPopPayment];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view beginProgressingWithTitle:@"加载中..." subtitle:nil];
    
    [[PPVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
        @strongify(self);
        if (!self) {
            return ;
        }
        [self.view endProgressing];
        
        if (success) {
            [self loadVideo:[NSURL URLWithString:[[PPVideoTokenManager sharedManager]videoLinkWithOriginalLink:_videoUrl]]];
        } else {
            [UIAlertView bk_showAlertViewWithTitle:@"无法获取视频信息" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)loadVideo:(NSURL *)videoUrl {
    
    _videoPlayer = [[PPVideoPlayer alloc] initWithVideoURL:videoUrl forVipLevel:_vipLevel hasTimeControl:_hasTimeControl];
    [self.view insertSubview:_videoPlayer atIndex:0];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    
    
    @weakify(self);
    _videoPlayer.endPlayAction = ^(id obj) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            [self dismissAndPopPayment];
        }];
    };
    
    //#ifdef YYK_DISPLAY_VIDEO_URL
    //    NSString *url = videoUrl.absoluteString;
    //    [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:url cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
    //#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_videoPlayer startToPlay];
}
- (void)dismissAndPopPayment {
    if (self.popPayView) {
        self.popPayView(self);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
