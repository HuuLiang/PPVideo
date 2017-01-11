//
//  PPLiveModel.m
//  PPVideo
//
//  Created by Liang on 2017/1/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPLiveModel.h"

@implementation PPLiveReponse

- (Class)columnListElementClass {
    return [PPColumnModel class];
}

- (Class)programListElementClass {
    return [PPProgramModel class];
}

@end

@implementation PPLiveModel

+ (Class)responseClass {
    return [PPLiveReponse class];
}

- (NSTimeInterval)requestTimeInterval {
    return [PPSystemConfigModel sharedModel].timeoutInterval;
}

- (BOOL)fetchLiveInfoWithColumnId:(NSUInteger)columnId Page:(NSUInteger)page CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = nil;
    NSString *url = nil;
    if (page == 0) {
        url = PP_LIVE_URL;
    } else {
        url = PP_LIVEREFRESH_URL;
        params = @{@"columnId":[NSNumber numberWithUnsignedInteger:columnId],@"page":[NSNumber numberWithUnsignedInteger:page]};
    }
    @weakify(self);
    BOOL success = [self requestURLPath:url
                         standbyURLPath:[PPUtil getStandByUrlPathWithOriginalUrl:url params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        PPLiveReponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                            if (page > 0) {
                                PPColumnModel *column = [[PPColumnModel alloc] init];
                                column.columnId = resp.columnId;
                                column.programList = resp.programList;
                                resp.columnList = @[column];
                            }
                            [PPCacheModel updateSexCacheWithColumnInfo:resp.columnList];
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp.columnList);
                        }
                        
                    }];
    
    return success;
}


@end
