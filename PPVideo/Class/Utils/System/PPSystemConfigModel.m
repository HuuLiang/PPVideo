//
//  PPSystemConfigModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSystemConfigModel.h"

@implementation PPSystemConfigResponse

- (Class)confisElementClass {
    return [PPSystemConfig class];
}

@end

@implementation PPSystemConfigModel

+ (instancetype)sharedModel {
    static PPSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[PPSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [PPSystemConfigResponse class];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(PPFetchSystemConfigCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:PP_SYSTEM_CONFIG_URL
                             withParams:@{@"type":@([PPUtil deviceType])}
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        QBLog(@"%ld %@",respStatus,errorMessage);
                        
                        if (respStatus == QBURLResponseSuccess) {
                            PPSystemConfigResponse *resp = self.response;
                            
                            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                PPSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:PP_SYSTEM_PAY_AMOUNT]) {
                                    [PPSystemConfigModel sharedModel].payAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:PP_SYSTEM_PAY_HJ_AMOUNT]) {
                                    [PPSystemConfigModel sharedModel].payhjAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:PP_SYSTEM_PAY_ZS_AMOUNT]) {
                                    [PPSystemConfigModel sharedModel].payzsAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:PP_SYSTEM_IMAGE_TOKEN]) {
                                    [PPSystemConfigModel sharedModel].imageToken = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_NAME]) {
                                    [PPSystemConfigModel sharedModel].contactName = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_SCHEME]) {
                                    [PPSystemConfigModel sharedModel].contactScheme = config.value;
                                }
                            }];
                            _loaded = YES;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess);
                        }
                    }];
    return success;
}

@end
