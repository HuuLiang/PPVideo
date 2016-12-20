//
//  PPVersionUpdateModel.m
//  PPVideo
//
//  Created by Liang on 2016/12/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVersionUpdateModel.h"

@implementation PPVersionUpdateInfo

@end


@implementation PPVersionUpdateModel

+ (instancetype)sharedModel {
    static PPVersionUpdateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

+ (Class)responseClass {
    return [PPVersionUpdateInfo class];
}

- (BOOL)fetchLatestVersionWithCompletionHandler:(QBCompletionHandler)completionHandler {
    @weakify(self);
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    
    BOOL ret = [self requestURLPath:PP_VERSION_UPDATE_URL
                     standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_VERSION_UPDATE_URL
                                                                      params:@{@"versionNo":currentVersion, @"packageId":bundleId}]
                         withParams:@{@"versionNo":currentVersion, @"packageId":bundleId}
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
                         @strongify(self);
                         if (!self) {
                             return ;
                         }
                         
                         PPVersionUpdateInfo *versionInfo;
                         if (respStatus == QBURLResponseSuccess) {
                             versionInfo = self.response;
                             self->_fetchedVersionInfo = versionInfo;
                         }

                        QBSafelyCallBlock(completionHandler,respStatus==QBURLResponseSuccess, versionInfo);
                     }];
    
    return ret;
}
@end

