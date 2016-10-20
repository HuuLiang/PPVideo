//
//  PPPaymentViewController.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"

@interface PPPaymentViewController : PPBaseViewController

+ (instancetype)sharedPaymentVC;

//- (void)popupPaymentInView:(UIView *)view
//                forProgram:(YYKProgram *)program
//           programLocation:(NSUInteger)programLocation
//                 inChannel:(YYKChannel *)channel
//     withCompletionHandler:(void (^)(void))completionHandler
//              footerAction:(YYKAction)footerAction;
- (void)hidePayment;

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo;


@end
