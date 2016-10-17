//
//  PPTrialViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrialViewController.h"
#import "PPSectionBackgroundFlowLayout.h"
#import "SDCycleScrollView.h"
#import "PPTrailModel.h"
#import "PPTrailFreeCell.h"
#import "PPTrailHeaderView.h"
#import "PPTrailNormalCell.h"
#import "PPTrailAdCell.h"

static NSString *const kBannerCellReusableIdentifier        = @"BannerCellReusableIdentifier";
static NSString *const kPPTrailFreeCellReusableIdentifier   = @"PPTrailFreeCellReusableIdentifier";
static NSString *const kPPTrailHeaderViewReusableIdentifier = @"PPTrailHeaderViewReusableIdentifier";
static NSString *const kPPTrailNormalCellReusableIdentifier = @"PPTrailNormalCellReusableIdentifier";
static NSString *const kPPTrailAdCellReusableIdentifier     = @"PPTrailAdCellReusableIdentifier";
static NSString *const kSectionBackgroundReusableIdentifier = @"SectionBackgroundReusableIdentifier";

typedef NS_ENUM(NSInteger ,PPTrailSection) {
    PPTrailSectionBanner = 0,
    PPTrailSectionFree,
    PPTrailSectionAd,
    PPTrailSectionContent,
    PPTrailSectionCount
};

@interface PPTrialViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    
    SDCycleScrollView *_bannerView;
    UICollectionViewCell *_bannerCell;
    
    BOOL _refreshFree;
}
@property (nonatomic) PPTrailModel *trailModel;
@end

@implementation PPTrialViewController
QBDefineLazyPropertyInitialization(PPTrailModel, trailModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    _bannerView.titleLabelTextFont = [UIFont systemFontOfSize:kWidth(32)];
    _bannerView.titleLabelTextColor = [UIColor colorWithHexString:@"#ffffff"];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    
    [_bannerView aspect_hookSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UIScrollView *scrollView, BOOL decelerate){
//        [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:1 forBanner:@(self.bannerColoumnModel.columnId) withSlideCount:1];
    } error:nil];

    
    PPSectionBackgroundFlowLayout *mainLayout = [[PPSectionBackgroundFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = kWidth(20);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPTrailFreeCell class] forCellWithReuseIdentifier:kPPTrailFreeCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPTrailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPTrailHeaderViewReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPTrailNormalCell class] forCellWithReuseIdentifier:kPPTrailNormalCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPTrailAdCell class] forCellWithReuseIdentifier:kPPTrailAdCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:PPElementKindSectionBackground withReuseIdentifier:kSectionBackgroundReusableIdentifier];
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

- (void)loadData {
//    @weakify(self);
//    [self.trailModel fetchTrailInfoWithCompletionHandler:^(BOOL success, id obj) {
//        @strongify(self);
//        if (success) {
//            _refreshFree = NO;
//            
//        } else {
//            
//        }
//    }];
    _refreshFree = NO;
    
    [_layoutCollectionView reloadData];
    [self refreshBannerView];
    [_layoutCollectionView PP_endPullToRefresh];

}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (int i = 0; i < 5; i ++) {
        [imageUrlGroup addObject:@"http://www.1tong.com/uploads/wallpaper/anime/209-3-1920x1200.jpg"];
        [titlesGroup addObject:@"神舟十一号载人飞船发射成功"];
    }
    
    _bannerView.imageURLStringsGroup = imageUrlGroup;
    _bannerView.titlesGroup = titlesGroup;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return PPTrailSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == PPTrailSectionBanner || section == PPTrailSectionAd) {
        return 1;
    } else if (section == PPTrailSectionContent) {
        return 12;
    } else if (section == PPTrailSectionFree) {
        if (_refreshFree) {
            return 8;
        } else {
            return 4;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == PPTrailSectionBanner) {
        if (!_bannerCell) {
            _bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
            [_bannerCell.contentView addSubview:_bannerView];
            {
                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bannerCell.contentView);
                }];
            }
        }
        return _bannerCell;
    } else if (indexPath.section == PPTrailSectionFree) {
        PPTrailFreeCell *freeCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPTrailFreeCellReusableIdentifier forIndexPath:indexPath];
        freeCell.imgUrlStr = @"http://www.1tong.com/uploads/wallpaper/anime/209-3-1920x1200.jpg";
        freeCell.titleStr = @"神舟十一号载人飞船发射成功";
        freeCell.playCount = 1234;
        freeCell.commentCount = 2345;
        return freeCell;
    } else if (indexPath.section == PPTrailSectionAd) {
        PPTrailAdCell *adCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPTrailAdCellReusableIdentifier forIndexPath:indexPath];
        adCell.adUrlStr = @"http://www.1tong.com/uploads/wallpaper/anime/209-3-1920x1200.jpg";
        return adCell;
    } else if (indexPath.section == PPTrailSectionContent) {
        PPTrailNormalCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPTrailNormalCellReusableIdentifier forIndexPath:indexPath];
        normalCell.imgUrlStr = @"http://www.1tong.com/uploads/wallpaper/anime/209-3-1920x1200.jpg";
        normalCell.titleStr = @"神舟十一号载人飞船发射成功";
        normalCell.playCount = 1234;
        normalCell.commentCount = 2345;
        return normalCell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    
    if (indexPath.section == PPTrailSectionBanner) {
        return CGSizeMake(kScreenWidth, kScreenWidth/2);
    } else if (indexPath.section == PPTrailSectionFree) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing) / 2;
        CGFloat height = width * 0.6 + kWidth(88);
        return CGSizeMake(width, height);
    } else if (indexPath.section == PPTrailSectionAd) {
        CGFloat width = (fullWidth - insets.left - insets.right);
        CGFloat height = width /5;
        return CGSizeMake(width, height);
    } else if (indexPath.section == PPTrailSectionContent) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
        CGFloat height = width * 9 /7;
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == PPTrailSectionFree || section == PPTrailSectionContent) {
        return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
    } else if (section == PPTrailSectionAd) {
        return UIEdgeInsetsMake(kWidth(40), kWidth(20), kWidth(20), kWidth(20));
    }
    
    return UIEdgeInsetsZero;
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == PPTrailSectionAd) {
            PPTrailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPTrailHeaderViewReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            headerView.selected = ^{
                @strongify(self);
                self->_refreshFree = !self->_refreshFree;
                [self->_layoutCollectionView reloadSections:[NSIndexSet indexSetWithIndex:PPTrailSectionFree]];
            };
            
            return headerView;
        }
    } else if (kind == PPElementKindSectionBackground) {
        UICollectionReusableView *sectionBgView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionBackgroundReusableIdentifier forIndexPath:indexPath];
        if (indexPath.section == PPTrailSectionFree) {
            sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        } else if (indexPath.section == PPTrailSectionContent) {
            sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        } else {
            sectionBgView.backgroundColor = [UIColor clearColor];
        }
        return sectionBgView;
    }

    return nil;
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == PPTrailSectionAd) {
        return CGSizeMake(kScreenWidth, kWidth(40));
    } else {
        return CGSizeZero;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
shouldDisplaySectionBackgroundInSection:(NSUInteger)section {
    return YES;
}

@end
