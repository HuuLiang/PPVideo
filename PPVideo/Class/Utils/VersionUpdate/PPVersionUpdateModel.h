//
//  PPVersionUpdateModel.h
//  PPVideo
//
//  Created by Liang on 2016/12/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface PPVersionUpdateInfo : QBURLResponse

@property (nonatomic) NSString *versionNo;
@property (nonatomic) NSString *linkUrl;
@property (nonatomic) NSNumber *isForceToUpdate;
@property (nonatomic) BOOL up;

@end


@interface PPVersionUpdateModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) PPVersionUpdateInfo *fetchedVersionInfo;

+ (instancetype)sharedModel;
- (BOOL)fetchLatestVersionWithCompletionHandler:(QBCompletionHandler)completionHandler;


@end
