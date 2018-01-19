//
//  QBBaseModel.m
//  QBVideo
//
//  Created by ylz on 16/9/5.
//  Copyright © 2016年 baqu. All rights reserved.
//

#import "QBBaseModel.h"

@implementation QBBaseModel

+ (instancetype)getBaseModelWithRealColoumId:(NSNumber *)realColoumId channelType:(NSNumber *)channelType programId:(NSNumber *)programId programType:(NSNumber *)programType programLocation:(NSNumber *)programLocation {
    QBBaseModel *baseModel = [[QBBaseModel alloc] init];
    baseModel.realColumnId = realColoumId;
    baseModel.channelType = channelType;
    baseModel.programLocation = programLocation;
    baseModel.programId = programId;
    baseModel.programType = programType;
    return baseModel;
}

@end
