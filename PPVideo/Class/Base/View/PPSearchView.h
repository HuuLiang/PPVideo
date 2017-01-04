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

@property (nonatomic) BOOL firstResponder;

- (void)showInSuperView:(UIView *)view animated:(BOOL)animated;

- (void)hideFormSuperView;



@end


@interface PPSearchBar : UITextField


@end
