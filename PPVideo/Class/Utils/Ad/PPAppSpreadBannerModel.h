//
//  PPAppSpreadBannerModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPAppModel.h"

@interface PPAppSpreadBannerResponse : QBURLResponse
@property(nonatomic)NSNumber *realColumnId;
@property (nonatomic)NSNumber *type;
@property (nonatomic,retain) NSArray<PPAppSpread *> *programList;
@end

@interface PPAppSpreadBannerModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<PPAppSpread *> *fetchedSpreads;
+ (instancetype)sharedModel;
- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler;
@property(nonatomic)NSNumber *realColumnId;
@property (nonatomic)NSNumber *type;
@end
