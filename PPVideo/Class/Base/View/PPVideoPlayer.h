//
//  PPVideoPlayer.h
//  PPVideo
//
//  Created by Liang on 2016/10/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^refreshPlaySlider)(CGFloat percent);

@interface PPVideoPlayer : UIView
@property (nonatomic) NSURL *videoURL;
- (instancetype)initWithProgramId:(NSInteger)programId VideoURL:(NSURL *)videoURL forVipLevel:(PPVipLevel)vipLevel hasTimeControl:(BOOL)hasTimeControl isLocalFile:(BOOL)isLocalFile;
- (void)startToPlay;
- (void)pause;
@property (nonatomic,copy) QBAction endPlayAction;
@property (nonatomic) refreshPlaySlider sliderPercent;
@property (nonatomic,copy) QBAction notiEndAction;
@end
