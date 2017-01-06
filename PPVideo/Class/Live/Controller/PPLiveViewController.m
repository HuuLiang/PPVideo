//
//  PPLiveViewController.m
//  PPVideo
//
//  Created by Liang on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PPLiveCell.h"
#import "PPLiveModel.h"

static NSString *const kPPLiveCellReusableIdentifier       = @"kPPLiveCellReusableIdentifier";
static NSString *const kPPLiveHeaderViewReusableIdentifier = @"PPLiveHeaderViewReusableIdentifier";

@interface PPLiveViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    AVPlayer        *_player;
    AVPlayerLayer   *_playerLayer;
    AVPlayerItem    *_playerItem;
    NSURL       *_playerVideoUrl; //视频链接
    UIImageView *_imageView;      //背景图片
    NSURL       *_originalUrl;    //原始图片链接
    NSURL       *_newUrl;         //新图片链接
    UICollectionView *_layoutCollectionView;
    NSUInteger  refreshPage;     //主播刷新页码
    BOOL        isRefresh;       //
}
@property (nonatomic) PPLiveModel *liveModel;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation PPLiveViewController
QBDefineLazyPropertyInitialization(PPLiveModel, liveModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshPage = 0;

    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imageView];
    
    @weakify(self);
    [_imageView bk_whenTapped:^{
        @strongify(self);
        [self->_player play];
        self->_layoutCollectionView.hidden = NO;
        [_imageView sd_setImageWithURL:_newUrl];
    }];
    
    {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(0);
    mainLayout.minimumInteritemSpacing = kWidth(10);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.6];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[PPLiveCell class] forCellWithReuseIdentifier:kPPLiveCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPPLiveHeaderViewReusableIdentifier];
    _layoutCollectionView.scrollEnabled = NO;
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.9, ((kScreenWidth *0.9-kWidth(60))/3+kWidth(78))*3 + kWidth(150)));
        }];
    }
    
    [_layoutCollectionView PP_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    [_layoutCollectionView PP_triggerPullToRefresh];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndPlay) name:AVPlayerItemDidPlayToEndTimeNotification  object:nil];
}

- (void)didEndPlay {
    _imageView.userInteractionEnabled = NO;
    [_imageView sd_setImageWithURL:_newUrl];
    _layoutCollectionView.hidden = NO;
    [_playerLayer removeFromSuperlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PPUtil launchSeq] == 1) {
        _layoutCollectionView.hidden = YES;
    }
    
    if ([PPUtil shouldRefreshLiveContent]) {
        refreshPage++;
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)alwaysHideNavigationBar {
    return YES;
}

- (void)loadData {
    @weakify(self);
    [self.liveModel fetchLiveInfoWithPage:refreshPage CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [self removeCurrentRefreshBtn];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutCollectionView reloadData];
            [self setBackgroundContent];
        }
        [self->_layoutCollectionView PP_endPullToRefresh];
    }];
}

- (void)setBackgroundContent {
    PPColumnModel *column = [self.dataSource firstObject];
    PPProgramModel *program = [column.programList firstObject];
    
    _playerVideoUrl = [NSURL URLWithString:program.videoUrl];
    _originalUrl = [NSURL URLWithString:program.coverImg];
    _newUrl = [NSURL URLWithString:program.detailsCoverImg];

    if ([PPUtil launchSeq] == 1) {
        _imageView.userInteractionEnabled = YES;
        [_imageView sd_setImageWithURL:_originalUrl];
        self->_layoutCollectionView.hidden = YES;
        
        _playerItem = [AVPlayerItem playerItemWithURL:_playerVideoUrl];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.view.layer addSublayer:_playerLayer];
    } else {
        [_imageView sd_setImageWithURL:_newUrl];
    }
    

}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    PPColumnModel *column = [self.dataSource lastObject];
    return column.programList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPLiveCellReusableIdentifier forIndexPath:indexPath];
    PPColumnModel *column = [self.dataSource lastObject];
    if (indexPath.item < column.programList.count) {
        PPProgramModel *program = column.programList[indexPath.item];
        cell.imgUrl = program.coverImg;
        cell.nickName = program.title;
        cell.hotCount = program.spare;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat width = (fullWidth - kWidth(60))/3;
    CGFloat height = width+kWidth(78);
    NSLog(@"%@",NSStringFromCGSize(CGSizeMake((long)width, (long)height)));
    
    return CGSizeMake((long)width, (long)height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kWidth(20), 0, kWidth(20));
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kPPLiveHeaderViewReusableIdentifier forIndexPath:indexPath];
            
            UILabel *desclabel = [[UILabel alloc] init];
            desclabel.textColor = [UIColor colorWithHexString:@"#FFB901"];
            desclabel.font = [UIFont systemFontOfSize:kWidth(24)];
            desclabel.text = @"SVIP会员  专属同城美女聊天社区（未满十八岁禁入）";
            [headerView addSubview:desclabel];
            
            UILabel *playLabel = [[UILabel alloc] init];
            playLabel.text = @"热播中";
            playLabel.textColor = [UIColor colorWithHexString:@"#FF90F2"];
            playLabel.font = [UIFont systemFontOfSize:kWidth(32)];
            [headerView addSubview:playLabel];
            
            {
                [desclabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(headerView).offset(kWidth(36));
                    make.left.equalTo(headerView).offset(kWidth(14));
                    make.height.mas_equalTo(kWidth(24));
                }];
                
                [playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(desclabel.mas_bottom).offset(kWidth(26));
                    make.left.equalTo(headerView).offset(kWidth(14));
                    make.height.mas_equalTo(kWidth(32));
                }];
            }
            
            return headerView;
        }
    }
    return nil;
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kWidth(150));
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
