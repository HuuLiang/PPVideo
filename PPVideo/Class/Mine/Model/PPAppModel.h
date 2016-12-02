//
//  PPAppModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

@interface PPAppSpread : NSObject <NSCoding>
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *detailsCoverImg;
@property (nonatomic) NSString *pkgName;
@property (nonatomic) NSString *postTime;
@property (nonatomic) NSUInteger programId;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *offUrl;
@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger type;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *spreadImg;
@property (nonatomic) NSString *spare;
@property (nonatomic) BOOL isInstall;
@end

@interface PPAppResponse : QBURLResponse
@property (nonatomic) NSArray <PPAppSpread *> *programList;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger realColumnId;
@property (nonatomic) NSInteger showModel;
@property (nonatomic) NSInteger showNumber;
@property (nonatomic) NSString *spare;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSInteger type;
@end

@interface PPAppModel : QBEncryptedURLRequest
@property (nonatomic,retain,readonly) NSMutableArray<PPAppSpread *> *fetchedSpreads;
- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler;
@end

