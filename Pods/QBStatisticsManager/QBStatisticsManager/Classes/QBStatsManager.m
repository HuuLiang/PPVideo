//
//  QBStatsManager.m
//  QBuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBStatsManager.h"
#import "QBCPCStatsModel.h"
#import "QBTabStatsModel.h"
#import "QBPayStatsModel.h"
#import <UMMobClick/MobClick.h>
#import "QBRegistStats.h"


static NSString *const kUmengCPCChannelEvent = @"CPC_CHANNEL";
static NSString *const kUmengCPCProgramEvent = @"CPC_PROGRAM";
static NSString *const kUmengTabEvent = @"TAB_STATS";
static NSString *const kUmengPayEvent = @"PAY_STATS";

@interface QBStatsManager ()
@property (nonatomic,retain) dispatch_queue_t queue;
@property (nonatomic,retain,readonly) QBCPCStatsModel *cpcStats;
@property (nonatomic,retain,readonly) QBTabStatsModel *tabStats;
@property (nonatomic,retain,readonly) QBPayStatsModel *payStats;
@property (nonatomic,retain,readonly) NSDate *statsDate;
@property (nonatomic) BOOL scheduling;
@property (nonatomic,assign)NSInteger launchSeq;
@end

@implementation QBStatsManager
@synthesize cpcStats = _cpcStats;
@synthesize tabStats = _tabStats;
@synthesize payStats = _payStats;

QBDefineLazyPropertyInitialization(QBCPCStatsModel, cpcStats)
QBDefineLazyPropertyInitialization(QBTabStatsModel, tabStats)
QBDefineLazyPropertyInitialization(QBPayStatsModel, payStats)

- (void)registStatsManagerWithUserId:(NSString *)userId restAppId:(NSString *)restAppId restPv:(NSString *)restPv launchSeq:(NSInteger)launchSeq {
    [[QBRegistStats shareStats] registStatsWithUserId:userId restAppId:restAppId restPv:restPv];
    self.launchSeq = launchSeq;

}

- (void)statsUseTestServe:(BOOL)useTestServe {
    [QBRegistStats shareStats].testServe = useTestServe;
}

- (dispatch_queue_t)queue {
    if (_queue) {
        return _queue;
    }
    
    _queue = dispatch_queue_create("com.QBuaibo.app.statsq", nil);
    return _queue;
}

+ (instancetype)sharedManager {
    static QBStatsManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statsDate = [NSDate date];
    }
    return self;
}

- (void)addStats:(QBStatsInfo *)statsInfo {
    dispatch_async(self.queue, ^{
        [statsInfo save];
    });
}

- (void)removeStats:(NSArray<QBStatsInfo *> *)statsInfos {
    dispatch_async(self.queue, ^{
        [QBStatsInfo removeStatsInfos:statsInfos];
    });
}

- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval {
    if (self.scheduling) {
        return ;
    }
    
    self.scheduling = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (1) {
            dispatch_async(self.queue, ^{
                [self uploadStatsInfos:[QBStatsInfo allStatsInfos]];
            });
            sleep(timeInterval);
        }
    });
}

- (void)uploadStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos {
    if (statsInfos.count == 0) {
        return ;
    }
    
    NSArray<QBStatsInfo *> *cpcStats = [statsInfos bk_select:^BOOL(QBStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == QBStatsTypeColumnCPC
        || statsInfo.statsType.unsignedIntegerValue == QBStatsTypeProgramCPC;
    }];
    
    NSArray<QBStatsInfo *> *tabStats = [statsInfos bk_select:^BOOL(QBStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == QBStatsTypeTabCPC
        || statsInfo.statsType.unsignedIntegerValue == QBStatsTypeTabPanning
        || statsInfo.statsType.unsignedIntegerValue == QBStatsTypeTabStay
        || statsInfo.statsType.unsignedIntegerValue == QBStatsTypeBannerPanning;
    }];
    
    NSArray<QBStatsInfo *> *payStats = [statsInfos bk_select:^BOOL(QBStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == QBStatsTypePay;
    }];
    
    if (cpcStats.count > 0) {
        QBLog(@"Commit CPC stats...");
        [self.cpcStats statsCPCWithStatsInfos:cpcStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [QBStatsInfo removeStatsInfos:cpcStats];
                QBLog(@"Commit CPC stats successfully!");
            } else {
                QBLog(@"Commit CPC stats with failure: %@", obj);
            }
        }];
    }
    
    if (tabStats.count > 0) {
        QBLog(@"Commit TAB stats...");
        [self.tabStats statsTabWithStatsInfos:tabStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [QBStatsInfo removeStatsInfos:tabStats];
                QBLog(@"Commit TAB stats successfully");
            } else {
                QBLog(@"Commint TAB stats with failure: %@", obj);
            }
        }];
    }
    
    if (payStats.count > 0) {
        QBLog(@"Commit PAY stats...");
        [self.payStats statsPayWithStatsInfos:payStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [QBStatsInfo removeStatsInfos:payStats];
                QBLog(@"Commit PAY stats successfully!");
            } else {
                QBLog(@"Commit PAY stats with failure: %@", obj);
            }
        }];
    }
}

- (void)statsCPCWithBaseModel:(QBBaseModel *)baseModel inTabIndex:(NSUInteger)tabIndex {
    QBStatsInfo *statsInfo = [[QBStatsInfo alloc] init];
    statsInfo.tabpageId = @(tabIndex+1);
    statsInfo.columnId = baseModel.realColumnId;
    statsInfo.columnType = baseModel.channelType;
    statsInfo.statsType = @(QBStatsTypeColumnCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCChannelEvent attributes:[statsInfo umengAttributes]];
}

- (void)statsCPCWithBaseModel:(QBBaseModel *)baseModel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    QBStatsInfo *statsInfo = [[QBStatsInfo alloc] init];
    if (baseModel) {
        statsInfo.columnId = baseModel.realColumnId;
        statsInfo.columnType = baseModel.channelType;
    }
    statsInfo.tabpageId = @(tabIndex+1);
    if (subTabIndex != NSNotFound) {
        statsInfo.subTabpageId = @(subTabIndex+1);
    }
    
    statsInfo.programId = baseModel.programId;
    statsInfo.programType = baseModel.programType;
    statsInfo.programLocation = @(baseModel.programLocation.integerValue+1);
    statsInfo.statsType = @(QBStatsTypeProgramCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCProgramEvent attributes:statsInfo.umengAttributes];
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount {
    dispatch_async(self.queue, ^{
        NSArray<QBStatsInfo *> *statsInfos = [QBStatsInfo statsInfosWithStatsType:QBStatsTypeTabCPC tabIndex:tabIndex subTabIndex:subTabIndex];
        QBStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[QBStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(QBStatsTypeTabCPC);
        }
        
        statsInfo.clickCount = @(statsInfo.clickCount.unsignedIntegerValue + clickCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<QBStatsInfo *> *statsInfos = [QBStatsInfo statsInfosWithStatsType:QBStatsTypeTabPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        QBStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[QBStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(QBStatsTypeTabPanning);
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex {
    dispatch_async(self.queue, ^{
        NSArray<QBStatsInfo *> *statsInfos = [QBStatsInfo statsInfosWithStatsType:QBStatsTypeTabStay tabIndex:tabIndex subTabIndex:subTabIndex];
        QBStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[QBStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(QBStatsTypeTabStay);
        }
        
        NSUInteger durationSinceStats = [[NSDate date] timeIntervalSinceDate:self.statsDate];
        statsInfo.stopDuration = @(statsInfo.stopDuration.unsignedIntegerValue + durationSinceStats);
        [statsInfo save];
        
        [self resetStatsDate];
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<QBStatsInfo *> *statsInfos = [QBStatsInfo statsInfosWithStatsType:QBStatsTypeBannerPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        QBStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[QBStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            statsInfo.statsType = @(QBStatsTypeBannerPanning);
            statsInfo.columnId = bannerColumnId;
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)resetStatsDate {
    _statsDate = [NSDate date];
}

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(QBStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
               forBaseModel:(QBBaseModel *)baseModel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        QBStatsInfo *statsInfo = [[QBStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = baseModel.realColumnId;
        statsInfo.columnType = baseModel.channelType;
        statsInfo.programId = baseModel.programId;
        statsInfo.programType = baseModel.programType;
        statsInfo.programLocation = @(baseModel.programLocation.integerValue+1);
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = orderNo;
        if (payAction == QBStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == QBStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == QBStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultCancelled):@(3)};
            NSNumber *payStatus = payStautsMapping[@(payResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
        
        statsInfo.paySeq = @(self.launchSeq);
        statsInfo.statsType = @(QBStatsTypePay);
        statsInfo.network = @([QBNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsPayWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                   forPayAction:(QBStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        QBStatsInfo *statsInfo = [[QBStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = paymentInfo.columnId;
        statsInfo.columnType = paymentInfo.columnType;
        statsInfo.programId = paymentInfo.contentId;
        statsInfo.programType = paymentInfo.contentType;
        statsInfo.programLocation = paymentInfo.contentLocation;
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = paymentInfo.orderId;
        if (payAction == QBStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == QBStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == QBStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultCancelled):@(3)};
            NSNumber *payStatus = payStautsMapping[@(paymentInfo.paymentResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
    
        statsInfo.paySeq = @(self.launchSeq);
        statsInfo.statsType = @(QBStatsTypePay);
           statsInfo.network = @([QBNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

@end
