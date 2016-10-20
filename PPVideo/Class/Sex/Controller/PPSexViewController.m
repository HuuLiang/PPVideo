//
//  PPSexViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSexViewController.h"
#import "PPSexModel.h"
#import "PPSexCell.h"
#import "PPSexFooterView.h"

static NSString *const kPPSexFooterViewReusableIdentifier = @"PPSexFooterViewReusableIdentifier";
static NSString *const kPPSexCellReusableIdentifier = @"PPSexCellReusableIdentifier";

@interface PPSexViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
    NSInteger refreshSection;
}
@property (nonatomic) PPSexModel *sexModel;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation PPSexViewController
QBDefineLazyPropertyInitialization(PPSexModel, sexModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
        if (self.dataSource.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutCollectionView PP_triggerPullToRefresh];
            }];
        }
    });

}

- (void)loadData  {
    @weakify(self);
    [self.sexModel fetchSexInfoWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [self removeCurrentRefreshBtn];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:obj];
        refreshSection = self.dataSource.count;
        [_layoutCollectionView reloadData];
        [_layoutCollectionView PP_endPullToRefresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    PPColumnModel *column = self.dataSource[section];
    if (([PPUtil currentVipLevel] == PPVipLevelNone || [PPUtil currentVipLevel] == PPVipLevelVipA) && refreshSection != section) {
        return 4;
    } else {
        refreshSection = self.dataSource.count;
        return column.programList.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPSexCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPSexCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[indexPath.section];
        if (indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.item];
            cell.imgUrlStr = program.coverImg;
            cell.titleStr = program.title;
            NSArray *countArr = [program.spare componentsSeparatedByString:@"|"];
            if (countArr.count > 0) {
                cell.playCount = [[countArr firstObject] integerValue];
                cell.commentCount = [[countArr lastObject] integerValue];
            }
            NSArray *tagArr = [program.tag componentsSeparatedByString:@"|"];
            if (tagArr.count > 0) {
                cell.tagStr = [tagArr lastObject];
                cell.tagHexStr = [tagArr firstObject];
            }
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing) / 2;
    CGFloat height = width * 0.6 + kWidth(88);
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PPSexFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPSexFooterViewReusableIdentifier forIndexPath:indexPath];
    footerView.time = indexPath.section;
    @weakify(self);
    footerView.moreAction = ^{
        @strongify(self);
        if ([PPUtil currentVipLevel] == PPVipLevelNone) {
            //支付弹窗
        } else if ([PPUtil currentVipLevel] == PPVipLevelVipA) {
            self->refreshSection = indexPath.section;
            [self->_layoutCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }
    };
    return footerView;
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, section == 5 ? kWidth(70) : kWidth(60));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[indexPath.section];
        if (indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.item];
            [self pushDetailViewControllerWithColumnId:column.columnId RealColumnId:column.realColumnId columnType:column.type programLocation:indexPath.item andProgramInfo:program];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}


@end
