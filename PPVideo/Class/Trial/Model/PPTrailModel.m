//
//  PPTrailModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrailModel.h"

@implementation PPTrailReponse



@end

@implementation PPTrailModel

+ (Class)responseClass {
    return [PPTrailReponse class];
}

- (BOOL)fetchTrailInfoWithCompletionHandler:(QBCompletionHandler)handler {
    
    BOOL success = [self requestURLPath:nil
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus == QBURLResponseSuccess) {
            
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,nil);
        }
        
    }];
    
    return success;
}

@end
