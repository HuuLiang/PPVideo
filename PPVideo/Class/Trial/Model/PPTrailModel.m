//
//  PPTrailModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrailModel.h"

@implementation PPTrailReponse

- (Class)columnListElementClass {
    return [PPColumnModel class];
}

@end

@implementation PPTrailModel

+ (Class)responseClass {
    return [PPTrailReponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchTrailInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:PP_TRAIL_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_TRAIL_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        PPTrailReponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            [PPCacheModel updateTrailCacheWithColumnInfo:resp.columnList];
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.columnList);
        }
    }];
    
    return success;
}

@end
