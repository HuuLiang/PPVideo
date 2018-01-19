//
//  PPProgramModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPProgramModel.h"

static NSString *const kPPVideoProgramCoverImgKeyName           = @"PP_ProgramCoverImg_KeyName";
static NSString *const kPPVideoProgramDetailsCoverImgKeyName    = @"PP_ProgramDetailCoverImg_KeyName";
static NSString *const kPPVideoProgramPayPointTypeKeyName       = @"PP_ProgramPayPointType_KeyName";
static NSString *const kPPVideoProgramIdKeyName                 = @"PP_ProgramId_KeyName";
static NSString *const kPPVideoProgramSpareKeyName              = @"PP_ProgramSpare_KeyName";
static NSString *const kPPVideoProgramSpreadUrlKeyName          = @"PP_ProgramSpreadUrl_KeyName";
static NSString *const kPPVideoProgramTagKeyName                = @"PP_ProgramTag_KeyName";
static NSString *const kPPVideoProgramTitleKeyName              = @"PP_ProgramTitle_KeyName";
static NSString *const kPPVideoProgramTypeKeyName               = @"PP_ProgramType_KeyName";
static NSString *const kPPVideoProgramVideoUrlKeyName           = @"PP_ProgramVideoUrl_KeyName";

@implementation PPProgramModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.coverImg forKey:kPPVideoProgramCoverImgKeyName];
    [aCoder encodeObject:self.detailsCoverImg forKey:kPPVideoProgramDetailsCoverImgKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.payPointType] forKey:kPPVideoProgramPayPointTypeKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.programId] forKey:kPPVideoProgramIdKeyName];
    [aCoder encodeObject:self.spare forKey:kPPVideoProgramSpareKeyName];
    [aCoder encodeObject:self.spreadUrl forKey:kPPVideoProgramSpreadUrlKeyName];
    [aCoder encodeObject:self.tag forKey:kPPVideoProgramTagKeyName];
    [aCoder encodeObject:self.title forKey:kPPVideoProgramTitleKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:kPPVideoProgramTypeKeyName];
    [aCoder encodeObject:self.videoUrl forKey:kPPVideoProgramVideoUrlKeyName];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.coverImg = [coder decodeObjectForKey:kPPVideoProgramCoverImgKeyName];
        self.detailsCoverImg = [coder decodeObjectForKey:kPPVideoProgramDetailsCoverImgKeyName];
        self.payPointType = [[coder decodeObjectForKey:kPPVideoProgramPayPointTypeKeyName] integerValue];
        self.programId = [[coder decodeObjectForKey:kPPVideoProgramIdKeyName] integerValue];
        self.spare = [coder decodeObjectForKey:kPPVideoProgramSpareKeyName];
        self.spreadUrl = [coder decodeObjectForKey:kPPVideoProgramVideoUrlKeyName];
        self.tag = [coder decodeObjectForKey:kPPVideoProgramTagKeyName];
        self.title = [coder decodeObjectForKey:kPPVideoProgramTitleKeyName];
        self.type = [[coder decodeObjectForKey:kPPVideoProgramTypeKeyName] integerValue];
        self.videoUrl = [coder decodeObjectForKey:kPPVideoProgramVideoUrlKeyName];
    }
    return self;
}

@end
