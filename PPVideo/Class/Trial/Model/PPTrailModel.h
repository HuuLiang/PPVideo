//
//  PPTrailModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPColumnModel.h"

@interface PPTrailReponse : QBURLResponse
@property (nonatomic) NSArray <PPColumnModel *> *columnList;
@end

@interface PPTrailModel : QBEncryptedURLRequest

- (BOOL)fetchTrailInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
