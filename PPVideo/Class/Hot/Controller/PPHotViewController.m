//
//  PPHotViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPHotViewController.h"
#import "PPSectionBackgroundFlowLayout.h"
#import "PPHotTagCell.h"
#import "PPHotTagHeaderView.h"
#import "PPHotContentHeaderView.h"
#import "PPSexCell.h"

#import "PPHotModel.h"
#import "PPSearchModel.h"
#import "PPSearchResultViewController.h"

static NSString *const kSectionBackgroundReusableIdentifier         = @"SectionBackgroundReusableIdentifier";
static NSString *const kPPHotTagHeaderViewReusableIdentifier        = @"PPHotTagHeaderViewReusableIdentifier";
static NSString *const kPPHotContentHeaderViewReusableIdentifier    = @"PPHotContentHeaderViewReusableIdentifier";
static NSString *const kPPHotTagCellReusableIdentifier              = @"PPHotTagCellReusableIdentifier";
static NSString *const kPPHotNormalCellReusableIdentifier           = @"PPHotNormalCellReusableIdentifier";

typedef NS_ENUM(NSInteger ,PPHotSection) {
    PPHotSectionTag = 0,
    PPHotSectionContent,
    PPHotSectionCount
};

@interface PPHotViewController () <UICollectionViewDataSource,UICollectionViewDelegate,PPSectionBackgroundFlowLayoutDelegate,PPSearchViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    PPHotContentHeaderView *headerView;
    BOOL _loadMoreTags;
    NSUInteger lineTag;
    NSUInteger lineItemCount;
}
@property (nonatomic) PPHotModel *hotModel;
@property (nonatomic) PPHotReponse *response;
@property (nonatomic) PPSearchModel *searchModel;
@property (nonatomic) NSMutableArray *titleWidthArray;
@end

@implementation PPHotViewController
QBDefineLazyPropertyInitialization(PPHotModel, hotModel)
QBDefineLazyPropertyInitialization(PPHotReponse, response)
QBDefineLazyPropertyInitialization(PPSearchModel, searchModel)
QBDefineLazyPropertyInitialization(NSMutableArray, titleWidthArray)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PPSectionBackgroundFlowLayout *mainLayout = [[PPSectionBackgroundFlowLayout alloc] init];
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
        [_layoutCollectionView registerClass:[PPHotTagHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPHotTagHeaderViewReusableIdentifier];
    [_layoutCollectionView registerClass:[PPHotContentHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPHotContentHeaderViewReusableIdentifier];
    [_layoutCollectionView registerClass:[PPSexCell class] forCellWithReuseIdentifier:kPPHotNormalCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPHotTagCell class] forCellWithReuseIdentifier:kPPHotTagCellReusableIdentifier];
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

    
    if ([PPCacheModel getHotCache].hotSearch.count > 0) {
        self.response = [PPCacheModel getHotCache];
        if (self.response.tags.count >0) {
            [self titleItemWidth:self.response.tags];
        }
        _loadMoreTags = NO;
        [_layoutCollectionView reloadData];
        headerView.selectedMoreBth = NO;
    }
    
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        [_layoutCollectionView PP_addVIPNotiRefreshWithHandler:^{
            @strongify(self);
            if (self.isScrolling) {
                [[PPHudManager manager] showHudWithText:@"升级VIP可观看更多"];
            } else {
                [self presentPayViewControllerWithBaseModel:nil];
            }
            [self->_layoutCollectionView PP_endPullToRefresh];
        }];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.response.tags.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutCollectionView PP_triggerPullToRefresh];
            }];
        }
    });
}

- (void)refreshHotNotification:(NSNotification *)notification {
    [self->_layoutCollectionView PP_triggerPullToRefresh];
}

- (void)loadData {
    @weakify(self);
    [self.hotModel fetchHotInfoWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [_layoutCollectionView PP_endPullToRefresh];
        if (success) {
            [self removeCurrentRefreshBtn];
            self.response = obj;
            [self titleItemWidth:_response.tags];
            _loadMoreTags = NO;
            [_layoutCollectionView reloadData];
            self->headerView.selectedMoreBth = NO;
        }
        
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaidNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[PPSearchView showView] showInSuperView:self.view animated:NO];
    [PPSearchView showView].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotNotification:) name:kPaidNotificationName object:nil];
}

- (void)titleItemWidth:(NSArray *)array {
    [self.titleWidthArray removeAllObjects];
    lineTag = 0;
    lineItemCount = 0;
    CGFloat fullwidth = kScreenWidth - kWidth(60);
    NSInteger count = 0;
    CGFloat currentWidth = 0;
    CGFloat nextWidth = 0;
    CGFloat rowWidth = fullwidth;
    for (NSInteger i = 0; i < array.count ; i++) {
        NSString *title = array[i];
        if (i == 0) {
            currentWidth = [title sizeWithFont:[UIFont systemFontOfSize:kWidth(26)] maxSize:CGSizeMake(MAXFLOAT, kWidth(56))].width + kWidth(40);
        } else {
            currentWidth = nextWidth;
        }
        
        if (lineTag == 2) {
            lineItemCount = i;
            lineTag = 99;// 获取到刷新行标记之后 让lineTag 失效
        }
        
        if (i + 1 < array.count) {
            title = array[i + 1];
            nextWidth = [title sizeWithFont:[UIFont systemFontOfSize:kWidth(26)] maxSize:CGSizeMake(MAXFLOAT, kWidth(56))].width + kWidth(40);
            if (rowWidth - currentWidth - kWidth(40) >= nextWidth && count < 3) {
                count++;
                rowWidth = rowWidth - currentWidth - kWidth(40);
                [self.titleWidthArray addObject:@(currentWidth)];
            } else {
                count = 0;
                lineTag++;
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@(currentWidth)];
                rowWidth = kScreenWidth - kWidth(60);
            }
        } else {
            if (count <= 3 && rowWidth > currentWidth) {
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@(currentWidth)];
            } else {
                [self.titleWidthArray addObject:@(currentWidth)];
            }
        }
    }
}

- (BOOL)alwaysHideNavigationBar {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return PPHotSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == PPHotSectionTag) {
        if (!_loadMoreTags) {
            return lineItemCount;
        }else {
            return self.response.tags.count;
        }
    } else if (section == PPHotSectionContent) {
        if ([PPUtil currentVipLevel] == PPVipLevelNone) {
            return self.response.hotSearch.count > 4 ? 4 : self.response.hotSearch.count;
        }
        return self.response.hotSearch.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PPHotSectionTag) {
        PPHotTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPHotTagCellReusableIdentifier forIndexPath:indexPath];;
        if (indexPath.item < self.response.tags.count) {
            cell.titleStr = self.response.tags[indexPath.item];
        }
        return cell;
    } else if (indexPath.section == PPHotSectionContent) {
        PPSexCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPHotNormalCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.item < self.response.hotSearch.count) {
            PPProgramModel *program = self.response.hotSearch[indexPath.item];
            normalCell.imgUrlStr = program.coverImg;
            normalCell.titleStr = program.title;
            NSArray *countArr = [program.spare componentsSeparatedByString:@"|"];
            if (countArr.count > 0) {
                normalCell.playCount = [[countArr firstObject] integerValue];
                normalCell.commentCount = [[countArr lastObject] integerValue];
            }
            NSArray *tagArr = [program.tag componentsSeparatedByString:@"|"];
            if (tagArr.count > 0) {
                normalCell.tagStr = [tagArr lastObject];
                normalCell.tagHexStr = [tagArr firstObject];
            }
        }
        return normalCell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    
    if (indexPath.section == PPHotSectionTag) {
        if (indexPath.item < self.titleWidthArray.count) {
            CGFloat width = [self.titleWidthArray[indexPath.item] floatValue];
            return CGSizeMake((long)width, kWidth(56));
        }
        return CGSizeZero;
    } else if (indexPath.section == PPHotSectionContent) {
        CGFloat width = (fullWidth - insets.left - insets.right -  itemSpacing) / 2;
        CGFloat height = width * 0.6 + kWidth(88);
        return CGSizeMake((long)width, (long)height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == PPHotSectionTag) {
        return UIEdgeInsetsMake(kWidth(20), kWidth(30), kWidth(20), kWidth(30));
    } else if (section == PPHotSectionContent) {
        return UIEdgeInsetsMake(kWidth(20), kWidth(0), kWidth(20), kWidth(0));
    }
    return UIEdgeInsetsZero;
};

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == PPHotSectionTag) {
        return kWidth(30);
    } else if (section == PPHotSectionContent) {
        return kWidth(20);
    } else {
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == PPHotSectionTag) {
        return kWidth(40);
    } else if (section == PPHotSectionContent) {
        return kWidth(20);
    } else {
        return 0;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section < PPHotSectionCount) {
            if (indexPath.section == PPHotSectionTag) {
                PPHotTagHeaderView *tagHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPHotTagHeaderViewReusableIdentifier forIndexPath:indexPath];
                tagHeaderView.titleStr = @"热搜标签";
                tagHeaderView.titleColorStr = @"#666666";
                return tagHeaderView;
            } else if (indexPath.section == PPHotSectionContent) {
                headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPHotContentHeaderViewReusableIdentifier forIndexPath:indexPath];
                headerView.titleStr = @"精品推荐";
                headerView.titleColorStr = @"#333333";
                @weakify(self);
                headerView.isSelected = ^ {
                    @strongify(self);
                    self->_loadMoreTags = !self->_loadMoreTags;
                    [self->_layoutCollectionView reloadSections:[NSIndexSet indexSetWithIndex:PPHotSectionTag]];
                };
                
                return headerView;
            }
            return nil;
        }
    } else if (kind == PPElementKindSectionBackground) {
        UICollectionReusableView *sectionBgView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionBackgroundReusableIdentifier forIndexPath:indexPath];
        if (indexPath.section == PPHotSectionTag) {
            sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        } else if (indexPath.section == PPHotSectionContent) {
            sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        } else {
            sectionBgView.backgroundColor = [UIColor clearColor];
        }
        return sectionBgView;
    }
    return nil;
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == PPHotSectionTag) {
        return CGSizeMake(kScreenWidth, kWidth(80));
    } else if (section == PPHotSectionContent) {
        return CGSizeMake(kScreenWidth, kWidth(200));
    } else {
        return CGSizeZero;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout shouldDisplaySectionBackgroundInSection:(NSUInteger)section {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PPHotSectionTag) {
        if (indexPath.item < self.response.tags.count) {
            QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:[NSNumber numberWithInteger:self.response.realColumnId]
                                                                   channelType:nil
                                                                     programId:nil
                                                                   programType:nil
                                                               programLocation:nil];
                [self searchTagWithStr:self.response.tags[indexPath.item]];
                [[QBStatsManager sharedManager] statsCPCWithBaseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
        }
    } else if (indexPath.section == PPHotSectionContent) {
        if (indexPath.item < self.response.hotSearch.count) {
            PPProgramModel *program = self.response.hotSearch[indexPath.item];
            program.hasTimeControl = YES;
            [self pushDetailViewControllerWithColumnId:self.response.hsColumnId RealColumnId:self.response.hsRealColumnId columnType:NSNotFound programLocation:indexPath.item andProgramInfo:program];
        }
    }
}

- (void)searchTagWithStr:(NSString *)tagStr {
    @weakify(self);
    [self.searchModel fetchSearchInfoWithTagStr:tagStr CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        if (success) {
            if (obj.count > 0) {
                PPSearchResultViewController *resultVC = [[PPSearchResultViewController alloc] initWithProgramList:obj searchWords:tagStr ColumnId:self.response.columnId];
                [self.navigationController pushViewController:resultVC animated:YES];
            } else {
                [[PPHudManager manager] showHudWithText:@"未找到相关资源"];
            }
        }
    }];
}

- (void)showAlert {
    [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"搜索功能只针对黑金VIP用户开放" cancelButtonTitle:@"再考虑看看" otherButtonTitles:@[@"立即开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self presentPayViewControllerWithBaseModel:nil];
        }
    }];
}

#pragma mark - PPSearchViewDelegate
- (void)searchContentWithInfo:(NSString *)title {
    if ([PPUtil currentVipLevel] == PPVipLevelVipC) {
        [self searchTagWithStr:title];
    } else {
        [self showAlert];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([PPSearchView showView].becomeResponder) {
        [PPSearchView showView].becomeResponder = NO;
    }
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];
    self.isScrolling = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.isScrolling = NO;
}

@end
