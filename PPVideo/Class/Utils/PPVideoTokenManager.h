//
//  PPVideoTokenManager.h
//  PPVideo
//
//  Created by Liang on 2016/10/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PPVideoTokenCompletionHandler)(BOOL success, NSString *token, NSString *userId);
@interface PPVideoTokenManager : NSObject
+ (instancetype)sharedManager;

- (void)requestTokenWithCompletionHandler:(PPVideoTokenCompletionHandler)completionHandler;
- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink;

@end
