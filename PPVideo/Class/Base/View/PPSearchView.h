//
//  PPSearchView.h
//  PPVideo
//
//  Created by Liang on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSearchView : UIView

+ (instancetype)showView;

@property (nonatomic) CGFloat bgColorAlpha;

- (void)showInSuperView:(UIView *)view;

- (void)hideFormSuperView;

@end


@interface PPSearchBar : UITextField


@end
