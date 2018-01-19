//
//  QBPayStatsModel.h
//  QBuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBStatsBaseModel.h"

@interface QBPayStatsModel : QBStatsBaseModel

- (BOOL)statsPayWithStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos completionHandler:(QBCompletionHandler)completionHandler;

@end
