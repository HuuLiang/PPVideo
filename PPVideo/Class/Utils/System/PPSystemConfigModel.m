//
//  PPSystemConfigModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSystemConfigModel.h"

static NSString *const kPPVideoSystemConfigPayAmountKeyName       = @"PP_SystemConfigPayAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayzsAmountKeyName       = @"PP_SystemConfigPayzsAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayhjAmountKeyName       = @"PP_SystemConfigPayhjAmount_KeyName";

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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.payAmount = [[coder decodeObjectForKey:kPPVideoSystemConfigPayAmountKeyName] integerValue];
        self.payzsAmount = [[coder decodeObjectForKey:kPPVideoSystemConfigPayzsAmountKeyName] integerValue];
        self.payhjAmount = [[coder decodeObjectForKey:kPPVideoSystemConfigPayhjAmountKeyName] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.payAmount] forKey:kPPVideoSystemConfigPayAmountKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.payzsAmount] forKey:kPPVideoSystemConfigPayzsAmountKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.payhjAmount] forKey:kPPVideoSystemConfigPayhjAmountKeyName];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(PPFetchSystemConfigCompletionHandler)handler {
    
    @weakify(self);
    BOOL success = [self requestURLPath:PP_SYSTEM_CONFIG_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_SYSTEM_CONFIG_URL params:nil]
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
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_NAME_1]) {
                                    [PPSystemConfigModel sharedModel].contactName1 = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_NAME_2]) {
                                    [PPSystemConfigModel sharedModel].contactName2 = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_NAME_3]) {
                                    [PPSystemConfigModel sharedModel].contactName3 = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_SCHEME_1]) {
                                    [PPSystemConfigModel sharedModel].contactScheme1 = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_SCHEME_2]) {
                                    [PPSystemConfigModel sharedModel].contactScheme2 = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_CONTACT_SCHEME_3]) {
                                    [PPSystemConfigModel sharedModel].contactScheme3 = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_BAIDUYU_URL]) {
                                    [PPSystemConfigModel sharedModel].baiduyuUrl = config.value;
                                } else if ([config.name isEqualToString:PP_SYSTEM_BAIDUYU_CODE]) {
                                    [PPSystemConfigModel sharedModel].baiduyuCode = config.value;
                                }
                                
                                //刷新价格缓存
                                [PPCacheModel updateSystemConfigModelWithSystemConfigModel:[PPSystemConfigModel sharedModel]];
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
