//
//  PPActivateModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation PPActivateModel

+ (instancetype)sharedModel {
    static PPActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[PPActivateModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [NSString class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(LSJActivateHandler)handler {
    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
    
    NSDictionary *params = @{@"cn":PP_CHANNEL_NO,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"sms":@"00000000000",
                             @"cw":@(kScreenWidth),
                             @"ch":@(kScreenHeight),
                             @"cm":[PPUtil deviceName],
                             @"mf":[UIDevice currentDevice].model,
                             @"sdkV":sdkV,
                             @"cpuV":@"",
                             @"appV":[PPUtil appVersion],
                             @"appVN":@"",
                             @"ccn":PP_PACKAGE_CERTIFICATE,
                             @"operator":[QBNetworkInfo sharedInfo].carriarName ?: @"",
                             @"systemVersion":[UIDevice currentDevice].systemVersion};
    
    BOOL success = [self requestURLPath:PP_ACTIVATION_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_ACTIVATION_URL params:nil]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        NSString *userId;
        if (respStatus == QBURLResponseSuccess) {
            NSString *resp = self.response;
            NSArray *resps = [resp componentsSeparatedByString:@";"];
            
            NSString *success = resps.firstObject;
            if ([success isEqualToString:kSuccessResponse]) {
                userId = resps.count == 2 ? resps[1] : nil;
            }
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess && userId, userId);
        }
    }];
    return success;
}


@end
