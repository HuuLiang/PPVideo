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
#import "PPSectionBackgroundFlowLayout.h"
#import "PPAdPopView.h"
#import "PPTrailFreeAdCell.h"


static NSString *const kPPSexFooterViewReusableIdentifier = @"PPSexFooterViewReusableIdentifier";
static NSString *const kPPSexCellReusableIdentifier = @"PPSexCellReusableIdentifier";
static NSString *const kSectionBackgroundReusableIdentifier = @"SectionBackgroundReusableIdentifier";
static NSString *const kSexAdCellReusableIdentifier = @"PPSexAdCellReusableIdentifier";


@interface PPSexViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PPSectionBackgroundFlowLayoutDelegate>
{
    UICollectionView *_layoutCollectionView;
    PPSexFooterView *_footerView;
}
@property (nonatomic) PPSexModel *sexModel;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSMutableDictionary *reloadDic;
@property (nonatomic) PPAdPopView *adView;
@end

@implementation PPSexViewController
QBDefineLazyPropertyInitialization(PPSexModel, sexModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableDictionary, reloadDic)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PPSectionBackgroundFlowLayout *mainLayout = [[PPSectionBackgroundFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = kWidth(20);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPSexCell class] forCellWithReuseIdentifier:kPPSexCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPTrailFreeAdCell class] forCellWithReuseIdentifier:kSexAdCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPSexFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kPPSexFooterViewReusableIdentifier];
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
    
    if ([PPCacheModel getSexCache].count>0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[PPCacheModel getSexCache]];
        [_layoutCollectionView reloadData];
    }
    
    if ([PPUtil currentVipLevel] != PPVipLevelVipC) {
        [_layoutCollectionView PP_addVIPNotiRefreshWithHandler:^{
            @strongify(self);
            [[PPHudManager manager] showHudWithText:@"升级VIP可观看更多"];
            [self presentPayViewControllerWithBaseModel:nil];
            [self->_layoutCollectionView PP_endPullToRefresh];
        }];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSexView:) name:kPaidNotificationName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaidNotificationName object:nil];
}

- (void)loadData  {
    @weakify(self);
    [self.sexModel fetchSexInfoWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [_layoutCollectionView PP_endPullToRefresh];
        if (success) {
            [self removeCurrentRefreshBtn];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [self.reloadDic removeAllObjects];
            for (NSInteger i = 0; i < self.dataSource.count; i++) {
                [self.reloadDic setValue:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%ld",i]];
            }
            [_layoutCollectionView reloadData];
            if ([PPUtil currentVipLevel] == PPVipLevelNone || [PPUtil currentVipLevel] == PPVipLevelVipA) {
                self->_footerView.hideBtn = NO;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshSexView:(NSNotification *)notification {
    [_layoutCollectionView PP_triggerPullToRefresh];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        return self.dataSource.count >= 4 ? 4 : 0;
    } else if ([PPUtil currentVipLevel] == PPVipLevelVipA) {
        return self.dataSource.count >= 6 ? 6 : 0;
    } else if ([PPUtil currentVipLevel] == PPVipLevelVipB) {
        return self.dataSource.count >= 8 ? 8 : 0;
    } else {
        return self.dataSource.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    PPColumnModel *column = self.dataSource[section];
    BOOL isReload = [[self.reloadDic valueForKey:[NSString stringWithFormat:@"%ld",section]] boolValue];
    if (([PPUtil currentVipLevel] == PPVipLevelNone || [PPUtil currentVipLevel] == PPVipLevelVipA) && isReload == NO) {
        return 4;
    } else {
        return column.programList.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[indexPath.section];
        if (indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.item];
            if (program.type == 30) {
                PPTrailFreeAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSexAdCellReusableIdentifier forIndexPath:indexPath];
                cell.imgUrlStr = program.coverImg;
                _adView.codeImgUrlStr = program.detailsCoverImg;
                return cell;
            } else {
                PPSexCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPSexCellReusableIdentifier forIndexPath:indexPath];
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
                return cell;
            }
        }
    }
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
    if (kind == UICollectionElementKindSectionFooter) {
        _footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPSexFooterViewReusableIdentifier forIndexPath:indexPath];
        _footerView.time = indexPath.section;
        if ([[self.reloadDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]] boolValue]) {
            _footerView.hideBtn = YES;
        } else{
            _footerView.hideBtn = NO;
        }
        @weakify(self);
        _footerView.moreAction = ^{
            @strongify(self);
            if ([PPUtil currentVipLevel] == PPVipLevelNone) {
                [[PPHudManager manager] showHudWithText:@"升级VIP可观看更多"];
                PPColumnModel *column = self.dataSource[indexPath.section];
                QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:[NSNumber numberWithInteger:column.realColumnId]
                                                                       channelType:[NSNumber numberWithInteger:column.type]
                                                                         programId:nil
                                                                       programType:nil
                                                                   programLocation:nil];
                [self presentPayViewControllerWithBaseModel:baseModel];
            } else if ([PPUtil currentVipLevel] == PPVipLevelVipA) {
                [self.reloadDic setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
                [self->_layoutCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                self->_footerView.hideBtn = YES;
            }
        };
        return _footerView;
    } else if (kind == PPElementKindSectionBackground) {
        UICollectionReusableView *sectionBgView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionBackgroundReusableIdentifier forIndexPath:indexPath];
        sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        return sectionBgView;
    }
    return nil;

};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, section == 5 ? kWidth(90) : kWidth(80));
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout shouldDisplaySectionBackgroundInSection:(NSUInteger)section {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[indexPath.section];
        if (indexPath.item < column.programList.count) {
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
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

@end
