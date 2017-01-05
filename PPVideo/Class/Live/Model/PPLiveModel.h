//
//  PPLiveModel.h
//  PPVideo
//
//  Created by Liang on 2017/1/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface PPLiveReponse : QBURLResponse
@property (nonatomic) NSArray <PPColumnModel *> *columnList;
@end

@interface PPLiveModel : QBEncryptedURLRequest

- (BOOL)fetchLiveInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
