//
//  QBStatsBaseModel.h
//  QBuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "QBDefines.h"
#import "DBHandler.h"
#import "QBStatsUrl.h"
#import "QBRegistStats.h"

typedef NS_ENUM(NSUInteger, QBStatsType) {
    QBStatsTypeUnknown,
    QBStatsTypeColumnCPC,
    QBStatsTypeProgramCPC,
    QBStatsTypeTabCPC,
    QBStatsTypeTabPanning,
    QBStatsTypeTabStay,
    QBStatsTypeBannerPanning,
    QBStatsTypePay = 1000
};

typedef NS_ENUM(NSInteger, QBStatsNetwork) {
    QBStatsNetworkUnknown = 0,
    QBStatsNetworkWifi = 1,
    QBStatsNetwork2G = 2,
    QBStatsNetwork3G = 3,
    QBStatsNetwork4G = 4,
    QBStatsNetworkOther = -1
};

@interface QBStatsInfo : DBPersistence

// Unique ID
@property (nonatomic) NSNumber *statsId;

// System Info
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *pv;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *osv;

// Tab/Column/Program
@property (nonatomic) NSNumber *tabpageId;
@property (nonatomic) NSNumber *subTabpageId;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSNumber *programType;
@property (nonatomic) NSNumber *programLocation;
@property (nonatomic) NSNumber *statsType; //QBStatsType

// Accumalation stats
@property (nonatomic) NSNumber *clickCount;
@property (nonatomic) NSNumber *slideCount;
@property (nonatomic) NSNumber *stopDuration;

// Payment
@property (nonatomic) NSNumber *isPayPopup;
@property (nonatomic) NSNumber *isPayPopupClose;
@property (nonatomic) NSNumber *isPayConfirm;
@property (nonatomic) NSNumber *payStatus;
@property (nonatomic) NSNumber *paySeq;
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSNumber *network; //QBStatsNetwork
//
+ (NSArray<QBStatsInfo *> *)allStatsInfos;
+ (NSArray<QBStatsInfo *> *)statsInfosWithStatsType:(QBStatsType)statsType;
+ (NSArray<QBStatsInfo *> *)statsInfosWithStatsType:(QBStatsType)statsType tabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;
+ (void)removeStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos;

- (BOOL)save;
- (BOOL)removeFromDB;
- (NSDictionary *)RESTData;
- (NSDictionary *)umengAttributes;

@end

@interface QBStatsResponse : QBURLResponse
@property (nonatomic) NSNumber *errCode;
@end

@interface QBStatsBaseModel : QBEncryptedURLRequest

- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos;
- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<QBStatsInfo *> *)statsInfos shouldIncludeStatsType:(BOOL)includeStatsType;

@end
