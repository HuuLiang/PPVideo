//
//  PPForumModel.h
//  PPVideo
//
//  Created by Liang on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface PPForumReponse : QBURLResponse
@property (nonatomic) NSArray <PPColumnModel *> *columnList;
@end

@interface PPForumModel : QBEncryptedURLRequest

- (BOOL)fetchForumInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
