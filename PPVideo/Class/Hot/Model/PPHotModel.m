//
//  PPHotModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPHotModel.h"

static NSString *const kPPVideoHotColumnIdKeyName       = @"PP_HotColumnId_KeyName";
static NSString *const kPPVideoHotSearchKeyName         = @"PP_HotSearch_KeyName";
static NSString *const kPPVideoHotHsColumnIdKeyName     = @"PP_HsColumnId_KeyName";
static NSString *const kPPVideoHotHsRealColumnIdKeyName = @"PP_HsRealColumnId_KeyName";
static NSString *const kPPVideoHotRealColumnIdKeyName   = @"PP_HotRealColumnId_KeyName";
static NSString *const kPPVideoHotTagsKeyName           = @"PP_HotTags_KeyName";

@implementation PPHotReponse

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.columnId = [[coder decodeObjectForKey:kPPVideoHotColumnIdKeyName] integerValue];;
        self.hotSearch = [coder decodeObjectForKey:kPPVideoHotSearchKeyName];
        self.hsColumnId = [[coder decodeObjectForKey:kPPVideoHotHsColumnIdKeyName] integerValue];;
        self.hsRealColumnId = [[coder decodeObjectForKey:kPPVideoHotHsRealColumnIdKeyName] integerValue];;
        self.realColumnId = [[coder decodeObjectForKey:kPPVideoHotRealColumnIdKeyName] integerValue];;
        self.tags = [coder decodeObjectForKey:kPPVideoHotTagsKeyName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.columnId] forKey:kPPVideoHotColumnIdKeyName];
    [aCoder encodeObject:self.hotSearch forKey:kPPVideoHotSearchKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.hsColumnId] forKey:kPPVideoHotHsColumnIdKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.hsRealColumnId] forKey:kPPVideoHotHsRealColumnIdKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.realColumnId] forKey:kPPVideoHotRealColumnIdKeyName];
    [aCoder encodeObject:self.tags forKey:kPPVideoHotTagsKeyName];
}

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

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchHotInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:PP_HOT_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_HOT_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPHotReponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                            [PPCacheModel updateHotCacheWitnHotInfo:resp];
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp);
                        }
                        
                    }];
    
    return success;
}

@end
