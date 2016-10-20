//
//  PPMineVipVC.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineVipVC.h"
#import "PPMineVipHeaderCell.h"

@interface PPMineVipVC ()
{
    PPMineVipHeaderCell *_headerCell;
}
@end

@implementation PPMineVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell ) {
            
        }
    };
    
    [self initCells];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initHeaderCellInSection:section++];
    
    
    
}

- (void)initHeaderCellInSection:(NSInteger)section {
    _headerCell = [[PPMineVipHeaderCell alloc] init];
    
    [self setLayoutCell:_headerCell cellHeight:kWidth(100) inRow:0 andSection:section];
}

//- (void)

@end
