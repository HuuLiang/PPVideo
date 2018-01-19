//
//  PPVideoPlayer.m
//  PPVideo
//
//  Created by Liang on 2016/10/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVideoPlayer.h"
#import "PPVideoloaderURLConnection.h"

@import AVFoundation;

@interface PPVideoPlayer () <PPVideoloaderURLConnectionDelegate>
{
    UILabel *_loadingLabel;
    PPVipLevel _vipLevel;
}
@property (nonatomic, strong) AVURLAsset     *videoURLAsset;
@property (nonatomic, strong) AVAsset        *videoAsset;
@property (nonatomic, strong) PPVideoloaderURLConnection *resouerLoader;
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
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

- (instancetype)initWithProgramId:(NSInteger)programId VideoURL:(NSURL *)videoURL forVipLevel:(PPVipLevel)vipLevel hasTimeControl:(BOOL)hasTimeControl isLocalFile:(BOOL)isLocalFile {
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
        
        //如果是ios  < 7 或者是本地资源，直接播放
        if (kIOS_VERSION < 7.0 || isLocalFile) {
            self.videoAsset  = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
            self.currentPlayerItem          = [AVPlayerItem playerItemWithAsset:self.videoAsset];
            if (!self.player) {
                self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
            } else {
                [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
            }
        } else {   //ios7以上采用resourceLoader给播放器补充数据
            self.resouerLoader          = [[PPVideoloaderURLConnection alloc] initWithProgramId:programId];
            self.resouerLoader.delegate = self;
            NSURL *playUrl              = [_resouerLoader getSchemeVideoURL:videoURL];
            self.videoURLAsset             = [AVURLAsset URLAssetWithURL:playUrl options:nil];
            [_videoURLAsset.resourceLoader setDelegate:_resouerLoader queue:dispatch_get_main_queue()];
            self.currentPlayerItem          = [AVPlayerItem playerItemWithAsset:_videoURLAsset];
            
            if (!self.player) {
                self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
            } else {
                [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
            }
        }
        
        
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
        if ([NSThread currentThread].isMainThread) {
            self.notiEndAction(self);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.notiEndAction(self);
            });
        }
        
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
