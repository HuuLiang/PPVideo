//
//  PPVideoPlayerController.h
//  PPVideo
//
//  Created by Liang on 2016/10/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"
#import <QBBaseModel.h>

@interface PPVideoPlayerController : PPBaseViewController
@property (nonatomic) NSString *videoUrl;

- (instancetype)initWithProgramId:(NSInteger)programId Video:(NSString *)videoUrl forVipLevel:(PPVipLevel)vipLevel hasTimeControl:(BOOL)hasTimeControl isLocalFileCache:(BOOL)isLocalFile;

@property (nonatomic,retain)QBBaseModel *baseModel;

@property (nonatomic) QBAction popPayView;

@end
