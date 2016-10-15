//
//  PPUtil.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPaymentInfoKeyName;

@interface PPUtil : NSObject

+ (NSString *)accessId;
+ (NSString *)userId;
+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;
+ (void)accumateLaunchSeq;

+ (BOOL)isIpad;

+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;

+ (NSString *)appVersion;
+ (NSString *)deviceName;
+ (PPDeviceType)deviceType;

+ (void)registerVip:(PPVipLevel)vipLevel;
+ (BOOL)isVip;
+ (PPVipLevel)currentVipLevel;

@end
