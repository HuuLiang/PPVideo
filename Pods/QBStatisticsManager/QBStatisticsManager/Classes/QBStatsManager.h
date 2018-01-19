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
/**
注册数据统计
*/
- (void)registStatsManagerWithUserId:(NSString *)userId restAppId:(NSString *)restAppId restPv:(NSString *)restPv launchSeq:(NSInteger)launchSeq;
/**
 是否使用测试服务器
 */
- (void)statsUseTestServe:(BOOL)useTestServe;

- (void)addStats:(QBStatsInfo *)statsInfo;
- (void)removeStats:(NSArray<QBStatsInfo *> *)statsInfos;
/**
启动数据统计以及设置上传的时间
*/
- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval;

// Helper Methods
/**
 栏目点击统计
 */
- (void)statsCPCWithBaseModel:(QBBaseModel *)baseModel inTabIndex:(NSUInteger)tabIndex;

/**
 节目点击统计
 */
- (void)statsCPCWithBaseModel:(QBBaseModel *)baseModel
                  andTabIndex:(NSUInteger)tabIndex
                  subTabIndex:(NSUInteger)subTabIndex;

/**
 tab点击数据统计
 */
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount;
/**
 界面滑动数据统计
 */
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount;
/**
 banner滑动数据统计
 */
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount;
/**
 界面停留时间数据统计
 */
- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;

/**
 支付弹框关闭点击统计
 */
- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(QBStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
               forBaseModel:(QBBaseModel *)baseModel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;
/**
 支付跳转支付以及支付回调数据统计
 */
- (void)statsPayWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                   forPayAction:(QBStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex;

@end
