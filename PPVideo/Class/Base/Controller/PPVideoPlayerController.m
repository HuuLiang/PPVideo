//
//  PPVideoPlayerController.m
//  PPVideo
//
//  Created by Liang on 2016/10/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVideoPlayerController.h"
#import "PPVideoPlayer.h"

@interface PPVideoPlayerController ()
{
    PPVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
    PPVipLevel _vipLevel;
    BOOL _hasTimeControl;
    BOOL _isLocalFile;
    NSInteger _programId;
    
    UISlider *_slider;
    UIButton *_pauseBtn;
    UILabel *_notiLabel;
    BOOL isPause;
}
@end

@implementation PPVideoPlayerController

- (instancetype)initWithProgramId:(NSInteger)programId Video:(NSString *)videoUrl forVipLevel:(PPVipLevel)vipLevel hasTimeControl:(BOOL)hasTimeControl isLocalFileCache:(BOOL)isLocalFile{
    self = [self init];
    if (self) {
        _videoUrl = videoUrl;
        _vipLevel = vipLevel;
        _programId = programId;
        _isLocalFile = isLocalFile;
        _hasTimeControl = ([PPUtil currentVipLevel] == PPVipLevelVipC) ? NO : hasTimeControl;
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
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    if (_isLocalFile) {
        [self loadVideo:[NSURL fileURLWithPath:_videoUrl]];
    } else {
        [self loadVideo:[NSURL URLWithString:[PPUtil encodeVideoUrlWithVideoUrlStr:_videoUrl]]];
    }
}

- (void)loadVideo:(NSURL *)videoUrl {
    _videoPlayer = [[PPVideoPlayer alloc] initWithProgramId:_programId VideoURL:videoUrl forVipLevel:_vipLevel hasTimeControl:_hasTimeControl isLocalFile:_isLocalFile];
    [self.view insertSubview:_videoPlayer atIndex:0];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
    [self.view addSubview:_pauseBtn];
    
    _slider = [[UISlider alloc] init];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1800;
    _slider.backgroundColor = [UIColor redColor];
    _slider.minimumTrackTintColor = [UIColor redColor];
    _slider.maximumTrackTintColor = [UIColor whiteColor];
    [_slider setThumbImage:[UIImage imageNamed:@"video_point"] forState:UIControlStateNormal];
    _slider.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_slider];

    {
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(40));
            make.right.equalTo(self.view.mas_right).offset(-kWidth(40));
            make.height.mas_equalTo(kWidth(1));
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(40));
        }];
        
        [_pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(_slider.mas_top).offset(-kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
        }];
    }
    
    @weakify(self);
    _videoPlayer.endPlayAction = ^(id obj) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    _videoPlayer.notiEndAction = ^(id obj) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [self dismissAndPopPayment];
        }];
    };
    
    _videoPlayer.sliderPercent = ^ (CGFloat percent) {
        @strongify(self);
        NSLog(@"%f",percent);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_slider setValue:percent animated:YES];
        });
    };
    
    [_pauseBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        if (self->isPause) {
            [self->_videoPlayer startToPlay];
            [self->_pauseBtn setBackgroundImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
        } else {
            [self->_videoPlayer pause];
            [self->_pauseBtn setBackgroundImage:[UIImage imageNamed:@"video_start"] forState:UIControlStateNormal];
        }
        self->isPause = !self->isPause;
    } forControlEvents:UIControlEventTouchUpInside];
    
    if (_hasTimeControl) {
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.userInteractionEnabled = YES;
        _notiLabel.textColor = [UIColor colorWithHexString:@"#888888"];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[PPUtil notiLabelStrWithCurrentVipLevel] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[PPUtil isIpad] ? 28 : kWidth(28)],
                                                                                                                                   NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        _notiLabel.attributedText = str;
        [self.view addSubview:_notiLabel];
        
        [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(_pauseBtn.mas_top).offset(-kWidth(60));
            make.height.mas_equalTo(kWidth(30));
        }];
        
        [_notiLabel bk_whenTapped:^{
            @strongify(self);
            [self->_videoPlayer pause];
            [self dismissViewControllerAnimated:YES completion:^{
                [self dismissAndPopPayment];
            }];
        }];
    }
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
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
