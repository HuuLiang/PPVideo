//
//  QBRegistStats.m
//  Pods
//
//  Created by ylz on 2016/10/15.
//
//

#import "QBRegistStats.h"

@implementation QBRegistStats

+ (instancetype)shareStats {
    static QBRegistStats *_stats;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stats = [[QBRegistStats alloc] init];
    });
    return _stats;
}

- (void)registStatsWithUserId:(NSString *)userId restAppId:(NSString *)restAppId restPv:(NSString *)restPv {
    [QBRegistStats shareStats].useId = userId;
    [QBRegistStats shareStats].restAppId = restAppId;
    [QBRegistStats shareStats].restPv = restPv;
}

- (void)setServeTest {
    [QBRegistStats shareStats].testServe = YES;
}

@end
