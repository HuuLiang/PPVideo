//
//  PPSexViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSexViewController.h"
#import "PPSexCell.h"
#import "PPSexFooterView.h"

static NSString *const kPPSexFooterViewReusableIdentifier = @"PPSexFooterViewReusableIdentifier";
static NSString *const kPPSexCellReusableIdentifier = @"PPSexCellReusableIdentifier";

@interface PPSexViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@end

@implementation PPSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = kWidth(20);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPSexCell class] forCellWithReuseIdentifier:kPPSexCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPSexFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kPPSexFooterViewReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView PP_addPullToRefreshWithHandler:^{
        @strongify(self);
        //        [self loadChannels];
        [self loadData];
    }];
    [_layoutCollectionView PP_triggerPullToRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        if (self.dataSource.count == 0) {
        //            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
        //                @strongify(self);
        //                [self->_layoutCollectionView LSJ_triggerPullToRefresh];
        //            }];
        //        }
    });

}

- (void)loadData  {
    [_layoutCollectionView reloadData];
    [_layoutCollectionView PP_endPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPSexCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPSexCellReusableIdentifier forIndexPath:indexPath];
    
    cell.imgUrlStr      = @"http://www.1tong.com/uploads/wallpaper/anime/209-3-1920x1200.jpg";
    cell.titleStr       = @"神舟十一号载人飞船发射成功";
    cell.playCount      = 1234;
    cell.commentCount   = 2345;
    cell.tagStr         = @"人妻";
    cell.tagHexStr      = @"#E51C23";
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    
    
    CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing) / 2;
    CGFloat height = width * 0.6 + kWidth(88);
    return CGSizeMake(width, height);
    
    
    //    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PPSexFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPSexFooterViewReusableIdentifier forIndexPath:indexPath];
    footerView.timeStr = @"1993-02-27";
//    @weakify(self);
//    footerView.moreAction = ^{
//        @strongify(self);
//        
//    };
    return footerView;
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, section == 5 ? kWidth(70) : kWidth(60));
}


@end
