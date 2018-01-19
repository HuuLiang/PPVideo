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

@interface PPDetailCommentModel : JKDBModel <NSCoding>
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *createAt;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *userName;
@end

@interface PPDetailUrlModel : JKDBModel <NSCoding>
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSInteger type;
@end

@interface PPDetailResponse : QBURLResponse <NSCoding>
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSArray <PPDetailCommentModel *> *commentJson;
@property (nonatomic) PPDetailProgramModel *program;
@property (nonatomic) NSArray <PPDetailUrlModel *> *programUrlList;
@end

@interface PPDetailCacheModel : JKDBModel
@property (nonatomic) NSInteger programId;
@property (nonatomic) NSString *dataString;
@end

@interface PPDetailModel : QBEncryptedURLRequest

- (BOOL)fetchDetailInfoWithColumnId:(NSNumber *)columnId ProgramId:(NSNumber *)programId CompletionHandler:(QBCompletionHandler)handler;

@end
