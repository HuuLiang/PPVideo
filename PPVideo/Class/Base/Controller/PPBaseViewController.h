//
//  PPBaseViewController.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPBaseViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title vipLevel:(PPVipLevel)vipLevel;
@end
