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
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSArray <PPProgramModel *> *programList;
@end

@interface PPLiveModel : QBEncryptedURLRequest

- (BOOL)fetchLiveInfoWithColumnId:(NSUInteger)columnId Page:(NSUInteger)page CompletionHandler:(QBCompletionHandler)handler;

@end
