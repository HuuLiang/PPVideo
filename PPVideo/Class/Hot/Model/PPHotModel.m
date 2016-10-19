//
//  PPHotModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPHotModel.h"

@implementation PPHotReponse

- (Class)hotSearchElementClass {
    return [PPProgramModel class];
}

- (Class)tagsElementClass {
    return [PPHotReponse class];
}

@end

@implementation PPHotModel

+ (Class)responseClass {
    return [PPHotReponse class];
}

- (BOOL)fetchHotInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:PP_HOT_URL
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPHotReponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp);
                        }
                        
                    }];
    
    return success;
}

@end
