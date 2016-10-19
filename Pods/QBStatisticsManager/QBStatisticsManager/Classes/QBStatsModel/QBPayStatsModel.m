//
//  QBPayStatsModel.m
//  QBuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBPayStatsModel.h"

@implementation QBPayStatsModel

- (BOOL)statsPayWithStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos completionHandler:(QBCompletionHandler)completionHandler {
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos shouldIncludeStatsType:NO];
    if (params.count == 0) {
        QBSafelyCallBlock(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:QB_STATS_PAY_URL
                         withParams:params
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        QBSafelyCallBlock(completionHandler, respStatus==QBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
