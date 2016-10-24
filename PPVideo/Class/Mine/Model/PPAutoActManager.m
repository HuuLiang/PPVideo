//
//  PPAutoActManager.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPAutoActManager.h"
#import <QBPaymentManager.h>
#import "PPPaymentViewController.h"

@implementation PPAutoActManager
+ (instancetype)sharedManager {
    static PPAutoActManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)doActivation {
    if ([PPUtil currentVipLevel] == PPVipLevelVipC) {
        [UIAlertView bk_showAlertViewWithTitle:@"您已经购买了全部VIP，无需再激活！" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        return ;
    }
    
    NSArray<QBPaymentInfo *> *paymentInfos = [PPUtil allUnsuccessfulPaymentInfos];
    paymentInfos = [paymentInfos bk_select:^BOOL(QBPaymentInfo *paymentInfo) {
        return paymentInfo.payPointType > [PPUtil currentVipLevel];
    }];
    

    [[UIApplication sharedApplication].keyWindow beginLoading];
    [[QBPaymentManager sharedManager] activatePaymentInfos:paymentInfos withCompletionHandler:^(BOOL success, id obj) {
        [[UIApplication sharedApplication].keyWindow endLoading];
        if (success) {
            [UIAlertView bk_showAlertViewWithTitle:@"激活成功" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
//            [[PPPaymentViewController sharedPaymentVC] notifyPaymentResult:QBPayResultSuccess withPaymentInfo:obj];
            PPPaymentViewController *paymentVC = [[PPPaymentViewController alloc] initWithBaseModel:nil];
            [paymentVC notifyPaymentResult:QBPayResultSuccess withPaymentInfo:obj];
        } else {
            [UIAlertView bk_showAlertViewWithTitle:@"未找到支付成功的订单" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        }
    }];
}


@end
