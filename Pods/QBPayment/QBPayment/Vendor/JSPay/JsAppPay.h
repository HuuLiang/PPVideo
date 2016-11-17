//
//  JsAppPay.h
//  JsAppPay
//
//  Created by 杰莘宏业 on 16/10/24.
//  Copyright © 2016年 杰莘宏业. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CompletioBlock)(id resultDic);

@interface JsAppPay : NSObject
+ (JsAppPay *)sharedInstance;

/**微信支付
 *  @param pushFromCtrl 当前视图
 *  @param description  商品描述
 *  @param goodsAmount  商品价格，单位为分
 *  @param appId        appid
 *  @param paraId       商户Id
 *  @param orderId      订单Id
 *  @param notifyUrl    回调地址，用来接收支付成功的订单
 *  @param attach       自定义字段
 *  @param key          密钥
 *  @param resultDic    支付的回调
 
 */

- (void)payOrderWithweixinPay:(UIViewController*)pushFromCtrl
                  description:(NSString *)description
                  goodsAmount:(NSString *)goodsAmount
                        appId:(NSString *)appId
                       paraId:(NSString *)paraId
                      orderId:(NSString *)orderId
                    notifyUrl:(NSString *)notifyUrl
                       attach:(NSString *)attach
                         key:(NSString *)key
             withSuccessBlock:(CompletioBlock)resultDic;






/**配置微信
 *  @param appid appid
 */
+(void)wechatpPayConfigWithApplication:(UIApplication *)application
         didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                                 appId:(NSString *)appId;


@end
