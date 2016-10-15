//
//  PPTrialViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrialViewController.h"
#import "SDCycleScrollView.h"

@interface PPTrialViewController () <UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    
    SDCycleScrollView *_bannerView;
}

@end

@implementation PPTrialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasSectionBorder = NO;
    
    [self.layoutTableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.layoutTableView PP_addPullToRefreshWithHandler:^{
        [self initCells];
    }];
    [self.layoutTableView PP_triggerPullToRefresh];
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initBannerViewInSection:section++];
    [self initFreeVideoInSection:section++];
    
}

- (void)initBannerViewInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    [cell addSubview:_bannerView];
    {
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell);
        }];
    }
    
    [self setLayoutCell:cell cellHeight:kWidth(100) inRow:0 andSection:section];
}

- (void)initFreeVideoInSection:(NSInteger)section {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
