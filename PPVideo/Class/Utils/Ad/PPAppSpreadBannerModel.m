//
//  PPAppSpreadBannerModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPAppSpreadBannerModel.h"

@implementation PPAppSpreadBannerResponse

- (Class)programListElementClass {
    return [PPAppSpread class];
}
@end

@implementation PPAppSpreadBannerModel

+ (instancetype)sharedModel {
    static PPAppSpreadBannerModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}
+ (Class)responseClass {
    return [PPAppSpreadBannerResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:PP_APP_SPREAD_BANNER_URL
                     standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_APP_SPREAD_BANNER_URL params:nil]
                         withParams:nil
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *fetchedSpreads;
                    if (respStatus == QBURLResponseSuccess) {
                        PPAppSpreadBannerResponse *resp = self.response;
                        _fetchedSpreads = resp.programList;
                        fetchedSpreads = _fetchedSpreads;
                        self.realColumnId = resp.realColumnId;
                        self.type = resp.type;
                    }
                    
                    if (handler) {
                        handler(respStatus==QBURLResponseSuccess, fetchedSpreads);
                    }
                }];
    return ret;
}

@end
