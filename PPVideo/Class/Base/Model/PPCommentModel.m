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
    
    return model;
}

+ (NSInteger)randomLikeCount {
    NSInteger likeCount = random() %10000 + 1000;
    return likeCount;
}

+ (NSInteger)randomHateCount {
    NSInteger hateCount = random() % 300 + 20;
    return hateCount;
}



@end
