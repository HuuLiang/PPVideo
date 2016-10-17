//
//  PPUtil.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>


static NSString *const kRegisterKeyName         = @"PP_register_keyname";
static NSString *const kUserAccessUsername      = @"PP_user_access_username";
static NSString *const kUserAccessServicename   = @"PP_user_access_service";
static NSString *const kLaunchSeqKeyName        = @"PP_launchseq_keyname";

static NSString *const kImageTokenKeyName       = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword = @"wafei@#$%^%$^$wfsssfsf";

static NSString *const kVipUserKeyName          = @"PPVideo_Vip_UserKey";

@implementation PPUtil

#pragma mark -- 注册激活

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}

+ (BOOL)isRegistered {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSUInteger)launchSeq {
    NSNumber *launchSeq = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchSeqKeyName];
    return launchSeq.unsignedIntegerValue;
}

+ (void)accumateLaunchSeq {
    NSUInteger launchSeq = [self launchSeq];
    [[NSUserDefaults standardUserDefaults] setObject:@(launchSeq+1) forKey:kLaunchSeqKeyName];
}

#pragma mark - 图片加密

+ (NSString *)imageToken {
    NSString *imageToken = [[NSUserDefaults standardUserDefaults] objectForKey:kImageTokenKeyName];
    if (!imageToken) {
        return nil;
    }
    
    return [imageToken decryptedStringWithPassword:kImageTokenCryptPassword];
}

+ (void)setImageToken:(NSString *)imageToken {
    if (imageToken) {
        imageToken = [imageToken encryptedStringWithPassword:kImageTokenCryptPassword];
        [[NSUserDefaults standardUserDefaults] setObject:imageToken forKey:kImageTokenKeyName];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kImageTokenKeyName];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 设备类型

+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}

+ (PPDeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return PPDeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return PPDeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return PPDeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return PPDeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return PPDeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return PPDeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return PPDeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return PPDeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return PPDeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return PPDeviceType_iPhoneSE;
    }else if ([deviceName rangeOfString:@"iPhone9,1"].location == 0){
        return PPDeviceType_iPhone7;
    }else if ([deviceName rangeOfString:@"iPhone9,2"].location == 0){
        return PPDeviceType_iPhone7P;
    } else if ([deviceName rangeOfString:@"iPad"].location == 0) {
        return PPDeviceType_iPad;
    } else {
        return PPDeviceTypeUnknown;
    }
}

#pragma mark - 会员等级

+ (void)registerVip:(PPVipLevel)vipLevel {
    [[NSUserDefaults standardUserDefaults] setObject:@(vipLevel) forKey:kVipUserKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isVip {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kVipUserKeyName] integerValue] != PPVipLevelNone;
}

+ (PPVipLevel)currentVipLevel {
    return [self isVip] ? [[[NSUserDefaults standardUserDefaults] objectForKey:kVipUserKeyName] integerValue] : PPVipLevelNone;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

#pragma mark - 时间格式转换

+ (NSString *)currentTimeString {
    NSDateFormatter *fomatter =[[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyyMMddHHmmss"];
    return [fomatter stringFromDate:[NSDate date]];
}

+ (NSString *)UTF8DateStringFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatterA = [[NSDateFormatter alloc] init];
    [dateFormatterA setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *dataFormatterB = [[NSDateFormatter alloc] init];
    [dataFormatterB setDateFormat:@"yyyy年MM月dd日"];
    
    QBLog(@"%@",[dateFormatterA dateFromString:dateString]);
    QBLog(@"%@",[dataFormatterB stringFromDate:[dateFormatterA dateFromString:dateString]]);
    
    return [dataFormatterB stringFromDate:[dateFormatterA dateFromString:dateString]];
}

@end
