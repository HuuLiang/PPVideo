//
//  PPSearchModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSearchModel.h"

@implementation PPSearchProgramModel


@end

@implementation PPSearchResponse

- (Class)programListElementClass {
    return [PPSearchProgramModel class];
}
@end

@implementation PPSearchModel

+ (Class)responseClass {
    return [PPSearchResponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchSearchInfoWithTagStr:(NSString *)tagStr CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"word":tagStr,
                           @"searchTag":@(1)};
    
    @weakify(self);
    BOOL success = [self requestURLPath:PP_SEARCH_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_SEARCH_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPSearchResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp.programList);
                        }
                    }];
    
    return success;
}


@end
