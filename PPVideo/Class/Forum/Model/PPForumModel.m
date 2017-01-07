//
//  PPForumModel.m
//  PPVideo
//
//  Created by Liang on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPForumModel.h"

@implementation PPForumReponse

- (Class)columnListElementClass {
    return [PPColumnModel class];
}

@end

@implementation PPForumModel

+ (Class)responseClass {
    return [PPForumReponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchForumInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:PP_FORUM_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_FORUM_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPForumReponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                            [PPCacheModel updateForumCacheWithColumnInfo:resp.columnList];
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp.columnList);
                        }
                        
                    }];
    
    return success;
}


@end
