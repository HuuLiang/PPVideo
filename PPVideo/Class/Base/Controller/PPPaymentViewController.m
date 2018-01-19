//
//  PPPaymentViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPPaymentViewController.h"
#import <QBPaymentManager.h>
#import "PPSystemConfigModel.h"

#import "PPPayHeaderCell.h"
#import "PPPayPointCell.h"
#import "PPPayIntroCell.h"
#import "PPPayTypeCell.h"

#import "PPMineActVC.h"

@interface PPPaymentViewController ()
{
    PPVipLevel _vipLevel;
    
    PPPayHeaderCell *_headerCell;
    
    PPPayPointCell  *_pointCell;
    PPPayPointCell  *_subPointCell;
    
    PPPayIntroCell  *_introCell;
    
    UITableViewCell *_activateCell;
}
//@property (nonatomic) PPPaymentPopView *popView;
@property (nonatomic) QBBaseModel *baseModel;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@end

@implementation PPPaymentViewController
QBDefineLazyPropertyInitialization(QBBaseModel, baseModel)

- (void)payForPaymentType:(QBOrderPayType)orderPayType vipLevel:(PPVipLevel)vipLevel {
    
    [[QBPaymentManager sharedManager] startPaymentWithOrderInfo:[self createOrderInfoWithPaymentType:orderPayType vipLevel:vipLevel]
                                                    contentInfo:[self createContentInfo]
                                                    beginAction:^(QBPaymentInfo * paymentInfo) {
        if (paymentInfo) {
                    [[QBStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:QBStatsPayActionGoToPay andTabIndex:[PPUtil currentTabPageIndex] subTabIndex:[PPUtil currentSubTabPageIndex]];
        }
    } completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
    }];
}

- (QBOrderInfo *)createOrderInfoWithPaymentType:(QBOrderPayType)payType vipLevel:(PPVipLevel)vipLevel {
    QBOrderInfo *orderInfo = [[QBOrderInfo alloc] init];
    
    NSString *channelNo = PP_CHANNEL_NO;
    if (channelNo.length > 14) {
        channelNo = [channelNo substringFromIndex:channelNo.length-14];
    }
    
    channelNo = [channelNo stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    orderInfo.orderId = orderNo;
    
    NSUInteger price = 0;
    if (vipLevel == PPVipLevelVipA) {
        price = [PPSystemConfigModel sharedModel].payAmount;
    } else if (vipLevel == PPVipLevelVipB) {
        if ([PPUtil currentVipLevel] == PPVipLevelNone) {
            price = [PPSystemConfigModel sharedModel].payAmount + [PPSystemConfigModel sharedModel].payzsAmount;
        } else {
            price = [PPSystemConfigModel sharedModel].payzsAmount;
        }
    } else if (vipLevel == PPVipLevelVipC) {
        price = [PPSystemConfigModel sharedModel].payhjAmount;
    }
    
    orderInfo.orderPrice = price;
    
    NSString *orderDescription = [[PPSystemConfigModel sharedModel] currentContactName] ?: @"VIP";

    orderInfo.orderDescription = orderDescription;
    orderInfo.payType = payType;
    orderInfo.reservedData = [PPUtil paymentReservedData];
    orderInfo.createTime = [PPUtil currentTimeStringWithFormat:KTimeFormatLong];
    orderInfo.payPointType = vipLevel;
    orderInfo.userId = [PPUtil userId];
    orderInfo.maxDiscount = [PPSystemConfigModel sharedModel].maxDiscount < 0 ? 3 : [PPSystemConfigModel sharedModel].maxDiscount;
    
    return orderInfo;
}

- (QBContentInfo *)createContentInfo {
    QBContentInfo *contenInfo = [[QBContentInfo alloc] init];
    contenInfo.contentId = self.baseModel.programId;
    contenInfo.contentType = self.baseModel.programType;
    contenInfo.contentLocation = self.baseModel.programLocation;
    contenInfo.columnId = self.baseModel.realColumnId;
    contenInfo.columnType = self.baseModel.channelType;
    return contenInfo;
}

- (void)hidePayment {
    [[QBStatsManager sharedManager] statsPayWithOrderNo:nil payAction:QBStatsPayActionClose payResult:QBPayResultUnknown forBaseModel:self.baseModel andTabIndex:[PPUtil currentTabPageIndex] subTabIndex:[PPUtil currentSubTabPageIndex]];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo {
    if (result == QBPayResultSuccess) {
        [PPUtil registerVip:paymentInfo.payPointType];
        [self hidePayment];
        [[PPHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        if ([PPUtil currentVipLevel] == PPVipLevelVipA && ![PP_CHANNEL_NO isEqualToString:@"IOS_XIUXIU_0001"]) {
            [PPUtil showSpreadBanner];
        }
        
    } else if (result == QBPayResultCancelled) {
        [[PPHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[PPHudManager manager] showHudWithText:@"支付失败"];
    }
    
    if (paymentInfo.orderId != nil) {
        [[QBStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:QBStatsPayActionPayBack andTabIndex:[PPUtil currentTabPageIndex] subTabIndex:[PPUtil currentSubTabPageIndex]];
    }
}

#pragma mark - system

- (instancetype)initWithBaseModel:(QBBaseModel *)baseModel
{
    self = [super init];
    if (self) {
        self.baseModel = baseModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_vipLevel == PPVipLevelNone) {
        self.navigationItem.title = @"充值永久会员";
    } else if (_vipLevel == PPVipLevelVipA) {
        self.navigationItem.title = @"升级钻石会员";
    } else if (_vipLevel == PPVipLevelVipB) {
        self.navigationItem.title = @"升级黑金会员";
    }
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self hidePayment];
    }];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#B854B4"];
    

    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_pointCell) {
            if (!self->_subPointCell) {
                return ;
            } else {
                if (self->_pointCell.isSelected) {
                    return;
                } else{
                    self->_subPointCell.isSelected = NO;
                    self->_pointCell.isSelected = YES;
                    self->_vipLevel = self->_pointCell.vipLevel;
                }
            }
        } else if (cell == self->_subPointCell) {
            if (self->_subPointCell.isSelected) {
                return;
            } else{
                self->_subPointCell.isSelected = YES;
                self->_pointCell.isSelected = NO;
                self->_vipLevel = self->_subPointCell.vipLevel;
            }
        } else if (cell == self->_activateCell) {
            PPMineActVC *actVC = [[PPMineActVC alloc] init];
            [self.navigationController pushViewController:actVC animated:YES];
        }
    };
    
    [self initCells];
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - InitCells

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initPayHeaderCellInSection:section++];
    [self initFirstPayCellInSection:section++];
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        [self initSubPayCellInSection:section++];
    }
    [self initIntroCellInSection:section++];
    
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeWeChatPay]) {
        [self initPayCellWithPayType:QBOrderPayTypeWeChatPay InSection:section++];
    }
    
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeAlipay]) {
        [self initPayCellWithPayType:QBOrderPayTypeAlipay InSection:section++];
    }
    
    [self initActivateCellInSection:section++];
    
    [self.layoutTableView reloadData];
}

- (void)initPayHeaderCellInSection:(NSInteger)section {
    _headerCell = [[PPPayHeaderCell alloc] init];
    _headerCell.vipLevel = [PPUtil currentVipLevel];
    
    CGFloat height = 0;
    if ([PPUtil deviceType] == PPDeviceType_iPhone4 || [PPUtil deviceType] == PPDeviceType_iPhone4S) {
        height = [PPUtil currentVipLevel] == PPVipLevelNone ? kWidth(190) : kWidth(240);
    } else {
        height = [PPUtil currentVipLevel] == PPVipLevelNone ? ([PPUtil isIpad] ? kWidth(200) : kWidth(264)) : ([PPUtil isIpad] ? kWidth(200) : kWidth(364));
    }
    
    
    [self setLayoutCell:_headerCell cellHeight:height inRow:0 andSection:section];
}

- (void)initFirstPayCellInSection:(NSInteger)section {
    _pointCell = [[PPPayPointCell alloc] init];
    _pointCell.isSelected = YES;
    _pointCell.vipLevel = [PPUtil currentVipLevel] + 1;
    self->_vipLevel = _pointCell.vipLevel;
    [self setLayoutCell:_pointCell cellHeight:kWidth(140) inRow:0 andSection:section];
}

- (void)initSubPayCellInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(42) inSection:section];
    
    _subPointCell = [[PPPayPointCell alloc] init];
    _subPointCell.isSelected = NO;
    _subPointCell.vipLevel = PPVipLevelVipB;
    [self setLayoutCell:_subPointCell cellHeight:kWidth(140) inRow:0 andSection:section];
}

- (void)initIntroCellInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(26) inSection:section];
    
    _introCell = [[PPPayIntroCell alloc] init];
    
    NSString *str = nil;
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        str = vipNoneIntroStr;
    } else if ([PPUtil currentVipLevel] == PPVipLevelVipA) {
        str = vipAIntroStr;
    } else if ([PPUtil currentVipLevel] == PPVipLevelVipB) {
        str = vipBIntroStr;
    }
    
    _introCell.attStr = [str getAttriCenterStringWithFont:[UIFont systemFontOfSize:[PPUtil isIpad] ? 30 : kWidth(30)] lineSpace:[PPUtil isIpad] ? 8 : kWidth(8) maxSize:CGSizeMake(kScreenWidth - kWidth(136), MAXFLOAT)];
    CGFloat cellHeight = [str getStringHeightWithFont:[UIFont systemFontOfSize:[PPUtil isIpad] ? 30 : kWidth(30)] lineSpace:[PPUtil isIpad] ? 8 : kWidth(8) maxSize:CGSizeMake(kScreenWidth - kWidth(136), MAXFLOAT)];
    
    CGFloat height = 0;
    if ([PPUtil deviceType] == PPDeviceType_iPhone4 || [PPUtil deviceType] == PPDeviceType_iPhone4S) {
        height = [PPUtil currentVipLevel] == PPVipLevelNone ? kWidth(20) : kWidth(120);
    } else {
        height = [PPUtil currentVipLevel] == PPVipLevelNone ? ([PPUtil isIpad] ? 0 : kWidth(140)) : ([PPUtil isIpad] ? kWidth(120) : kWidth(160));
    }
    
    [self setLayoutCell:_introCell cellHeight:cellHeight+height inRow:0 andSection:section];
}

- (void)initPayCellWithPayType:(QBOrderPayType)orderPayType InSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(26) inSection:section];
    
    PPPayTypeCell *cell = [[PPPayTypeCell alloc] init];
    cell.orderPayType = orderPayType;
    @weakify(self);
    cell.payAction = ^{
        @strongify(self);
        [self payForPaymentType:orderPayType vipLevel:self->_vipLevel];
    };
    
    [self setLayoutCell:cell cellHeight:kWidth(98) inRow:0 andSection:section];
}

- (void)initActivateCellInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    _activateCell = [[UITableViewCell alloc] init];
    _activateCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"付费后未开通相应等级会员？" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[PPUtil isIpad] ? 28 : kWidth(28)],
                                                                                                       NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    label.attributedText = str;
    [_activateCell addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_activateCell);
        }];
    }
    
    [self setLayoutCell:_activateCell cellHeight:kWidth(40) inRow:0 andSection:section];
}

@end
