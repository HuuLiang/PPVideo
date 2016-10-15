//
//  PPConfig.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#ifndef PPConfig_h
#define PPConfig_h

#define PP_CHANNEL_NO               [PPConfiguration sharedConfig].channelNo
#define PP_REST_APPID               @"QUBA_2026"
#define PP_REST_PV                  @"100"
#define PP_PAYMENT_PV               @"100"
#define PP_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define PP_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define PP_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", LSJ_REST_APPID, LSJ_CHANNEL_NO]

#define PP_BASE_URL                 @"http://iv.zcqcmj.com"



#define PP_ACTIVATION_URL              @"/iosvideo/activat.htm"
#define PP_ACCESS_URL                  @"/iosvideo/userAccess.htm"
#define PP_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"

#endif /* PPConfig_h */
