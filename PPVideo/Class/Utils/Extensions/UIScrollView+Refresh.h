//
//  UIScrollView+Refresh.m
//  PPVideo
//
//  Created by Liang on 16/6/24.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)PP_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)PP_triggerPullToRefresh;
- (void)PP_endPullToRefresh;

- (void)PP_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)PP_pagingRefreshNoMoreData;

- (void)PP_addIsRefreshing;

- (void)PP_addVIPNotiRefreshWithHandler:(void (^)(void))handler;

- (void)PP_addVipDetailNotiWithVipLevel:(PPVipLevel)vipLevel RefreshWithHandler:(void (^)(void))handler;

@end
