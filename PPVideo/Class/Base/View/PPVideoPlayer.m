//
//  PPVideoPlayer.m
//  PPVideo
//
//  Created by Liang on 2016/10/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVideoPlayer.h"

@import AVFoundation;

@interface PPVideoPlayer ()
{
    UILabel *_loadingLabel;
    PPVipLevel _vipLevel;
}
@property (nonatomic,retain) AVPlayer *player;

@end

@implementation PPVideoPlayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL forVipLevel:(PPVipLevel)vipLevel hasTimeControl:(BOOL)hasTimeControl {
    self = [self init];
    if (self) {
        _videoURL = videoURL;
        
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.text = @"加载中...";
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_loadingLabel];
        {
            [_loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
        
        self.player = [AVPlayer playerWithURL:videoURL];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
        @weakify(self);
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {
            @strongify(self);
            //获取时间
            //获取当前播放时间(根据帧数和播放速率，视频资源的总长度得到的CMTime)
            CMTime currentCMT = self.player.currentItem.currentTime;
            //总时间
            CMTime allCMT = self.player.currentItem.duration;
            //CMTimeGetSeconds 将描述视频时间的结构体转化为float（秒）
//            float pro = CMTimeGetSeconds(current)/CMTimeGetSeconds(dur);
            float currentSecond = CMTimeGetSeconds(currentCMT);
            float allSecond = CMTimeGetSeconds(allCMT);
            //回到主线程刷新UI
            NSLog(@"%f %f",currentSecond,allSecond);
            
            if (self.sliderPercent && currentSecond > 0) {
                self.sliderPercent(currentSecond);
            }
            
            if (hasTimeControl) {
                if (currentSecond > 20 && [PPUtil currentVipLevel] == PPVipLevelNone) {
                    [self pauseAndPopAction];
                } else if (currentSecond > 40 && [PPUtil currentVipLevel] == PPVipLevelVipA) {
                    [self pauseAndPopAction];
                } else if (currentSecond > 60 && [PPUtil currentVipLevel] == PPVipLevelVipB) {
                    [self pauseAndPopAction];
                }
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndPlay) name:AVPlayerItemDidPlayToEndTimeNotification  object:nil];
    }
    return self;
}

- (void)pauseAndPopAction {
    [self.player pause];
    if (self.notiEndAction) {
        self.notiEndAction(self);
    }
}

- (void)startToPlay {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusReadyToPlay:
                _loadingLabel.hidden = YES;
                break;
            default:
                _loadingLabel.hidden = NO;
                _loadingLabel.text = @"加载失败";
                break;
        }
    }
}

- (void)didEndPlay {
    if (self.endPlayAction) {
        self.endPlayAction(self);
    }
}


@end
