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
#import "PPTrailFreeAdCell.h"
#import "PPTrailHeaderView.h"
#import "PPTrailNormalCell.h"
#import "PPTrailAdCell.h"
#import "PPAdPopView.h"

static NSString *const kBannerCellReusableIdentifier        = @"BannerCellReusableIdentifier";
static NSString *const kPPTrailFreeCellReusableIdentifier   = @"PPTrailFreeCellReusableIdentifier";
static NSString *const kPPTrailFreeAdCellReusableIdentifier = @"PPTrailFreeAdCellReusableIdentifier";
static NSString *const kPPTrailHeaderViewReusableIdentifier = @"PPTrailHeaderViewReusableIdentifier";
static NSString *const kPPTrailNormalCellReusableIdentifier = @"PPTrailNormalCellReusableIdentifier";
static NSString *const kPPTrailAdCellReusableIdentifier     = @"PPTrailAdCellReusableIdentifier";
static NSString *const kSectionBackgroundReusableIdentifier = @"SectionBackgroundReusableIdentifier";
static NSString *const kPPTrailGrayHeaderViewReusableIdentifier = @"PPTrailGrayHeaderViewReusableIdentifier";

typedef NS_ENUM(NSInteger ,PPTrailSection) {
    PPTrailSectionBanner = 0,
    PPTrailSectionFree,
    PPTrailSectionAd,
    PPTrailSectionContent,
    PPTrailSectionMoreAd,
    PPTrailSectionMoreContent,
    PPTrailSectionCount
};

@interface PPTrialViewController () <UICollectionViewDataSource,UICollectionViewDelegate,PPSectionBackgroundFlowLayoutDelegate,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    
    SDCycleScrollView *_bannerView;
    UICollectionViewCell *_bannerCell;
    PPTrailHeaderView *headerView;
    BOOL _refreshFree;
    
//    UIView *codeView;
//    UIImageView *codeImgV;
//    UIImageView *closeImgV;
//    UIButton *btn;
//    NSString *codeUrlStr;
}
@property (nonatomic) PPTrailModel *trailModel;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) PPAdPopView *adView;
@end

@implementation PPTrialViewController
QBDefineLazyPropertyInitialization(PPTrailModel, trailModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    _bannerView.titleLabelTextFont = [UIFont systemFontOfSize:[PPUtil isIpad] ? kWidth(28) : kWidth(34)];
    _bannerView.titleLabelHeight = [PPUtil isIpad] ? kWidth(28) : kWidth(34);
    _bannerView.titleLabelTextColor = [UIColor colorWithHexString:@"#ffffff"];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.pageControlDotSize = CGSizeMake(kWidth(12), kWidth(12));
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    
    [_bannerView aspect_hookSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UIScrollView *scrollView, BOOL decelerate){
        PPColumnModel *column = [self.dataSource firstObject];
        [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex
                                          subTabIndex:NSNotFound
                                            forBanner:[NSNumber numberWithInteger:column.columnId]
                                       withSlideCount:1];
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
    [_layoutCollectionView registerClass:[PPTrailFreeAdCell class] forCellWithReuseIdentifier:kPPTrailFreeAdCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPTrailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPTrailHeaderViewReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPTrailGrayHeaderViewReusableIdentifier];
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
        [self loadData];
    }];
    
    [_layoutCollectionView PP_addVIPNotiRefreshWithHandler:^{
        @strongify(self);
        [[PPHudManager manager] showHudWithText:@"升级VIP可观看更多"];
        [self presentPayViewControllerWithBaseModel:nil];
        [self->_layoutCollectionView PP_endPullToRefresh];
    }];
    
    if ([PPCacheModel getTrailCache].count>0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[PPCacheModel getTrailCache]];
        [self refreshBannerView];
        [_layoutCollectionView reloadData];
    }
    
    [_layoutCollectionView PP_triggerPullToRefresh];
    
    _adView = [[PPAdPopView alloc] initWithSuperView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutCollectionView PP_triggerPullToRefresh];
            }];
        }
    });
}

- (void)loadData {
    @weakify(self);
    [self.trailModel fetchTrailInfoWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [_layoutCollectionView PP_endPullToRefresh];
        if (success) {
            [self.dataSource removeAllObjects];
            [self removeCurrentRefreshBtn];
            _refreshFree = NO;
            [self.dataSource addObjectsFromArray:obj];
            [self refreshBannerView];
            [_layoutCollectionView reloadData];
            [self changeAdContentIfNeed];
            self->headerView.selectedMoreBtn = NO;
        }
    }];


}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (PPColumnModel *column in self.dataSource) {
        if (column.type == 4) {
            for (PPProgramModel *program in column.programList) {
                [imageUrlGroup addObject:program.coverImg];
                [titlesGroup addObject:program.title];
            }
        }
    }
    _bannerView.imageURLStringsGroup = imageUrlGroup;
    _bannerView.titlesGroup = titlesGroup;
}

- (void)changeAdContentIfNeed {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *unInstallSpreads = [PPUtil getUnInstalledSpreads];
        if (unInstallSpreads.count == 0) {
            return ;
        }
        if (unInstallSpreads.count > 0) {
            if (self.dataSource.count > PPTrailSectionAd) {
                PPColumnModel *column = self.dataSource[PPTrailSectionAd];
                [self reloadAdContentWithAdColumn:column unInstallSpreads:unInstallSpreads atIndex:0];
            }
        }
        
        if (unInstallSpreads.count > 1) {
            if (self.dataSource.count > PPTrailSectionMoreAd) {
                PPColumnModel *column = self.dataSource[PPTrailSectionMoreAd];
                [self reloadAdContentWithAdColumn:column unInstallSpreads:unInstallSpreads atIndex:1];
            }
        }
    });
}

- (void)reloadAdContentWithAdColumn:(PPColumnModel *)column unInstallSpreads:(NSArray <PPAppSpread *> *)unInstallSpreads atIndex:(NSInteger)index {
    NSInteger columnIndex = [self.dataSource indexOfObject:column];
    [self.dataSource removeObjectAtIndex:columnIndex];
    
    PPAppSpread *appSpread = unInstallSpreads[index];
    column.spreadUrl = appSpread.videoUrl;
    column.columnImg = appSpread.spare;
    
    [self.dataSource insertObject:column atIndex:columnIndex];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_layoutCollectionView reloadSections:[NSIndexSet indexSetWithIndex:columnIndex]];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count > PPTrailSectionCount ? PPTrailSectionCount : self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource.count > 0) {
        PPColumnModel *column = self.dataSource[section];
        
        if (section == PPTrailSectionBanner || section == PPTrailSectionAd || section == PPTrailSectionMoreAd) {
            return 1;
        } else if (section == PPTrailSectionContent || section == PPTrailSectionMoreContent) {
            return column.programList.count;
        } else if (section == PPTrailSectionFree) {
            if (_refreshFree) {
                return column.programList.count;
            } else {
                return column.programList.count/2;
            }
        }
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPColumnModel *column = self.dataSource[indexPath.section];
    
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
        if (indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.item];
            if (program.type == 30) {
                PPTrailFreeAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPTrailFreeAdCellReusableIdentifier forIndexPath:indexPath];
                cell.imgUrlStr = program.coverImg;
                _adView.codeImgUrlStr = program.detailsCoverImg;
                return cell;
            } else {
                PPTrailFreeCell *freeCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPTrailFreeCellReusableIdentifier forIndexPath:indexPath];
                freeCell.imgUrlStr = program.coverImg;
                freeCell.titleStr = program.title;
                NSArray *array = [program.spare componentsSeparatedByString:@"|"];
                if (array.count > 0) {
                    freeCell.playCount = [[array firstObject] integerValue];
                    freeCell.commentCount = [[array lastObject] integerValue];
                }
                return freeCell;
            }
        }
    } else if (indexPath.section == PPTrailSectionAd || indexPath.section == PPTrailSectionMoreAd) {
        PPTrailAdCell *adCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPTrailAdCellReusableIdentifier forIndexPath:indexPath];
        adCell.adUrlStr = column.columnImg;
        _adView.codeImgUrlStr = column.spare;
        return adCell;
    } else if (indexPath.section == PPTrailSectionContent || indexPath.section == PPTrailSectionMoreContent) {
        PPTrailNormalCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPTrailNormalCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.row];
            normalCell.imgUrlStr = program.coverImg;
            normalCell.titleStr = program.title;
            NSArray *array = [program.spare componentsSeparatedByString:@"|"];
            if (array.count > 0) {
                normalCell.playCount = [[array firstObject] integerValue];
                normalCell.commentCount = [[array lastObject] integerValue];
            }
            normalCell.isFreeCell = YES;
        }
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
        return CGSizeMake((long)width, (long)height);
    } else if (indexPath.section == PPTrailSectionAd || indexPath.section == PPTrailSectionMoreAd) {
        CGFloat width = (fullWidth - insets.left - insets.right);
        CGFloat height = width /5;
        return CGSizeMake((long)width, (long)height);
    } else if (indexPath.section == PPTrailSectionContent || indexPath.section == PPTrailSectionMoreContent) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
        CGFloat height = width * 9 /7;
        return CGSizeMake((long)width, (long)height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == PPTrailSectionFree || section == PPTrailSectionContent || section == PPTrailSectionMoreContent) {
        return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
    } else if (section == PPTrailSectionAd || section == PPTrailSectionMoreAd) {
        return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(0), kWidth(20));
    }
    
    return UIEdgeInsetsZero;
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == PPTrailSectionAd) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPTrailHeaderViewReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            headerView.selected = ^{
                @strongify(self);
                self->_refreshFree = !self->_refreshFree;
                [self->_layoutCollectionView reloadSections:[NSIndexSet indexSetWithIndex:PPTrailSectionFree]];
            };
            return headerView;
        } else if (indexPath.section == PPTrailSectionMoreAd) {
            UICollectionReusableView *grayView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPTrailGrayHeaderViewReusableIdentifier forIndexPath:indexPath];
            grayView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
            return grayView;
        }
    } else if (kind == PPElementKindSectionBackground) {
        UICollectionReusableView *sectionBgView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionBackgroundReusableIdentifier forIndexPath:indexPath];
        if (indexPath.section == PPTrailSectionFree) {
            sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        } else if (indexPath.section == PPTrailSectionContent || indexPath.section == PPTrailSectionAd || indexPath.section == PPTrailSectionMoreAd || indexPath.section == PPTrailSectionMoreContent) {
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
        return CGSizeMake(kScreenWidth, kWidth(60));
    } else if (section == PPTrailSectionMoreAd) {
        return CGSizeMake(kScreenWidth, kWidth(20));
    } else {
        return CGSizeZero;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
shouldDisplaySectionBackgroundInSection:(NSUInteger)section {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[indexPath.section];
        if (indexPath.section != PPTrailSectionAd && indexPath.section != PPTrailSectionMoreAd && indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.item];
            if (program.type == 30) {
                //二维码
                if (_adView.isHidden) {
                    _adView.codeImgUrlStr = program.detailsCoverImg;
                    _adView.hidden = NO;
                }
            } else {
                program.hasTimeControl = YES;
                [self pushDetailViewControllerWithColumnId:column.columnId RealColumnId:column.realColumnId columnType:column.type programLocation:indexPath.item andProgramInfo:program];
            }
        } else {
            if (column.type == 30) {
                //二维码
                if (_adView.isHidden) {
                    _adView.codeImgUrlStr = column.spare;
                    _adView.hidden = NO;
                }
            } else {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:column.spreadUrl]]) {
                    QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:[NSNumber numberWithInteger:column.realColumnId]
                                                                           channelType:[NSNumber numberWithInteger:column.type]
                                                                             programId:nil
                                                                           programType:nil
                                                                       programLocation:nil];
                    [[QBStatsManager sharedManager] statsCPCWithBaseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:column.spreadUrl]];
                }
            }
        }
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    PPColumnModel *column = [self.dataSource firstObject];
    if (index < column.programList.count) {
        PPProgramModel *program = column.programList[index];
        if (program.type != 3) {
            program.hasTimeControl = YES;
            [self pushDetailViewControllerWithColumnId:column.columnId RealColumnId:column.realColumnId columnType:column.type programLocation:index andProgramInfo:program];
        } else {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:program.videoUrl]]) {
                QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:[NSNumber numberWithInteger:column.realColumnId]
                                                                       channelType:[NSNumber numberWithInteger:column.type]
                                                                         programId:[NSNumber numberWithInteger:program.programId]
                                                                       programType:[NSNumber numberWithInteger:program.type]
                                                                   programLocation:nil];
                [[QBStatsManager sharedManager] statsCPCWithBaseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

@end
