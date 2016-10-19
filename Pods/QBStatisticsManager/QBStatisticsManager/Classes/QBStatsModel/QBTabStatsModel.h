//
//  QBTabStatsModel.h
//  QBuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBStatsBaseModel.h"

@interface QBTabStatsModel : QBStatsBaseModel

- (BOOL)statsTabWithStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos completionHandler:(QBCompletionHandler)completionHandler;

@end
