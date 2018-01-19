//
//  JYHostIPModel.h
//  PPVideo
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface PPHostIPModel : QBEncryptedURLRequest
+ (instancetype)sharedModel;
- (void)fetchHostList;
@end
