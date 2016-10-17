//
//  PPVipViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVipViewController.h"
#import "PPTrailNormalCell.h"
#import "PPVipModel.h"

static NSString *const kPPVipCellReusableIdentifier = @"PPVipCellReusableIdentifier";

@interface PPVipViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    PPVipLevel _vipLevel;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) PPVipModel *vipModel;
@end

@implementation PPVipViewController
QBDefineLazyPropertyInitialization(PPVipModel, vipModel)

- (instancetype)initWithTitle:(NSString *)title vipLevel:(PPVipLevel)vipLevel
{
    self = [super init];
    if (self) {
        
        self.title = title;
        _vipLevel = vipLevel;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = kWidth(20);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPTrailNormalCell class] forCellWithReuseIdentifier:kPPVipCellReusableIdentifier];

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
//    [self.vipModel fetchVipInfoWithVipLevel:_vipLevel CompletionHandler:^(BOOL success, id obj) {
//        @strongify(self);
//        if (success) {
//            
//        } else {
//            
//        }
//    }];
    
    [_layoutCollectionView reloadData];
    [_layoutCollectionView PP_endPullToRefresh];
    
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
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PPTrailNormalCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPVipCellReusableIdentifier forIndexPath:indexPath];
    normalCell.imgUrlStr = @"http://www.1tong.com/uploads/wallpaper/anime/209-3-1920x1200.jpg";
    normalCell.titleStr = @"神舟十一号载人飞船发射成功";
    normalCell.playCount = 1234;
    normalCell.commentCount = 2345;
    return normalCell;
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.section == 0) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
        CGFloat height = width * 9 /7;
        return CGSizeMake(width, height);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
}



@end
