//
//  QBCPCStatsModel.h
//  QBuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBStatsBaseModel.h"

@interface QBCPCStatsModel : QBStatsBaseModel

- (BOOL)statsCPCWithStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos
             completionHandler:(QBCompletionHandler)completionHandler;

@end
