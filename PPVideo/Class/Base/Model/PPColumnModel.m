//
//  PPColumnModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPColumnModel.h"

static NSString *const kPPVideoColumnDescKeyName       = @"PP_ColumnDesc_KeyName";
static NSString *const kPPVideoColumnIdKeyName         = @"PP_ColumnId_KeyName";
static NSString *const kPPVideoColumnImgKeyName        = @"PP_ColumnImg_KeyName";
static NSString *const kPPVideoColumnNameKeyName       = @"PP_ColumnName_KeyName";
static NSString *const kPPVideoRealColumnIdKeyName     = @"PP_RealColumnId_KeyName";
static NSString *const kPPVideoShowModelKeyName        = @"PP_ShowModel_KeyName";
static NSString *const kPPVideoShowNumberKeyName       = @"PP_ShowNumber_KeyName";
static NSString *const kPPVideoColumnSpareKeyName      = @"PP_ColumnSpare_KeyName";
static NSString *const kPPVideoColumnSpreadUrlKeyName  = @"PP_ColumnSpreadUrl_KeyName";
static NSString *const kPPVideoColumnTypeKeyName       = @"PP_ColumnType_KeyName";
static NSString *const kppVideoProgramListKeyName      = @"PP_ProgramList_KeyName";

@implementation PPColumnModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.columnDesc forKey:kPPVideoColumnDescKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.columnId] forKey:kPPVideoColumnIdKeyName];
    [aCoder encodeObject:self.columnImg forKey:kPPVideoColumnImgKeyName];
    [aCoder encodeObject:self.name forKey:kPPVideoColumnNameKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.realColumnId] forKey:kPPVideoRealColumnIdKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.showModel] forKey:kPPVideoShowModelKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.showNumber] forKey:kPPVideoShowNumberKeyName];
    [aCoder encodeObject:self.spare forKey:kPPVideoColumnSpareKeyName];
    [aCoder encodeObject:self.spreadUrl forKey:kPPVideoColumnSpreadUrlKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:kPPVideoColumnTypeKeyName];
    [aCoder encodeObject:self.programList forKey:kppVideoProgramListKeyName];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.columnDesc = [aDecoder decodeObjectForKey:kPPVideoColumnDescKeyName];
        self.columnId = [[aDecoder decodeObjectForKey:kPPVideoColumnIdKeyName] integerValue];
        self.columnImg = [aDecoder decodeObjectForKey:kPPVideoColumnImgKeyName];
        self.name = [aDecoder decodeObjectForKey:kPPVideoColumnNameKeyName];
        self.realColumnId = [[aDecoder decodeObjectForKey:kPPVideoRealColumnIdKeyName] integerValue];
        self.showModel = [[aDecoder decodeObjectForKey:kPPVideoShowModelKeyName] integerValue];
        self.showNumber = [[aDecoder decodeObjectForKey:kPPVideoShowNumberKeyName] integerValue];
        self.spare = [aDecoder decodeObjectForKey:kPPVideoColumnSpareKeyName];
        self.spreadUrl = [aDecoder decodeObjectForKey:kPPVideoColumnSpreadUrlKeyName];
        self.type = [[aDecoder decodeObjectForKey:kPPVideoColumnTypeKeyName] integerValue];
        self.programList = [aDecoder decodeObjectForKey:kppVideoProgramListKeyName];
    }
    return self;
}

- (Class)programListElementClass {
    return [PPProgramModel class];
}

@end
