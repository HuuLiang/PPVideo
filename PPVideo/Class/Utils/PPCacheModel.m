//
//  PPCacheModel.m
//  PPVideo
//
//  Created by Liang on 2016/11/10.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPCacheModel.h"

static NSString *const kTrailCacheKeyName         = @"PP_TrailCache_KeyName";
static NSString *const kVipCacheKeyName           = @"PP_VipCache_KeyName";
static NSString *const kSexCacheKeyName           = @"PP_SexCache_KeyName";
static NSString *const kHotCacheKeyName           = @"PP_HotCache_KeyName";
static NSString *const kAppCacheKeyName           = @"PP_AppCache_KeyName";
static NSString *const kSystemConfigKeyName       = @"PP_SystemConfig_KeyName";

@implementation PPCacheModel

#pragma mark -- Trail
+(NSArray <PPColumnModel *>*)getTrailCache {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kTrailCacheKeyName];
    NSMutableArray <PPColumnModel *>*columnList = [[NSMutableArray alloc] init];
    for (NSData *data in array) {
        PPColumnModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [columnList addObject:model];
    }
    return columnList;;
}

+(void)updateTrailCacheWithColumnInfo:(NSArray <PPColumnModel *>*)columnList {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (PPColumnModel * model in columnList) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [array addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kTrailCacheKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -- Vip
+(PPColumnModel *)getVipCache {
    PPColumnModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kVipCacheKeyName]];
    return model;
}

+(void)updateVipCacheWithColumnInfo:(PPColumnModel *)columnModel {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:columnModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kVipCacheKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -- Sex
+(NSArray <PPColumnModel *>*)getSexCache {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kSexCacheKeyName];
    NSMutableArray <PPColumnModel *>*columnList = [[NSMutableArray alloc] init];
    for (NSData *data in array) {
        PPColumnModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [columnList addObject:model];
    }
    return columnList;;
}

+(void)updateSexCacheWithColumnInfo:(NSArray <PPColumnModel *>*)columnList {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (PPColumnModel * model in columnList) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [array addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kSexCacheKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -- Hot
+(PPHotReponse *)getHotCache {
    PPHotReponse *response = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kHotCacheKeyName]];
    return response;
}

+(void)updateHotCacheWitnHotInfo:(PPHotReponse *)response {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kHotCacheKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -- App
+(NSArray <PPAppSpread *> *)getAppCache {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCacheKeyName];
    NSMutableArray <PPAppSpread *>*appList = [[NSMutableArray alloc] init];
    for (NSData *data in array) {
        PPAppSpread *app = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [appList addObject:app];
    }
    return appList;;
}

+(void)updateAppCacheWithAppInfo:(NSArray <PPAppSpread *> *)appList {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (PPAppSpread * app in appList) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:app];
        [array addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kAppCacheKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- detail
+(PPDetailResponse *)getDetailCacheWithProgramId:(NSInteger)programId {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld",programId]];
    PPDetailResponse *response = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return response;
}

+(void)updateDetailChche:(PPDetailResponse *)response WithProgramId:(NSInteger)programId {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%ld",programId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- systemConfigModel
+(PPSystemConfigModel *)getSystemConfigModelInfo {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigKeyName];
    PPSystemConfigModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!model) {
        model = [PPSystemConfigModel sharedModel];
        model.payAmount = 5000;
        model.payzsAmount = 3000;
        model.payhjAmount = 2000;
        
        [PPSystemConfigModel sharedModel].payAmount = model.payAmount;
        [PPSystemConfigModel sharedModel].payzsAmount = model.payzsAmount;
        [PPSystemConfigModel sharedModel].payhjAmount = model.payhjAmount;
        
        [self updateSystemConfigModelWithSystemConfigModel:model];
    }
    return model;
}

+(void)updateSystemConfigModelWithSystemConfigModel:(PPSystemConfigModel *)systemConfigModel {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:systemConfigModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSystemConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- VideoCache

+ (BOOL)checkLocalProgramVideoCacheIsDownloading:(NSInteger)programId videoUrl:(NSString *)videoUrlStr {
    if (programId == NSNotFound) {
        return nil;
    }
    PPCacheModel *model = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE programVideoCacheId=%ld",programId]];
    if (!model) {
        model = [[PPCacheModel alloc] init];
        model.programVideoCacheId = programId;
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *programVideoPath = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.mp4",programId]];
        model.videoCacheFilePath = programVideoPath;
        model.isDownloading = NO;
    }
//    model.isDownloading = [model.videoUrlStr isEqualToString:videoUrlStr];
//    
//    //如果videoUrlStr判断为NO 说明这个programid对应的视频数据已经更新 需要重新下载新的视频数据
//    if (!model.isDownloading) {
//        model.videoUrlStr = videoUrlStr;
//    }
    [model saveOrUpdate];

    return model.isDownloading;
}

+ (NSString *)getLocalProgramVideoPath:(NSInteger)programId {
    if (programId == NSNotFound) {
        return nil;
    }
    PPCacheModel *model = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE programVideoCacheId=%ld",programId]];
    if (!model) {
        model = [[PPCacheModel alloc] init];
        model.programVideoCacheId = programId;
        model.isDownloading = NO;
        [model saveOrUpdate];
    }
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *programVideoPath = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.mp4",programId]];
    model.videoCacheFilePath = programVideoPath;
    return model.videoCacheFilePath;
}

+ (void)setSuccessTagWithProgramId:(NSInteger)programId{
    if (programId == NSNotFound) {
        return ;
    }
    PPCacheModel *model = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE programVideoCacheId=%ld",programId]];
    model.isDownloading = YES;
    [model saveOrUpdate];
}

@end
