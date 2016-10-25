//
//  PPAutoActManager.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPAutoActManager : NSObject

+ (instancetype)sharedManager;

- (void)doActivation;


- (void)servicesActivationWithOrderId:(NSString *)orderId;

@end
