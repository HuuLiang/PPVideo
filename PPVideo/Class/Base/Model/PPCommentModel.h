//
//  PPCommentModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

@interface PPCommentModel : JKDBModel

@property (nonatomic) NSInteger programId;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger hateCount;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) BOOL isChanged;

+ (instancetype)getCommentInfoWithProgramId:(NSInteger)programId;

@end
