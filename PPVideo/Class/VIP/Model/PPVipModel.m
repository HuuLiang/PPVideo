//
//  PPVipModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVipModel.h"

@implementation PPVipModel

+ (Class)responseClass {
    return [PPColumnModel class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchVipInfoWithVipLevel:(PPVipLevel)vipLevel CompletionHandler:(QBCompletionHandler)handler {
    NSString *urlStr = nil;
    if (vipLevel == PPVipLevelVipA) {
        urlStr = PP_VIPA_URL;
    } else if (vipLevel == PPVipLevelVipB) {
        urlStr = PP_VIPB_URL;
    } else if (vipLevel == PPVipLevelVipC) {
        urlStr = PP_VIPC_URL;
    }
    @weakify(self);
    BOOL success = [self requestURLPath:urlStr
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:urlStr params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        PPColumnModel *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            [PPCacheModel updateVipCacheWithColumnInfo:resp];
        }
                        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp);
        }
                        
    }];
    
    return success;
}

@end
