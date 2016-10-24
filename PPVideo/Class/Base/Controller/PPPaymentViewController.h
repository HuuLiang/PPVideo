//
//  PPPaymentViewController.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPLayoutViewController.h"

@interface PPPaymentViewController : PPLayoutViewController

- (instancetype)initWithBaseModel:(QBBaseModel *)baseModel;

- (void)hidePayment;

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo;


@end
