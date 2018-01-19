//
//  PPSearchResultViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSearchResultViewController.h"
#import "PPSearchCell.h"
#import "PPSearchModel.h"

static NSString *const kPPSearchCellReusableIdentifier = @"PPSearchCellReusableIdentifier";


@interface PPSearchResultViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
    NSInteger _columnId;
}
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation PPSearchResultViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (instancetype)initWithProgramList:(NSArray <PPSearchProgramModel *> *)programList searchWords:(NSString *)searchWords ColumnId:(NSInteger)columnId {
    if (self = [super init]) {
        [self.dataSource addObjectsFromArray:programList];
        self.title = searchWords;
        _columnId = columnId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = 0;
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPSearchCell class] forCellWithReuseIdentifier:kPPSearchCellReusableIdentifier];
    
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if ([PPUtil currentVipLevel] == PPVipLevelNone && self.dataSource.count > 4) {
        @weakify(self);
        [_layoutCollectionView PP_addVIPNotiRefreshWithHandler:^{
            @strongify(self);
            QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:nil
                                                                   channelType:nil
                                                                     programId:nil
                                                                   programType:nil
                                                               programLocation:nil];
            [self presentPayViewControllerWithBaseModel:baseModel];
            [_layoutCollectionView PP_endPullToRefresh];
        }];
    }

    [_layoutCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        return self.dataSource.count > 4 ? 4 : self.dataSource.count;
    }
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPSearchCell *searchCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPSearchCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        PPSearchProgramModel *program = self.dataSource[indexPath.item];
        searchCell.imgUrlStr = program.coverImg;
        searchCell.titleStr = program.title;
        NSArray *countArr = [program.spare componentsSeparatedByString:@"|"];
        if (countArr.count > 0) {
            searchCell.playCount = [[countArr firstObject] integerValue];
            searchCell.commentCount = [[countArr lastObject] integerValue];
        }
        NSArray *tagArr = [program.tag componentsSeparatedByString:@"|"];
        if (tagArr.count > 0) {
            searchCell.tagStr = [tagArr lastObject];
            searchCell.tagHexStr = [tagArr firstObject];
        }
    }
    return searchCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.section == 0) {
        CGFloat width = fullWidth - insets.left - insets.right;
        CGFloat height = width /2 + kWidth(120);
        return CGSizeMake((long)width, (long)height);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        PPSearchProgramModel *program = self.dataSource[indexPath.item];
        program.hasTimeControl = YES;
        [self pushDetailViewControllerWithColumnId:program.columnId RealColumnId:program.realColumnId columnType:program.type programLocation:indexPath.item andProgramInfo:program];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}


@end
