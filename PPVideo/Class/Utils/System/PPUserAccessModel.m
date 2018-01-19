//
//  PPUserAccessModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPUserAccessModel.h"

@implementation PPUserAccessModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static PPUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[PPUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)requestUserAccess {
    NSString *userId = [PPUtil userId];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:PP_ACCESS_URL
                      standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_ACCESS_URL params:nil]
                          withParams:@{@"userId":userId,@"accessId":[PPUtil accessId]}
                     responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    
                    BOOL success = NO;
                    if (respStatus == QBURLResponseSuccess) {
                        NSString *resp = self.response;
                        success = [resp isEqualToString:@"SUCCESS"];
                        if (success) {
                            QBLog(@"Record user access!");
                        }
                    }
                }];
    return ret;
}


@end
