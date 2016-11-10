//
//  PPCacheModel.h
//  PPVideo
//
//  Created by Liang on 2016/11/10.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPColumnModel.h"
#import "PPHotModel.h"
#import "PPAppModel.h"
#import "PPDetailModel.h"

@interface PPCacheModel : NSObject

+(NSArray <PPColumnModel *>*)getTrailCache;
+(void)updateTrailCacheWithColumnInfo:(NSArray <PPColumnModel *>*)columnList;

+(PPColumnModel *)getVipCache;
+(void)updateVipCacheWithColumnInfo:(PPColumnModel *)columnModel;

+(NSArray <PPColumnModel *>*)getSexCache;
+(void)updateSexCacheWithColumnInfo:(NSArray <PPColumnModel *>*)columnList;

+(PPHotReponse *)getHotCache;
+(void)updateHotCacheWitnHotInfo:(PPHotReponse *)response;

+(NSArray <PPAppSpread *> *)getAppCache;
+(void)updateAppCacheWithAppInfo:(NSArray <PPAppSpread *> *)appList;

+(PPDetailResponse *)getDetailCacheWithProgramId:(NSInteger)programId;
+(void)updateDetailChche:(PPDetailResponse *)response WithProgramId:(NSInteger)programId;
@end
