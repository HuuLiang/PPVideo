//
//  PPVipModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVipModel.h"

@implementation PPVipReponse



@end

@implementation PPVipModel

+ (Class)responseClass {
    return [PPVipReponse class];
}

- (BOOL)fetchVipInfoWithVipLevel:(PPVipLevel)vipLevel CompletionHandler:(QBCompletionHandler)handler {
    NSString *urlStr = nil;
    if (vipLevel == PPVipLevelVipA) {
        urlStr = @"";
    } else if (vipLevel == PPVipLevelVipB) {
        urlStr = @"";
    } else if (vipLevel == PPVipLevelVipC) {
        urlStr = @"";
    }
    
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
