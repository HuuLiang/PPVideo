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
#import "PPWebViewController.h"

static NSString *const kPPForumHeaderViewReusableIdentifier = @"PPForumHeaderViewReusableIdentifier";
static NSString *const kPPForumTitleViewReusableIdentifier  = @"PPForumTitleViewReusableIdentifier";
static NSString *const kPPForumCellReusableIdentifier       = @"kPPForumCellReusableIdentifier";
static NSString *const kSectionBackgroundReusableIdentifier = @"SectionBackgroundReusableIdentifier";


@interface PPForumViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PPSectionBackgroundFlowLayoutDelegate>
{
    UICollectionView    *_layoutCollectionView;
    NSMutableAttributedString *_attriStr;
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
    mainLayout.minimumLineSpacing = kWidth(0);
    mainLayout.minimumInteritemSpacing = kWidth(0);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPForumCell class] forCellWithReuseIdentifier:kPPForumCellReusableIdentifier];
    [_layoutCollectionView registerClass:[PPForumHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPForumHeaderViewReusableIdentifier];
    [_layoutCollectionView registerClass:[PPForumTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPForumTitleViewReusableIdentifier];
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
        //缓存无数据 到了刷新时间 可以主动刷新
        if ([PPCacheModel getForumCache].count <= 0 || [PPUtil shouldRefreshLiveContent]) {
            [self loadData];
        } else {
            [self->_layoutCollectionView PP_endPullToRefresh];
        }
    }];

    if ([PPCacheModel getForumCache].count>0) {
        if ([[PPUtil isLastDate] isYesterday]) {
            [_layoutCollectionView PP_triggerPullToRefresh];
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[PPCacheModel getForumCache]];
            [self getContentAttriTitle];
            [_layoutCollectionView reloadData];
        }
    } else {
        [_layoutCollectionView PP_triggerPullToRefresh];
    }
    
    
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
    
    if ([PPUtil shouldRefreshLiveContent]) {
        [self refreshAndReplaceDataSource];
    }
}

- (void)refreshAndReplaceDataSource {
    NSMutableArray *refreshData = [NSMutableArray arrayWithArray:self.dataSource];
    [self.dataSource removeAllObjects];
    for (PPColumnModel *column in refreshData) {
        NSMutableArray *programList = [NSMutableArray array];
        for (PPProgramModel *program in column.programList) {
            if (![program.title isEqualToString:@"昨日"]) {
                program.spare = [NSString stringWithFormat:@"%ld",[program.spare integerValue] + arc4random() % 3 + 1 ];
            }
            [programList addObject:program];
        }
        column.programList = programList;
        [self.dataSource addObject:column];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
            [self getContentAttriTitle];
            [_layoutCollectionView reloadData];
        }
        [self->_layoutCollectionView PP_endPullToRefresh];
    }];
}

- (void)getContentAttriTitle {
    PPColumnModel *column = [self.dataSource firstObject];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PPProgramModel *program in column.programList) {
        [array addObject:[NSString stringWithFormat:@"%@:%@",program.title,program.spare]];
    }
    _attriStr = [[NSMutableAttributedString alloc] initWithString:[array componentsJoinedByString:@" | "] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidth(28)],
                                                                                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}];
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    for (int i = 0; i < _attriStr.string.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [_attriStr.string substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [_attriStr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#F908DA"]} range:NSMakeRange(i, 1)];
        }
    }
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
    PPForumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPForumCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section < self.dataSource.count) {
        PPColumnModel *column = self.dataSource[indexPath.section];
        if (indexPath.item < column.programList.count) {
            PPProgramModel *program = column.programList[indexPath.item];
            cell.imgUrl = program.coverImg;
            cell.title = program.title;
            cell.theme = program.title;
            cell.latest = program.spare;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat width = fullWidth/2-kWidth(40);
    return CGSizeMake((long)width, (long)kWidth(150));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kWidth(20), 1, kWidth(20));
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PPColumnModel *column;
    PPProgramModel *program;

    if (indexPath.section < self.dataSource.count) {
        column = self.dataSource[indexPath.section];
        if (indexPath.item < column.programList.count) {
            program = column.programList[indexPath.item];
        }
    }

    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            PPForumTitleView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPForumTitleViewReusableIdentifier forIndexPath:indexPath];
            titleView.attriString = _attriStr;
            return titleView;
        } else {
            PPForumHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPForumHeaderViewReusableIdentifier forIndexPath:indexPath];
            headerView.title = column.name;
            headerView.owner = column.columnDesc;
            return headerView;
        }
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
    if ([PPUtil currentVipLevel] != PPVipLevelVipC) {
        [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"论坛只针对黑金VIP用户开放" cancelButtonTitle:@"再考虑看看" otherButtonTitles:@[@"立即开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self presentPayViewControllerWithBaseModel:nil];
            }
        }];
    } else {
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[PPSystemConfigModel sharedModel].forumUrl]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[PPSystemConfigModel sharedModel].forumUrl]];
//        }
        PPWebViewController *webVC = [[PPWebViewController alloc] initWithURL:[NSURL URLWithString:[PPSystemConfigModel sharedModel].forumUrl] standbyURL:nil];
        [self.navigationController pushViewController:webVC animated:YES];

    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

@end
