//
//  PPCommonDef.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#ifndef PPCommonDef_h
#define PPCommonDef_h

typedef NS_ENUM(NSUInteger, PPDeviceType) {
    PPDeviceTypeUnknown,
    PPDeviceType_iPhone4,
    PPDeviceType_iPhone4S,
    PPDeviceType_iPhone5,
    PPDeviceType_iPhone5C,
    PPDeviceType_iPhone5S,
    PPDeviceType_iPhone6,
    PPDeviceType_iPhone6P,
    PPDeviceType_iPhone6S,
    PPDeviceType_iPhone6SP,
    PPDeviceType_iPhoneSE,
    PPDeviceType_iPhone7,
    PPDeviceType_iPhone7P,
    PPDeviceType_iPad = 100
};

typedef NS_ENUM(NSInteger ,PPVipLevel) {
    PPVipLevelNone,
    PPVipLevelVipA,
    PPVipLevelVipB,
    PPVipLevelVipC
};

#define tableViewCellheight  MAX(kScreenHeight*0.06,44)
#define kPaidNotificationName             @"PPVideoPaidNotification"

#define kTimeFormatShort                  @"yyyyMMdd"
#define KTimeFormatLong                   @"yyyyMMddHHmmss"
#define kWidth(width)                     kScreenWidth  * width  / 750
#define kHeight(height)                   kScreenHeight * height / 1334.
#define kIOS_VERSION  ([[[UIDevice currentDevice] systemVersion] floatValue])


#define PP_SYSTEM_CONTACT_NAME_1          @"CONTACT_NAME_1"
#define PP_SYSTEM_CONTACT_NAME_2          @"CONTACT_NAME_2"
#define PP_SYSTEM_CONTACT_NAME_3          @"CONTACT_NAME_3"
#define PP_SYSTEM_CONTACT_SCHEME_1          @"CONTACT_SCHEME_1"
#define PP_SYSTEM_CONTACT_SCHEME_2          @"CONTACT_SCHEME_2"
#define PP_SYSTEM_CONTACT_SCHEME_3          @"CONTACT_SCHEME_3"
#define PP_SYSTEM_IMAGE_TOKEN             @"IMG_REFERER"
#define PP_SYSTEM_PAY_HJ_AMOUNT           @"PAY_HJ_AMOUNT"
#define PP_SYSTEM_PAY_ZS_AMOUNT           @"PAY_ZS_AMOUNT"
#define PP_SYSTEM_PAY_AMOUNT              @"PAY_AMOUNT"
#define PP_SYSTEM_BAIDUYU_CODE            @"BAIDUYU_CODE"
#define PP_SYSTEM_BAIDUYU_URL             @"BAIDUYU_URL"
#define PP_SYSTEM_TIMEOUT_URL             @"TIME_OUT"
#define PP_SYSTEM_EXPIRE_TIME             @"EXPIRE_TIME"
#define PP_SYSTEM_VIDEO_SIGN_KEY          @"VIDEO_SIGN_KEY"
#define PP_SYSTEM_MAX_DISCOUNT            @"MAX_DISCOUNT_AMOUNT"

//#define PP_SYSTEM_MINE_IMG                @"MINE_IMG"
//#define PP_SYSTEM_SVIP_PAY_AMOUNT         @"SVIP_PAY_AMOUNT"
//#define PP_SYSTEM_PAY_IMG                 @"PAY_IMG"
//#define PP_SYSTEM_SVIP_PAY_IMG            @"SVIP_PAY_IMG"

#endif /* PPCommonDef_h */
