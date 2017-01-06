//
//  PPSearchView.h
//  PPVideo
//
//  Created by Liang on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPSearchViewDelegate <NSObject>
@optional
- (void)searchContentWithInfo:(NSString *)title;
@end

@interface PPSearchView : UIView

+ (instancetype)showView;

@property (nonatomic) CGFloat bgColorAlpha;

@property (nonatomic) BOOL becomeResponder;

@property (nonatomic,weak) id<PPSearchViewDelegate> delegate;

- (void)showInSuperView:(UIView *)view animated:(BOOL)animated;


@end


@interface PPSearchBar : UITextField


@end
