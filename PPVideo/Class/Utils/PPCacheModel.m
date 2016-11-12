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

@end