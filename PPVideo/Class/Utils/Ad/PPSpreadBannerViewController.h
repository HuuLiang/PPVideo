//
//  PPSpreadBannerViewController.h
//  PPVideo
//
//  Created by Liang on 2016/10/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"
#import "PPAppModel.h"

@interface PPSpreadBannerViewController : PPBaseViewController
@property (nonatomic,retain,readonly) NSArray<PPAppSpread *> *spreads;
- (instancetype)initWithSpreads:(NSArray<PPAppSpread *> *)spreads;
- (void)showInViewController:(UIViewController *)viewController;
@end
