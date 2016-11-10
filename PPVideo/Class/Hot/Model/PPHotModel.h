//
//  PPHotModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPColumnModel.h"


@interface PPHotReponse : QBURLResponse <NSCoding>
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSArray <PPProgramModel *> *hotSearch;
@property (nonatomic) NSInteger hsColumnId;
@property (nonatomic) NSInteger hsRealColumnId;
@property (nonatomic) NSInteger realColumnId;
@property (nonatomic) NSArray *tags;

@end

@interface PPHotModel : QBEncryptedURLRequest

- (BOOL)fetchHotInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
