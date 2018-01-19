//
//  PPVideoloaderURLConnection.h
//  PPVideo
//
//  Created by Liang on 2016/12/9.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class PPVideoRequestTask;

@protocol PPVideoloaderURLConnectionDelegate <NSObject>

- (void)didFinishLoadingWithTask:(PPVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(PPVideoRequestTask *)task WithError:(NSInteger )errorCode;

@end

@interface PPVideoloaderURLConnection : NSURLConnection <AVAssetResourceLoaderDelegate>

- (instancetype)initWithProgramId:(NSInteger)programId;

@property (nonatomic, strong) PPVideoRequestTask *task;
@property (nonatomic, weak  ) id<PPVideoloaderURLConnectionDelegate> delegate;
- (NSURL *)getSchemeVideoURL:(NSURL *)url;



@end
