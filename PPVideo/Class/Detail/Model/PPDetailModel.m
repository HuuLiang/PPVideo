//
//  PPDetailModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailModel.h"

@implementation PPDetailProgramModel

@end

@implementation PPDetailCommentModel

@end

@implementation PPDetailUrlModel

@end


@implementation PPDetailResponse

- (Class)commentJsonElementClass {
    return [PPDetailCommentModel class];
}

- (Class)programUrlListElementClass {
    return [PPDetailUrlModel class];
}

- (Class)programClass {
    return [PPDetailProgramModel class];
}
@end

@implementation PPDetailModel

+ (Class)responseClass {
    return [PPDetailResponse class];
}

- (BOOL)fetchDetailInfoWithColumnId:(NSNumber *)columnId ProgramId:(NSNumber *)programId CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"columnId":columnId,
                             @"programId":programId};
    @weakify(self);
    BOOL success = [self requestURLPath:PP_DETAIL_URL
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPDetailResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp);
                        }
                        
                    }];
    
    return success;
}
@end
