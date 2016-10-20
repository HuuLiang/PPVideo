//
//  PPDetailModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPColumnModel.h"

@interface PPDetailProgramModel : PPProgramModel
@property (nonatomic) NSString *offUrl;
@end

@interface PPDetailCommentModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *createAt;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *userName;
@end

@interface PPDetailUrlModel : NSObject
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@end

@interface PPDetailResponse : QBURLResponse
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSArray <PPDetailCommentModel *> *commentJson;
@property (nonatomic) PPDetailProgramModel *program;
@property (nonatomic) NSArray <PPDetailUrlModel *> *programUrlList;
@end

@interface PPDetailModel : QBEncryptedURLRequest

- (BOOL)fetchDetailInfoWithColumnId:(NSNumber *)columnId ProgramId:(NSNumber *)programId CompletionHandler:(QBCompletionHandler)handler;

@end
