//
//  PPCommentModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPCommentModel.h"

@implementation PPCommentModel

+ (instancetype)getCommentInfoWithProgramId:(NSInteger)programId {
    if (programId == NSNotFound) {
        return nil;
    }
    PPCommentModel *model = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE programId=%ld",programId]];
    if (!model) {
        model = [[PPCommentModel alloc] init];
        model.programId = programId;
        model.likeCount = [self randomLikeCount];
        model.hateCount = [self randomHateCount];
        model.isChanged = NO;
    }
    model.likeCount = model.likeCount + [self refreshLikeCount];
    model.hateCount = model.hateCount + [self refreshHateCount];
    [model saveOrUpdate];
    
    return model;
}

// 生成
+ (NSInteger)randomLikeCount {
    NSInteger likeCount = random() %10000 + 1000;
    return likeCount;
}

+ (NSInteger)randomHateCount {
    NSInteger hateCount = random() % 300 + 20;
    return hateCount;
}

//刷新改变
+ (NSInteger)refreshLikeCount {
    NSInteger likeCount = random() % 8;
    return likeCount;
}

+ (NSInteger)refreshHateCount {
    NSInteger hateCount = random() % 3;
    return hateCount;
}

@end
