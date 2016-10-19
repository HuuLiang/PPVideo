//
//  QBStatsManager.h
//  QBuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBBaseModel.h"
#import <QBPaymentInfo.h>
#import <QBPaymentDefines.h>
#import <QBNetworkInfo.h>

typedef NS_ENUM(NSUInteger, QBStatsPayAction) {
    QBStatsPayActionUnknown,
    QBStatsPayActionClose,
    QBStatsPayActionGoToPay,
    QBStatsPayActionPayBack
};

@class QBStatsInfo;
//@class QBChannel;
@interface QBStatsManager : NSObject

+ (instancetype)sharedManager;
- (void)registStatsManagerWithUserId:(NSString *)userId restAppId:(NSString *)restAppId restPv:(NSString *)restPv launchSeq:(NSInteger)launchSeq;

- (void)addStats:(QBStatsInfo *)statsInfo;
- (void)removeStats:(NSArray<QBStatsInfo *> *)statsInfos;
- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval;

// Helper Methods
- (void)statsCPCWithBaseModel:(QBBaseModel *)baseModel inTabIndex:(NSUInteger)tabIndex;
- (void)statsCPCWithBaseModel:(QBBaseModel *)baseModel
                  andTabIndex:(NSUInteger)tabIndex
                  subTabIndex:(NSUInteger)subTabIndex;

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount;
- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(QBStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
               forBaseModel:(QBBaseModel *)baseModel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                   forPayAction:(QBStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex;

@end
