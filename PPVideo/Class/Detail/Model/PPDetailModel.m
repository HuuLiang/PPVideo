//
//  PPDetailModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailModel.h"

static NSString *const kPPVideoDetailProgramOffUrlKeyName       = @"PP_DetailProgramOffUrl_KeyName";
@implementation PPDetailProgramModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.offUrl = [coder decodeObjectForKey:kPPVideoDetailProgramOffUrlKeyName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.offUrl forKey:kPPVideoDetailProgramOffUrlKeyName];
}
@end


static NSString *const kPPVideoDetailCommentContentKeyName          = @"PP_DetailCommentContent_KeyName";
static NSString *const kPPVideoDetailCommentCreatAtKeyName          = @"PP_DetailCommentCreatAt_KeyName";
static NSString *const kPPVideoDetailCommentIconKeyName             = @"PP_DetailCommentIcon_KeyName";
static NSString *const kPPVideoDetailCommentUserNameKeyName         = @"PP_DetailCommentUserName_KeyName";
@implementation PPDetailCommentModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.content = [coder decodeObjectForKey:kPPVideoDetailCommentContentKeyName];
        self.createAt = [coder decodeObjectForKey:kPPVideoDetailCommentCreatAtKeyName];
        self.icon = [coder decodeObjectForKey:kPPVideoDetailCommentIconKeyName];
        self.userName = [coder decodeObjectForKey:kPPVideoDetailCommentUserNameKeyName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:kPPVideoDetailCommentContentKeyName];
    [aCoder encodeObject:self.createAt forKey:kPPVideoDetailCommentCreatAtKeyName];
    [aCoder encodeObject:self.icon forKey:kPPVideoDetailCommentIconKeyName];
    [aCoder encodeObject:self.userName forKey:kPPVideoDetailCommentUserNameKeyName];
}
@end


static NSString *const kPPVideoDetailUrlHeightKeyName           = @"PP_DetailUrlHeight_KeyName";
static NSString *const kPPVideoDetailUrlWidthKeyName            = @"PP_DetailUrlWidth_KeyName";
static NSString *const kPPVideoDetailUrlUrlKeyName              = @"PP_DetailUrlUrl_KeyName";
static NSString *const kPPVideoDetailUrlTitleKeyName            = @"PP_DetailUrlTitle_KeyName";
@implementation PPDetailUrlModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.height = [[coder decodeObjectForKey:kPPVideoDetailUrlHeightKeyName] integerValue];
        self.height = [[coder decodeObjectForKey:kPPVideoDetailUrlWidthKeyName] integerValue];
        self.url = [coder decodeObjectForKey:kPPVideoDetailUrlUrlKeyName];
        self.title = [coder decodeObjectForKey:kPPVideoDetailUrlTitleKeyName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.height] forKey:kPPVideoDetailUrlHeightKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.width] forKey:kPPVideoDetailUrlWidthKeyName];
    [aCoder encodeObject:self.url forKey:kPPVideoDetailUrlUrlKeyName];
    [aCoder encodeObject:self.title forKey:kPPVideoDetailUrlTitleKeyName];
}

@end

static NSString *const kPPVideoDetailColumnIdKeyName                    = @"PP_DetailColumnId_KeyName";
static NSString *const kPPVideoDetailCommentJsonKeyName                 = @"PP_DetailCommentJson_KeyName";
static NSString *const kPPVideoDetailProgramKeyName                     = @"PP_DetailProgram_KeyName";
static NSString *const kPPVideoDetailProgramUrlListKeyName              = @"PP_DetailProgramUrlList_KeyName";

@implementation PPDetailResponse

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.columnId = [[coder decodeObjectForKey:kPPVideoDetailColumnIdKeyName] integerValue];
        self.commentJson = [coder decodeObjectForKey:kPPVideoDetailCommentJsonKeyName];
        self.program = [coder decodeObjectForKey:kPPVideoDetailProgramKeyName];
        self.programUrlList = [coder decodeObjectForKey:kPPVideoDetailProgramUrlListKeyName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.columnId] forKey:kPPVideoDetailColumnIdKeyName];
    [aCoder encodeObject:self.commentJson forKey:kPPVideoDetailCommentJsonKeyName];
    [aCoder encodeObject:self.program forKey:kPPVideoDetailProgramKeyName];
    [aCoder encodeObject:self.programUrlList forKey:kPPVideoDetailProgramUrlListKeyName];
}

- (Class)commentJsonElementClass {
    return [PPDetailCommentModel class];
}

- (Class)programUrlListElementClass {
    return [PPDetailUrlModel class];
}

- (Class)programClass {
    return [PPDetailProgramModel class];
}
@end

@implementation PPDetailCacheModel

@end


@implementation PPDetailModel

+ (Class)responseClass {
    return [PPDetailResponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchDetailInfoWithColumnId:(NSNumber *)columnId ProgramId:(NSNumber *)programId CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"columnId":columnId,
                             @"programId":programId};
    @weakify(self);
    BOOL success = [self requestURLPath:PP_DETAIL_URL
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:PP_DETAIL_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPDetailResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                            [PPCacheModel updateDetailChche:resp WithProgramId:[programId integerValue]];
//                            PPDetailCacheModel *detailCacheModel = [[PPDetailCacheModel alloc] init];
//                            NSData *data = [NSJSONSerialization dataWithJSONObject:resp.program options:NSJSONWritingPrettyPrinted error:nil];
//                            detailCacheModel.programId = [programId integerValue];
//                            [detailCacheModel saveOrUpdate];
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp);
                        }
                        
                    }];
    
    return success;
}

@end
