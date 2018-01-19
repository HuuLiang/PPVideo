//
//  QBRegistStats.h
//  Pods
//
//  Created by ylz on 2016/10/15.
//
//

#import <Foundation/Foundation.h>

@interface QBRegistStats : NSObject
@property (nonatomic,copy)NSString *useId;
@property (nonatomic,copy)NSString *restAppId;
@property (nonatomic,copy)NSString *restPv;
@property (nonatomic,assign)BOOL testServe;

+ (instancetype)shareStats;
- (void)registStatsWithUserId:(NSString *)userId restAppId:(NSString *)restAppId restPv:(NSString *)restPv;
- (void)setServeTest;

@end
