//
//  PPMineViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineViewController.h"
#import "PPMineHeaderCell.h"
#import "PPTableViewCell.h"
#import "PPAppModel.h"
#import "PPMineAppCell.h"

#import "PPSystemConfigModel.h"

static NSString *const kMoreCellReusableIdentifier = @"MoreCellReusableIdentifier";
#define appCellWidth (kScreenWidth-kWidth(20)*4)/3

@interface PPMineViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    PPMineHeaderCell *_headerCell;
    PPTableViewCell *_detailCell;
    PPTableViewCell *_activateCell;
    PPTableViewCell *_vipCell;
    PPTableViewCell *_qqCell;
    
    UITableViewCell *_appCell;
    UICollectionView *_appCollectionView;
    NSInteger currentSection;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) PPAppModel *appModel;
@end

@implementation PPMineViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(PPAppModel, appModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
//    self.layoutTableView.hasRowSeparator = NO;
    [self.layoutTableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(-20);
        }];
    }
    
    [self.layoutTableView PP_addPullToRefreshWithHandler:^{
        [self loadAppData];
    }];
    [self.layoutTableView PP_triggerPullToRefresh];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_headerCell) {
//            [self payWithInfo:nil];
        } else if (cell == self->_detailCell) {
            
        } else if (cell == self->_activateCell) {
            
        } else if (cell == self->_qqCell) {
            [self contactCustomerService];
        }
    };
    
    [self initCells];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
    
//    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
//        NSString *baseURLString = [JF_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, JF_BASE_URL.length-6) withString:@"******"];
//        [[CRKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@/%@", baseURLString, JF_CHANNEL_NO, JF_PACKAGE_CERTIFICATE, JF_REST_PV, JF_PAYMENT_PV]];
//    }];
    
}

- (void)contactCustomerService {
    NSString *contactScheme = [PPSystemConfigModel sharedModel].contactScheme;
    NSString *contactName = [PPSystemConfigModel sharedModel].contactName;
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服%@？", contactName ?: @""]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
         }
     }];
}


- (void)loadAppData {
    @weakify(self);
    [self.appModel fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [self.layoutTableView PP_endPullToRefresh];
            if (_dataSource.count > 0) {
                [self initAppCell:currentSection];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initHeaderCellInSection:section++];
    [self initDetailCellInSection:section++];
    [self initVipInSection:section++];
    
    if ([PPUtil currentVipLevel] != PPVipLevelNone) {
        [self initQQCellInSection:section++];
    }
    
    currentSection = section;
}

- (void)initHeaderCellInSection:(NSInteger)section {
    _headerCell = [[PPMineHeaderCell alloc] init];
    
    [self setLayoutCell:_headerCell cellHeight:kScreenWidth/2 inRow:0 andSection:section];
}

- (void)initDetailCellInSection:(NSUInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    _detailCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_detail"] title:@"个人资料"];
    _detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_detailCell cellHeight:44 inRow:0 andSection:section];
}

- (void)initVipInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    _activateCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_activate"] title:@"自助激活"];
    _activateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _activateCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_activateCell cellHeight:44 inRow:0 andSection:section];
    
    _vipCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_vip"] title:@"会员特权"];
    _vipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_vipCell cellHeight:44 inRow:1 andSection:section];
}

- (void)initQQCellInSection:(NSInteger)section {
    [self setHeaderHeight:20 inSection:section];
    
    _qqCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_qq"] title:@"在线客服"];
    _qqCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _qqCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_qqCell cellHeight:44 inRow:1 andSection:section];
}

- (UICollectionViewLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kWidth(20);
    layout.minimumInteritemSpacing = kWidth(20);
    layout.itemSize = CGSizeMake((long)appCellWidth, appCellWidth+kWidth(35));
    layout.sectionInset = UIEdgeInsetsMake(kWidth(40), kWidth(20), kWidth(20), kWidth(20));
    return layout;
}

- (void)initAppCell:(NSInteger)section {
    [self setHeaderHeight:20 inSection:section];
    
    _appCell = [[UITableViewCell alloc] init];
    _appCell.backgroundColor = [UIColor clearColor];
    _appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self createLayout]];
    _appCollectionView.backgroundColor = [UIColor clearColor];
    _appCollectionView.delegate = self;
    _appCollectionView.dataSource = self;
    _appCollectionView.scrollEnabled = NO;
    _appCollectionView.showsVerticalScrollIndicator = NO;
    [_appCollectionView registerClass:[PPMineAppCell class] forCellWithReuseIdentifier:kMoreCellReusableIdentifier];
    [_appCell addSubview:_appCollectionView];
    {
        [_appCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_appCell);
        }];
    }
    NSInteger lineCount = (self.dataSource.count % 3 == 0 ? self.dataSource.count / 3 : self.dataSource.count / 3 + 1 );
    
    [self setLayoutCell:_appCell cellHeight:(appCellWidth+kWidth(55))* lineCount + kWidth(40) inRow:0 andSection:section];
    
    [self.layoutTableView reloadData];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPMineAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMoreCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        PPAppSpread *app = self.dataSource[indexPath.item];
        cell.titleStr = app.title;
        cell.imgUrl = app.coverImg;
        cell.isInstall = app.isInstall;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        PPAppSpread *app = self.dataSource[indexPath.item];
        
        //        [[LTStatsManager sharedManager] statsCPCWithProgram:(LTProgram *)app programLocation:indexPath.item inChannel:(LTChannel *)self.appModel.fetchSpreadChannel andTabIndex:self.tabBarController.selectedIndex subTabIndex:[LTUtil currentSubTabPageIndex]];
        //
        if (app.videoUrl && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:app.videoUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.videoUrl]];
        }
    }
}

@end
