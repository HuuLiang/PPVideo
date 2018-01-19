//
//  PPVideoRequestTask.h
//  PPVideo
//
//  Created by Liang on 2016/12/9.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class PPVideoRequestTask;
@protocol PPVideoRequestTaskDelegate <NSObject>
- (void)task:(PPVideoRequestTask *)task didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType;
- (void)didReceiveVideoDataWithTask:(PPVideoRequestTask *)task;
- (void)didFinishLoadingWithTask:(PPVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(PPVideoRequestTask *)task WithError:(NSInteger )errorCode;
@end

@interface PPVideoRequestTask : NSObject

@property (nonatomic, strong, readonly) NSURL                      *url;
@property (nonatomic, readonly        ) NSUInteger                 offset;

@property (nonatomic, readonly        ) NSUInteger                 videoLength;
@property (nonatomic, readonly        ) NSUInteger                 downLoadingOffset;
@property (nonatomic, strong, readonly) NSString                   * mimeType;
@property (nonatomic, assign)           BOOL                       isFinishLoad;

@property (nonatomic, weak            ) id <PPVideoRequestTaskDelegate> delegate;

- (instancetype)initWithProgramId:(NSInteger)programId;

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

- (void)continueLoading;

- (void)clearData;

@end
