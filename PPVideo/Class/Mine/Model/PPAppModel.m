//
//  PPAppModel.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPAppModel.h"

@implementation PPAppSpread

@end


@implementation PPAppResponse
- (Class)programListElementClass {
    return [PPAppSpread class];
}

@end

@implementation PPAppModel

+ (Class)responseClass {
    return [PPAppResponse class];
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:PP_APP_URL
                         withParams:nil
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *array = nil;
                    if (respStatus == QBURLResponseSuccess) {
                        PPAppResponse *resp = self.response;
                        array = [NSArray arrayWithArray:resp.programList];
                        _fetchedSpreads = [[NSMutableArray alloc] init];
                    }
                    for (NSInteger i = 0; i < array.count; i++) {
                        PPAppSpread *app = array[i];
                        [PPUtil checkAppInstalledWithBundleId:app.specialDesc completionHandler:^(BOOL isInstall) {
                            if (isInstall) {
                                app.isInstall = isInstall;
                                [_fetchedSpreads addObject:app];
                            } else {
                                [_fetchedSpreads insertObject:app atIndex:0];
                            }
                            if (_fetchedSpreads.count == array.count) {
                                if (handler) {
                                    handler(respStatus == QBURLResponseSuccess, _fetchedSpreads);
                                }
                            }
                        }];
                        
                    }
                }];
    return ret;
}

@end

