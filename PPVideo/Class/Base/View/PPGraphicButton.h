//
//  PPGraphicButton.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchAction)(void);

@interface PPGraphicButton : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *imageV;
@property (nonatomic) BOOL isSelected;

- (instancetype)initWithNormalTitle:(NSString *)normalTitle
                      selectedTitle:(NSString *)selectedTitle
                        normalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage
                              space:(CGFloat)space
                       isTitleFirst:(BOOL)isTitleFirst
                        touchAction:(touchAction)action;

@end
