//
//  PPAppModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPAppModel.h"

static NSString *const kPPVideoAppCoverImgKeyName           = @"PP_AppCoverImg_KeyName";
static NSString *const kPPVideoAppPkgNameKeyName            = @"PP_AppPkgName_KeyName";
static NSString *const kPPVideoAppPostTimeKeyName           = @"PP_AppPostTime_KeyName";
static NSString *const kPPVideoAppProgramIdKeyName          = @"PP_AppProgramId_KeyName";
static NSString *const kPPVideoAppVideoUrlKeyName           = @"PP_AppVideoUrl_KeyName";
static NSString *const kPPVideoAppOffUrlKeyName             = @"PP_AppOffUrl_KeyName";
static NSString *const kPPVideoAppTitleKeyName              = @"PP_AppTitle_KeyName";
static NSString *const kPPVideoAppTypeKeyName               = @"PP_AppType_KeyName";
static NSString *const kPPVideoAppSpecialDescKeyName        = @"PP_AppSpecialDesc_KeyName";
static NSString *const kPPVideoAppSpreadImgKeyName          = @"PP_AppSpreadImg_KeyName";


@implementation PPAppSpread

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.coverImg = [coder decodeObjectForKey:kPPVideoAppCoverImgKeyName];
        self.pkgName = [coder decodeObjectForKey:kPPVideoAppPkgNameKeyName];
        self.postTime = [coder decodeObjectForKey:kPPVideoAppPostTimeKeyName];
        self.programId = [[coder decodeObjectForKey:kPPVideoAppProgramIdKeyName] integerValue];
        self.videoUrl = [coder decodeObjectForKey:kPPVideoAppVideoUrlKeyName];
        self.offUrl = [coder decodeObjectForKey:kPPVideoAppOffUrlKeyName];
        self.title = [coder decodeObjectForKey:kPPVideoAppTitleKeyName];
        self.type = [[coder decodeObjectForKey:kPPVideoAppTypeKeyName] integerValue];
        self.specialDesc = [coder decodeObjectForKey:kPPVideoAppSpecialDescKeyName];
        self.spreadImg = [coder decodeObjectForKey:kPPVideoAppSpreadImgKeyName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.coverImg forKey:kPPVideoAppCoverImgKeyName];
    [aCoder encodeObject:self.pkgName forKey:kPPVideoAppPkgNameKeyName];
    [aCoder encodeObject:self.postTime forKey:kPPVideoAppPostTimeKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.programId] forKey:kPPVideoAppProgramIdKeyName];
    [aCoder encodeObject:self.videoUrl forKey:kPPVideoAppVideoUrlKeyName];
    [aCoder encodeObject:self.offUrl forKey:kPPVideoAppOffUrlKeyName];
    [aCoder encodeObject:self.title forKey:kPPVideoAppTitleKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:kPPVideoAppTypeKeyName];
    [aCoder encodeObject:self.specialDesc forKey:kPPVideoAppSpecialDescKeyName];
    [aCoder encodeObject:self.spreadImg forKey:kPPVideoAppSpreadImgKeyName];
}
@end


@implementation PPAppResponse
- (Class)programListElementClass {
    return [PPAppSpread class];
}

@end

@implementation PPAppModel

+ (Class)responseClass {
    return [PPAppResponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:PP_APP_URL
                     standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_APP_URL params:nil]
                         withParams:nil
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    PPAppResponse *resp = nil;
//                    NSArray *array = nil;
                    if (respStatus == QBURLResponseSuccess) {
                        resp = self.response;
                        [PPCacheModel updateAppCacheWithAppInfo:resp.programList];
//                        array = [NSArray arrayWithArray:resp.programList];
//                        _fetchedSpreads = [[NSMutableArray alloc] init];
                    }
//                    else {
//                        if (handler) {
//                            handler(QBURLResponseFailedByInterface,nil);
//                        }
//                    }
                    if (handler) {
                        handler(QBURLResponseFailedByInterface,resp);
                    }

//                    for (NSInteger i = 0; i < array.count; i++) {
//                        PPAppSpread *app = array[i];
//                        [PPUtil checkAppInstalledWithBundleId:app.specialDesc completionHandler:^(BOOL isInstall) {
//                            if (isInstall) {
//                                app.isInstall = isInstall;
//                                [_fetchedSpreads addObject:app];
//                            } else {
//                                [_fetchedSpreads insertObject:app atIndex:0];
//                            }
//                            if (_fetchedSpreads.count == array.count) {
//                                if (handler) {
//                                    [PPCacheModel updateAppCacheWithAppInfo:_fetchedSpreads];
//                                    resp.programList = _fetchedSpreads;
//                                    handler(respStatus == QBURLResponseSuccess, resp);
//                                }
//                            }
//                        }];
//                        
//                    }
                }];
    return ret;
}

@end

