//
//  PPActivateModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void (^LSJActivateHandler)(BOOL success, NSString *userId);

@interface PPActivateModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(LSJActivateHandler)handler;


@end
