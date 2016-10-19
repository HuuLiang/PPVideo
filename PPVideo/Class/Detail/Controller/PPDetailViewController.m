//
//  PPDetailViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailViewController.h"

@interface PPDetailViewController ()

@end

@implementation PPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasRowSeparator = NO;
//    [self.layoutTableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(-20);
        }];
    }
    
    [self.layoutTableView PP_addPullToRefreshWithHandler:^{
//        [self loadAppData];
    }];
    [self.layoutTableView PP_triggerPullToRefresh];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
//        if (cell == self->_headerCell) {
//            //            [self payWithInfo:nil];
//        } else if (cell == self->_detailCell) {
//            
//        } else if (cell == self->_activateCell) {
//            
//        } else if (cell == self->_qqCell) {
//            [self contactCustomerService];
//        }
    };
    
    [self initCells];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
