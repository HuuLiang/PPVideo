//
//  PPSystemConfigModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPSystemConfig.h"

@interface PPSystemConfigResponse : QBURLResponse

@property (nonatomic,retain) NSArray<PPSystemConfig *> *confis;

@end

typedef void (^PPFetchSystemConfigCompletionHandler)(BOOL success);

@interface PPSystemConfigModel : QBEncryptedURLRequest <NSCoding>

@property (nonatomic) NSInteger payAmount;
@property (nonatomic) NSInteger payzsAmount;
@property (nonatomic) NSInteger payhjAmount;
@property (nonatomic) NSInteger maxDiscount;

@property (nonatomic) NSString *mineImgUrl;
@property (nonatomic) NSString *vipImg;
@property (nonatomic) NSString *sVipImg;

@property (nonatomic) NSString *contactName1;
@property (nonatomic) NSString *contactName2;
@property (nonatomic) NSString *contactName3;

@property (nonatomic) NSString *contactScheme1;
@property (nonatomic) NSString *contactScheme2;
@property (nonatomic) NSString *contactScheme3;

@property (nonatomic) NSString *baiduyuUrl;
@property (nonatomic) NSString *baiduyuCode;

@property (nonatomic) NSTimeInterval timeoutInterval;

@property (nonatomic) NSTimeInterval expireTime;
@property (nonatomic) NSString *videoSignKey;

@property (nonatomic) NSString *imageToken;
@property (nonatomic,readonly) BOOL loaded;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(PPFetchSystemConfigCompletionHandler)handler;
- (NSString *)currentContactName;
- (NSString *)currentContactScheme;

@end
