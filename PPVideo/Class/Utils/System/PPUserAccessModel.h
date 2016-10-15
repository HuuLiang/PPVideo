//
//  PPUserAccessModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void (^LSJUserAccessCompletionHandler)(BOOL success);

@interface PPUserAccessModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
