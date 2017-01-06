//
//  PPLiveModel.m
//  PPVideo
//
//  Created by Liang on 2017/1/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPLiveModel.h"

@implementation PPLiveReponse

- (Class)columnListElementClass {
    return [PPColumnModel class];
}

@end

@implementation PPLiveModel

+ (Class)responseClass {
    return [PPLiveReponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchLiveInfoWithPage:(NSUInteger)page CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"page":[NSNumber numberWithUnsignedInteger:page]};
    @weakify(self);
    BOOL success = [self requestURLPath:PP_LIVE_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_LIVE_URL params:nil]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPLiveReponse *resp = nil;
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
