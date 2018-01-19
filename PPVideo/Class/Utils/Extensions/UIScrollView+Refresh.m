//
//  UIScrollView+Refresh.m
//  PPVideo
//
//  Created by Liang on 16/6/4.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <MJRefresh.h>

@implementation UIScrollView (Refresh)

- (void)PP_addPullToRefreshWithHandler:(void (^)(void))handler {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        self.header = refreshHeader;
    }
}

- (void)PP_triggerPullToRefresh {
    [self.header beginRefreshing];
}

- (void)PP_endPullToRefresh {
    [self.header endRefreshing];
    [self.footer resetNoMoreData];
}

- (void)PP_addPagingRefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        self.footer = refreshFooter;
    }
}

- (void)PP_pagingRefreshNoMoreData {
    [self.footer endRefreshingWithNoMoreData];
}

- (void)PP_addIsRefreshing {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
        [refreshHeader setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
        self.header = refreshHeader;
    }
}
    
- (void)PP_addVIPNotiRefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        [refreshFooter setTitle:@"升级VIP可观看更多" forState:MJRefreshStateIdle];
        self.footer = refreshFooter;
    }
}

- (void)PP_addVipDetailNotiWithVipLevel:(PPVipLevel)vipLevel RefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        NSString *str = nil;
        if (vipLevel == PPVipLevelVipA) {
            str = @"成为黄金会员查看更多";
        } else if (vipLevel == PPVipLevelVipB) {
            str = @"成为钻石会员查看更多";
        } else if (vipLevel == PPVipLevelVipC) {
            str = @"成为黑金会员查看更多";
        }
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        [refreshFooter setTitle:str forState:MJRefreshStateIdle];
        self.footer = refreshFooter;
    }
}

@end
