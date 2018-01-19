//
//  PPUtil.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPaymentInfoKeyName;

@class PPAppSpread;
@class QBPaymentConfig;

@interface PPUtil : NSObject

+ (NSString *)accessId;
+ (NSString *)userId;
+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;
+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;

+ (BOOL)isIpad;
+ (NSString *)appVersion;
+ (NSString *)deviceName;
+ (PPDeviceType)deviceType;

+ (void)registerVip:(PPVipLevel)vipLevel;
+ (BOOL)isVip;
+ (PPVipLevel)currentVipLevel;

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)currentTimeStringWithFormat:(NSString *)timeFormat;
+ (NSString *)UTF8DateStringFromString:(NSDate *)date;
+ (NSString *)compareCurrentTime:(NSString *)compareDateString;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;

+ (NSArray<QBPaymentInfo *> *)allPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)allSuccessfulPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)allUnsuccessfulPaymentInfos;;

+ (NSString *)paymentReservedData;
+ (NSString *)getUserNickName;
+ (void)setUserNickName:(NSString *)nickName;
+ (UIImage *)getUserImage;
+ (void)setUserImage:(UIImage *)userImage;
+ (NSUInteger)currentTabPageIndex;
+ (NSUInteger)currentSubTabPageIndex;
+ (void)showSpreadBanner;
+ (void)getSpreadeBannerInfo;
+ (void)showBanner;
+ (NSArray <PPAppSpread *> *)getUnInstalledSpreads;

+ (NSString *)notiLabelStrWithCurrentVipLevel;
+ (NSString *)notiAlertStrWithCurrentVipLevel;

+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(NSDictionary *)params;

+ (QBPaymentConfig *)setDefaultPaymentConfig;

+ (NSString *)encodeVideoUrlWithVideoUrlStr:(NSString *)videoUrlSt;

+ (void)checkVersionUpdate;

@end
