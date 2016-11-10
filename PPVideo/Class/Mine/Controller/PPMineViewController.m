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
#import "PPMineActVC.h"
#import "PPMineVipVC.h"

static NSString *const kMoreCellReusableIdentifier = @"MoreCellReusableIdentifier";
#define appCellWidth (kScreenWidth-kWidth(40)*3)/3

@interface PPMineViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    PPMineHeaderCell *_headerCell;
    PPTableViewCell *_activateCell;
    PPTableViewCell *_vipCell;
    PPTableViewCell *_qqCell;
    PPTableViewCell *_baiduCell;
    
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
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor clearColor]};

    self.navigationController.navigationBar.hidden = YES;
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
//    self.layoutTableView.hasRowSeparator = NO;
    [self.layoutTableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(-20);
        }];
    }
    

    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_headerCell) {
            [self presentPayViewControllerWithBaseModel:nil];
        } else if (cell == self->_vipCell) {
            PPMineVipVC *vipVC = [[PPMineVipVC alloc] initWithTitle:@"会员特权"];
            [self.navigationController pushViewController:vipVC animated:YES];
        } else if (cell == self->_activateCell) {
            PPMineActVC *actVC = [[PPMineActVC alloc] initWithTitle:@"自助激活"];
            [self.navigationController pushViewController:actVC animated:YES];
        } else if (cell == self->_qqCell) {
            [self contactCustomerService];
        } else if (cell == self->_baiduCell) {
            [UIAlertView bk_showAlertViewWithTitle:nil
                                           message:@"更多精彩内容，请转至百度云观看"
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@[@"确认"]
                                           handler:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 if (buttonIndex == 1 && [PPSystemConfigModel sharedModel].baiduyuUrl.length > 0) {
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[PPSystemConfigModel sharedModel].baiduyuUrl]];
                 }
             }];
        }
    };
    
    [self initCells];
    
    [self.layoutTableView PP_addPullToRefreshWithHandler:^{
        [self loadAppData];
    }];
    
    if ([PPCacheModel getAppCache].count > 0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[PPCacheModel getAppCache]];
        [self initAppCell:currentSection];
    }
    
    [self.layoutTableView PP_triggerPullToRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
    
}

- (void)onPaidNotification:(NSNotification *)notification {
    [self.layoutTableView PP_triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)contactCustomerService {
    NSString *contactScheme = nil;
    NSString *contactName = nil;
    if ([PPUtil currentVipLevel] == PPVipLevelVipA) {
        contactName = [PPSystemConfigModel sharedModel].contactName1;
        contactScheme = [PPSystemConfigModel sharedModel].contactScheme1;
    } else if ([PPUtil currentVipLevel] == PPVipLevelVipB) {
        contactName = [PPSystemConfigModel sharedModel].contactName2;
        contactScheme = [PPSystemConfigModel sharedModel].contactScheme2;
    } else if ([PPUtil currentVipLevel] == PPVipLevelVipC) {
        contactName = [PPSystemConfigModel sharedModel].contactName3;
        contactScheme = [PPSystemConfigModel sharedModel].contactScheme3;
    }
    
    
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
        [self.layoutTableView PP_endPullToRefresh];
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
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

- (void)initVipInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    _activateCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_activate"] title:@"自助激活"];
    _activateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _activateCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_activateCell cellHeight:tableViewCellheight inRow:0 andSection:section];
    
    _vipCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_vip"] title:@"会员特权"];
    _vipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_vipCell cellHeight:tableViewCellheight inRow:1 andSection:section];
}

- (void)initQQCellInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    _qqCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_qq"] title:@"在线客服"];
    _qqCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _qqCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_qqCell cellHeight:tableViewCellheight inRow:0 andSection:section];
    
    if ([PPUtil currentVipLevel] == PPVipLevelVipC)  {
        _baiduCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_baidu"] title:@"百度云" subtitle:[PPSystemConfigModel sharedModel].baiduyuCode];
        _baiduCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _baiduCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setLayoutCell:_baiduCell cellHeight:tableViewCellheight inRow:1 andSection:section];
    }
}

- (UICollectionViewLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kWidth(44);
    layout.minimumInteritemSpacing = kWidth(20);
    layout.itemSize = CGSizeMake((long)appCellWidth, appCellWidth+kWidth(40));
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
    
    [self setLayoutCell:_appCell cellHeight:(appCellWidth+kWidth(40))* lineCount + kWidth(44) + kWidth(60)  inRow:0 andSection:section];
    
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
