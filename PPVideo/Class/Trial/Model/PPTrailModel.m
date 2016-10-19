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

- (BOOL)fetchTrailInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:PP_TRAIL_URL
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        PPTrailReponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.columnList);
        }
        
    }];
    
    return success;
}

@end
