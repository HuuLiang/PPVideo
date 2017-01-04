//
//  PPForumViewController.m
//  PPVideo
//
//  Created by Liang on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPForumViewController.h"
#import "PPSectionBackgroundFlowLayout.h"
#import "PPForumCell.h"
#import "PPForumHeaderView.h"
#import "PPForumModel.h"

static NSString *const kPPForumHeaderViewReusableIdentifier = @"PPForumHeaderViewReusableIdentifier";
static NSString *const kPPForumCellReusableIdentifier       = @"kPPForumCellReusableIdentifier";
static NSString *const kSectionBackgroundReusableIdentifier = @"SectionBackgroundReusableIdentifier";


@interface PPForumViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PPSectionBackgroundFlowLayoutDelegate>
{
    UICollectionView    *_layoutCollectionView;
    PPForumHeaderView   *_headerView;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) PPForumModel  *forumModel;
@end

@implementation PPForumViewController
QBDefineLazyPropertyInitialization(PPForumModel, forumModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    PPSectionBackgroundFlowLayout *mainLayout = [[PPSectionBackgroundFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = kWidth(20);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPForumCell class] forCellWithReuseIdentifier:kPPForumCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPForumHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPForumHeaderViewReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:PPElementKindSectionBackground withReuseIdentifier:kSectionBackgroundReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(44);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView PP_addPullToRefreshWithHandler:^{
        @strongify(self);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[PPSearchView showView] showInSuperView:self.view animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PPSearchView showView] hideFormSuperView];
}

- (BOOL)alwaysHideNavigationBar {
    return YES;
}

- (void)loadData {
    @weakify(self);
    [self.forumModel fetchForumInfoWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [self removeCurrentRefreshBtn];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutCollectionView reloadData];
        }
    }];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[section];
        if (section == 0) {
            return 0;
        } else {
            return column.programList.count;
        }
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing) / 2;
    CGFloat height = width * 0.6 + kWidth(88);
    return CGSizeMake((long)width, (long)height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPForumHeaderViewReusableIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            
        } else {
            
        }
        return _headerView;
    } else if (kind == PPElementKindSectionBackground) {
        UICollectionReusableView *sectionBgView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionBackgroundReusableIdentifier forIndexPath:indexPath];
        sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        return sectionBgView;
    }
    return nil;
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, section == 0 ? kWidth(120) : kWidth(98));
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout shouldDisplaySectionBackgroundInSection:(NSUInteger)section {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[indexPath.section];
        if (indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.item];
            
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

@end
