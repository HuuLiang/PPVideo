//
//  QBBaseModel.h
//  QBVideo
//
//  Created by ylz on 16/9/5.
//  Copyright © 2016年 baqu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBBaseModel : NSObject
@property (nonatomic)NSNumber *realColumnId;
@property (nonatomic)NSNumber *channelType;
@property (nonatomic)NSNumber *programType;
@property (nonatomic)NSNumber *programId;
@property (nonatomic)NSNumber *programLocation;
@property (nonatomic)NSInteger subTab;

+ (instancetype)getBaseModelWithRealColoumId:(NSNumber *)realColoumId channelType:(NSNumber *)channelType programId:(NSNumber *)programId programType:(NSNumber *)programType programLocation:(NSNumber *)programLocation;
@end
