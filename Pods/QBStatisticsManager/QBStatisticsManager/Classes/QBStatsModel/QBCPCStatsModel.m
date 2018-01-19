//
//  QBCPCStatsModel.m
//  QBuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBCPCStatsModel.h"

@implementation QBCPCStatsModel

- (BOOL)statsCPCWithStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos
             completionHandler:(QBCompletionHandler)completionHandler
{
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos];
    if (params.count == 0) {
        QBSafelyCallBlock(completionHandler, NO, @"No validated statsInfos to Commit!");
        return NO;
    }

    BOOL ret = [self requestURLPath:QB_STATS_CPC_URL
                         withParams:params
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    QBSafelyCallBlock(completionHandler, respStatus==QBURLResponseSuccess, errorMessage);
                }];
    return ret;
}

@end
