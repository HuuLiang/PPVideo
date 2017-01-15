//
//  LsWxPayManager.h
//  lshWxSdk
//
//  Created by joe on 17/1/12.
//  Copyright © 2017年 leiSheng. All rights reserved.
//

#import "SPayClient.h"

@interface LsWxPayManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  设置商户渠道模式
 *
 *
 */
-(void)macChannelConfig;

/**
 *   代理商户模式
 *
 *
 */
- (void)applicationWillEnterForeground:(UIApplication *)application;
/**
 *  viewController ---------------------    调用的视图一般为self
 *  appid	---------------------   微信appid，通过统一下单接口获取
 *  token_id  		--------------------------  通过统一下单接口获取
 */
-(void)sendPayRequestWithViewController:(UIViewController *)viewController appid:(NSString *)appid token_id:(NSString *)token_id success:(void (^)(SPayClientPayStateModel *payStateModel, SPayClientPaySuccessDetailModel *paySuccessDetailModel))successBlock;

@end
