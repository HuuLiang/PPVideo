//
//  PPSexModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSexModel.h"

@implementation PPSexReponse

- (Class)columnListElementClass {
    return [PPColumnModel class];
}

@end

@implementation PPSexModel

+ (Class)responseClass {
    return [PPSexReponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchSexInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:PP_SEX_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_SEX_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        PPSexReponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            [PPCacheModel updateSexCacheWithColumnInfo:resp.columnList];
        }
                        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.columnList);
        }
                        
    }];
    
    return success;
}

@end
