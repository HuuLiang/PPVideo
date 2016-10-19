//
//  PPSexModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPColumnModel.h"

@interface PPSexReponse : QBURLResponse
@property (nonatomic) NSArray <PPColumnModel *> *columnList;
@end

@interface PPSexModel : QBEncryptedURLRequest

- (BOOL)fetchSexInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
