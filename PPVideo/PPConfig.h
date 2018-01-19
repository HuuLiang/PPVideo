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
#define PP_REST_PV                  @"232"
#define PP_PAYMENT_PV               @"204"
#define PP_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define PP_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define PP_BUNDLE_IDENTIFIER        ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"]))
#define PP_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", LSJ_REST_APPID, LSJ_CHANNEL_NO]

#define PP_BASE_URL                    @"http://spiv.jlswz.com"//@"http://120.24.252.114:8093"
#define PP_STANDBY_BASE_URL            @"http://sfs.dswtg.com"

#define PP_ACTIVATION_URL              @"/iosvideo/activat.htm"
#define PP_ACCESS_URL                  @"/iosvideo/userAccess.htm"
#define PP_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"

#define PP_TRAIL_URL                   @"/iosvideo/homePage.htm"
#define PP_VIPA_URL                    @"/iosvideo/vipVideo.htm"
#define PP_VIPB_URL                    @"/iosvideo/zsVipVideo.htm"
#define PP_VIPC_URL                    @"/iosvideo/hjVipVideo.htm"
#define PP_SEX_URL                     @"/iosvideo/channelRanking.htm"
#define PP_HOT_URL                     @"/iosvideo/hotTag.htm"
#define PP_SEARCH_URL                  @"/iosvideo/search.htm"
#define PP_DETAIL_URL                  @"/iosvideo/detailsg.htm"

#define PP_DOMAINS_URL                 @"/domains"
#define PP_PINGDOMAINS_URL             @"/pingdomain"

#define PP_VERSION_UPDATE_URL          @"/iosvideo/versionCheck.htm"

#define PP_APP_URL                     @"/iosvideo/appSpreadList.htm"
#define PP_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define PP_UMENG_APP_ID                @"580de5dbae1bf85293000504"

#endif /* PPConfig_h */
