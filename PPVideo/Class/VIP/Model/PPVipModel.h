//
//  PPVipModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPColumnModel.h"

@interface PPVipModel : QBEncryptedURLRequest

- (BOOL)fetchVipInfoWithVipLevel:(PPVipLevel)vipLevel CompletionHandler:(QBCompletionHandler)handler;

@end
