//
//  PPBaseViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"
#import "PPSystemConfigModel.h"
#import "PPDetailViewController.h"

@interface PPBaseViewController ()
@property (nonatomic,weak) UIButton *refreshBtn;
@end

@implementation PPBaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushDetailViewControllerWithColumnId:(NSInteger)columnId
                                RealColumnId:(NSInteger)realColumnId
                                  columnType:(NSInteger)columnType
                             programLocation:(NSInteger)programLocation
                              andProgramInfo:(PPProgramModel *)programModel {
    QBBaseModel *baseModel = [QBBaseModel getBaseModelWithRealColoumId:[NSNumber numberWithInteger:realColumnId]
                                                           channelType:[NSNumber numberWithInteger:columnType]
                                                             programId:[NSNumber numberWithInteger:programModel.programId]
                                                           programType:[NSNumber numberWithInteger:programModel.type]
                                                       programLocation:[NSNumber numberWithInteger:programLocation]];
    [[QBStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound];
    PPDetailViewController *detailVC = [[PPDetailViewController alloc] initWithBaseModelInfo:baseModel ColumnId:columnId programInfo:programModel];
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(QBAction) action;{
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn = refreshBtn;
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(18.)];
    [refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(kScreenWidth/2.-kWidth(40.), (kScreenHeight-113.)/2. -kWidth(40.), kWidth(80.),kWidth(80.));
    refreshBtn.backgroundColor = [UIColor clearColor];
    [view addSubview:refreshBtn];
    [UIView animateWithDuration:0.4 animations:^{
        refreshBtn.transform = CGAffineTransformMakeScale(1.8, 1.8);
    }];
    [refreshBtn bk_addEventHandler:^(id sender) {
        if (action) {
            action(refreshBtn);
        }
        refreshBtn.transform = CGAffineTransformMakeScale(0.56, 0.56);
        [UIView animateWithDuration:0.4 animations:^{
            refreshBtn.transform = CGAffineTransformMakeScale(1.8, 1.8);
        }];
        
        if (![PPSystemConfigModel sharedModel].loaded) {
            [[PPSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:nil];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)removeCurrentRefreshBtn{
    if (self.refreshBtn) {
        [self.refreshBtn removeFromSuperview];
        self.refreshBtn = nil;
    }
}

@end
