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

@interface PPSystemConfigModel : QBEncryptedURLRequest

@property (nonatomic) NSInteger payAmount;
@property (nonatomic) NSInteger svipPayAmount;
@property (nonatomic) NSString *mineImgUrl;
@property (nonatomic) NSString *vipImg;
@property (nonatomic) NSString *sVipImg;

@property (nonatomic) NSString *contacName;
@property (nonatomic) NSString *contactScheme;
@property (nonatomic) NSString *imageToken;
@property (nonatomic,readonly) BOOL loaded;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(PPFetchSystemConfigCompletionHandler)handler;

@end
