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
#import "JQKApplicationManager.h"
#import "PPBaseViewController.h"
#import "PPAppSpreadBannerModel.h"
#import "PPSpreadBannerViewController.h"

static NSString *const kRegisterKeyName         = @"PP_register_keyname";
static NSString *const kUserAccessUsername      = @"PP_user_access_username";
static NSString *const kUserAccessServicename   = @"PP_user_access_service";
static NSString *const kLaunchSeqKeyName        = @"PP_launchseq_keyname";

static NSString *const kImageTokenKeyName       = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword = @"wafei@#$%^%$^$wfsssfsf";

static NSString *const kVipUserKeyName          = @"PPVideo_Vip_UserKey";

static NSString *const kUserNickKeyName         = @"kPPUserNickKeyName";
static NSString *const kUserImageKeyName        = @"kPPUserImageKeyName";

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

#pragma mark - 时间格式转换

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)currentTimeStringWithFormat:(NSString *)timeFormat {
    NSDateFormatter *fomatter =[[NSDateFormatter alloc] init];
    [fomatter setDateFormat:timeFormat];
    return [fomatter stringFromDate:[NSDate date]];
}

+ (NSString *)UTF8DateStringFromString:(NSDate *)date {
//    NSDateFormatter *dateFormatterA = [[NSDateFormatter alloc] init];
//    [dateFormatterA setDateFormat:@"yyyyMMdd"];
    
    NSDateFormatter *dateFormatterB = [[NSDateFormatter alloc] init];
    [dateFormatterB setDateFormat:@"yyyy年MM月dd日"];
    
//    QBLog(@"%@",[dateFormatterA dateFromString:dateString]);
//    QBLog(@"%@",[dataFormatterB stringFromDate:[dateFormatterA dateFromString:dateString]]);
    return [dateFormatterB stringFromDate:date];
//    return [dataFormatterB stringFromDate:[dateFormatterA dateFromString:dateString]];
}

+ (NSString *)compareCurrentTime:(NSString *)compareDateString
{
    NSDate *compareDate = [self dateFromString:compareDateString];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

#pragma mark - app检查

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL installed = [[[JQKApplicationManager defaultManager] allInstalledAppIdentifiers] bk_any:^BOOL(id obj) {
            return [bundleId isEqualToString:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(installed);
            }
        });
    });
}

#pragma makr - 订单检查
+ (NSArray<QBPaymentInfo *> *)allPaymentInfos {
    return [QBPaymentInfo allPaymentInfos];
}

+ (NSArray<QBPaymentInfo *> *)payingPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusPaying;
    }];
}

+ (NSArray<QBPaymentInfo *> *)paidNotProcessedPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusNotProcessed;
    }];
}

+ (NSArray<QBPaymentInfo *> *)allSuccessfulPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        if (paymentInfo.paymentResult == QBPayResultSuccess) {
            return YES;
        }
        return NO;
    }];
}

+ (NSArray<QBPaymentInfo *> *)allUnsuccessfulPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        if (paymentInfo.paymentResult != QBPayResultSuccess) {
            return YES;
        }
        return NO;
    }];
}

#pragma mark - ...
+ (NSString *)paymentReservedData {
    return [NSString stringWithFormat:@"%@$%@", PP_REST_APPID, PP_CHANNEL_NO];
}

+ (NSString *)getUserNickName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserNickKeyName];
}

+ (void)setUserNickName:(NSString *)nickName {
    [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:kUserNickKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIImage *)getUserImage {
    return [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserImageKeyName]];
}

+ (void)setUserImage:(UIImage *)userImage {
    NSData *data;
    if (UIImagePNGRepresentation(userImage) == nil) {
        data = UIImageJPEGRepresentation(userImage, 1);
    } else {
        data = UIImagePNGRepresentation(userImage);
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserImageKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSUInteger)currentTabPageIndex {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        if (tabVC.selectedIndex == tabVC.childViewControllers.count - 1) {
            //我
            return 6;
        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 2) {
            //热搜
            return 5;
        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 3) {
            //撸点
            return 4;
        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 4) {
            //vipC 3 vipB 3 vipA 2 vipNone 1
            if ([PPUtil currentVipLevel] == PPVipLevelVipC) {
                return 3;
            } else {
                return [PPUtil currentVipLevel] + 1;
            }
        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 5) {
            //vipC null vipB 2 vipA 1 vipNone 0
            return [PPUtil currentVipLevel];
        }
    }
    return 0;
}

+ (NSUInteger)currentSubTabPageIndex {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVC = (UINavigationController *)tabVC.selectedViewController;
            if ([navVC.visibleViewController isKindOfClass:[PPBaseViewController class]]) {
                return NSNotFound;
            }
        }
    }
    return NSNotFound;
}

+ (void)showSpreadBanner {
    if ([PPAppSpreadBannerModel sharedModel].fetchedSpreads) {
        [self showBanner];
    }else{
        [[PPAppSpreadBannerModel sharedModel] fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
            if (success) {
                [self showBanner];
            }
        }];
    }
}

+ (void)showBanner {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *spreads = [PPAppSpreadBannerModel sharedModel].fetchedSpreads;
        NSArray *allInstalledAppIds = [[JQKApplicationManager defaultManager] allInstalledAppIdentifiers];
        NSArray *uninstalledSpreads = [spreads bk_select:^BOOL(id obj) {
            return ![allInstalledAppIds containsObject:[obj specialDesc]];
        }];
        
        if (uninstalledSpreads.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                PPSpreadBannerViewController *spreadVC = [[PPSpreadBannerViewController alloc] initWithSpreads:uninstalledSpreads];
                [spreadVC showInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            });
        }
    });
}

+ (NSString *)notiLabelStrWithCurrentVipLevel {
    NSString *str = nil;
    if ([self currentVipLevel] == PPVipLevelNone) {
        str = @"开通黄金会员即可观看完整视频";
    } else if ([self currentVipLevel] == PPVipLevelVipA) {
        str = @"升级钻石会员观看完整高清视频";
    } else if ([self currentVipLevel] == PPVipLevelVipB) {
        str = @"升级黑金会员观看完整超清视频";
    }
    return str;
}

+ (NSString *)notiAlertStrWithCurrentVipLevel {
    NSString *str = nil;
    if ([self currentVipLevel] == PPVipLevelNone) {
        str = @"非会员只能观看前20秒，成为会员后观看完整版视频";
    } else if ([self currentVipLevel] == PPVipLevelVipA) {
        str = @"升级为钻石会员，可观看上千部完整版高清视频";
    } else if ([self currentVipLevel] == PPVipLevelVipB) {
        str = @"升级为黑金会员，享完整日本最新超清AV大片";
    }
    return str;
}

@end
