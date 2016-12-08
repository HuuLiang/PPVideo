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

@interface PPHotViewController () <UICollectionViewDataSource,UICollectionViewDelegate,PPSectionBackgroundFlowLayoutDelegate,UISearchBarDelegate>
{
    UICollectionView *_layoutCollectionView;
    UISearchBar *_searchBar;
    PPHotContentHeaderView *headerView;
    BOOL _loadMoreTags;
}
@property (nonatomic) PPHotModel *hotModel;
@property (nonatomic) PPHotReponse *response;
@property (nonatomic) PPSearchModel *searchModel;
@end

@implementation PPHotViewController
QBDefineLazyPropertyInitialization(PPHotModel, hotModel)
QBDefineLazyPropertyInitialization(PPHotReponse, response)
QBDefineLazyPropertyInitialization(PPSearchModel, searchModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth(500), 30)];
    UIColor *color = self.navigationController.navigationBar.barTintColor;
    [titleView setBackgroundColor:color];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, 0, kWidth(500), 30);
    _searchBar.placeholder = @"关键字搜索";
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.barStyle = UIBarStyleBlack;
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor colorWithHexString:@"#ffffff"];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#ffffff"];
    [_searchBar setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    _searchBar.layer.cornerRadius = 15;
    _searchBar.layer.masksToBounds = YES;
    [_searchBar setSearchFieldBackgroundImage:[self GetImage] forState:UIControlStateNormal];
    
    [titleView addSubview:_searchBar];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
//    const CGFloat fullBarWidth = CGRectGetWidth(self.navigationController.navigationBar.bounds);
//    const CGFloat fullBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
//    
//    const CGFloat searchBarWidth = fullBarWidth/1.5;
//    const CGFloat searchBarHeight = fullBarHeight * 0.8;
//    const CGFloat searchBarY = (fullBarHeight - searchBarHeight)/2;
//    const CGFloat searchBarX = (fullBarWidth - searchBarWidth)/2;
//    _searchBar.frame = CGRectMake(searchBarX, searchBarY - 3, searchBarWidth, searchBarHeight);
//    _searchBar.layer.cornerRadius = searchBarHeight/2;
//    _searchBar.layer.masksToBounds = YES;
//    [self.navigationController.navigationBar addSubview:_searchBar];
    
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
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView PP_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    if ([PPCacheModel getHotCache].hotSearch.count > 0) {
        self.response = [PPCacheModel getHotCache];
        _loadMoreTags = NO;
        [_layoutCollectionView reloadData];
        headerView.selectedMoreBth = NO;
    }
    
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        [_layoutCollectionView PP_addVIPNotiRefreshWithHandler:^{
            @strongify(self);
            QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:nil
                                                                   channelType:nil
                                                                     programId:nil
                                                                   programType:nil
                                                               programLocation:[NSNumber numberWithInteger:[PPUtil currentTabPageIndex]]];
            [self presentPayViewControllerWithBaseModel:baseModel];
            [_layoutCollectionView PP_endPullToRefresh];
        }];
    }
    
    [_layoutCollectionView PP_triggerPullToRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.response.tags.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutCollectionView PP_triggerPullToRefresh];
            }];
        }
    });
}

- (UIImage*)GetImage;
{
    UIColor *color = [UIColor colorWithHexString:@"#ffffff"];
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, 20);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
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
            _loadMoreTags = NO;
            [_layoutCollectionView reloadData];
            self->headerView.selectedMoreBth = NO;
        }
        
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaidNotificationName object:nil];
    _searchBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotNotification:) name:kPaidNotificationName object:nil];
    _searchBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return PPHotSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == PPHotSectionTag) {
        if (!_loadMoreTags) {
            return 6;
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
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self collection];
    CGFloat itemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    
    if (indexPath.section == PPHotSectionTag) {
        CGFloat width = (fullWidth - insets.left - insets.right - itemSpacing * 2) / 3;
        CGFloat height = width * 28 / 83;
        return CGSizeMake((long)width, (long)height);
    } else if (indexPath.section == PPHotSectionContent) {
        CGFloat width = (fullWidth - insets.left - insets.right -  itemSpacing) / 2;
        CGFloat height = width * 0.6 + kWidth(88);
        return CGSizeMake((long)width, (long)height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == PPHotSectionTag) {
        return UIEdgeInsetsMake(kWidth(20), kWidth(46), kWidth(20), kWidth(46));
    } else if (section == PPHotSectionContent) {
        return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
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
        return kWidth(80);
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
            sectionBgView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
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
        return CGSizeMake(kScreenWidth, kWidth(180));
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
//            if ([PPUtil currentVipLevel] == PPVipLevelNone) {
//                [self presentPayViewControllerWithBaseModel:baseModel];
//            } else {
                [self searchTagWithStr:self.response.tags[indexPath.item]];
                [[QBStatsManager sharedManager] statsCPCWithBaseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
//            }
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
                if ([self->_searchBar isFirstResponder]) {
                    [self->_searchBar resignFirstResponder];
                }
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

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([PPUtil currentVipLevel] != PPVipLevelVipC) {
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        [self showAlert];
        return ;
    }
    
    if (searchBar.text.length == 0) {
        [[PPHudManager manager] showHudWithText:@"请输入关键字"];
        return ;
    }
    
    [self searchTagWithStr:searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    for (UIView *searchButtions in [searchBar subviews]) {
        for (UIView *subView in [searchButtions subviews]) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton *)subView;
                cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
