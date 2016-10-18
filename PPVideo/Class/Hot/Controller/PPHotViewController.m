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

@interface PPHotViewController () <UICollectionViewDataSource,UICollectionViewDelegate,PPSectionBackgroundFlowLayoutDelegate>
{
    UICollectionView *_layoutCollectionView;
    
    BOOL _loadMoreTags;
}
@end

@implementation PPHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PPSectionBackgroundFlowLayout *mainLayout = [[PPSectionBackgroundFlowLayout alloc] init];
//    mainLayout.minimumLineSpacing = kWidth(20);
//    mainLayout.minimumInteritemSpacing = kWidth(20);
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
    _loadMoreTags = NO;
    
    [_layoutCollectionView reloadData];
    [_layoutCollectionView PP_endPullToRefresh];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return PPHotSectionContent;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == PPHotSectionTag) {
        if (_loadMoreTags) {
            return 6;
        }else {
            return 12;
        }
    } else if (section == PPHotSectionContent) {
        return 4;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PPHotSectionTag) {
        PPHotTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPHotTagCellReusableIdentifier forIndexPath:indexPath];;
        cell.titleStr = @"神舟";
        return cell;
    } else if (indexPath.section == PPHotSectionContent) {
        PPSexCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPHotNormalCellReusableIdentifier forIndexPath:indexPath];
        normalCell.imgUrlStr = @"http://www.1tong.com/uploads/wallpaper/anime/209-3-1920x1200.jpg";
        normalCell.titleStr = @"神舟十一号载人飞船发射成功";
        normalCell.playCount = 1234;
        normalCell.commentCount = 2345;
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
        return CGSizeMake((long)width, height);
    } else if (indexPath.section == PPHotSectionCount) {
        CGFloat width = (fullWidth - insets.left - insets.right -  itemSpacing) / 2;
        CGFloat height = width * 0.6 + kWidth(88);
        return CGSizeMake(width, height);
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
            PPHotTagHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPHotTagHeaderViewReusableIdentifier forIndexPath:indexPath];
            if (indexPath.section == PPHotSectionTag) {
                headerView.titleStr = @"热搜标签";
                headerView.titleColorStr = @"#666666";
                headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            } else if (indexPath.section == PPHotSectionContent) {
                headerView.titleStr = @"精品推荐";
                headerView.titleColorStr = @"#333333";
                headerView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
            }
            return headerView;
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
    if (section == PPHotSectionTag || section == PPHotSectionContent) {
        return CGSizeMake(kScreenWidth, kWidth(80));
    } else {
        return CGSizeZero;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout shouldDisplaySectionBackgroundInSection:(NSUInteger)section {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PPHotSectionTag) {
        [_layoutCollectionView reloadSections:[NSIndexSet indexSetWithIndex:PPHotSectionContent]];
    } else if (indexPath.section == PPHotSectionContent) {
        return;
    }
}

@end
