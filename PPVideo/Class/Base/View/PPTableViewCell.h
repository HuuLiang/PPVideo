//
//  PPTableViewCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTableViewCell : UITableViewCell

@property (nonatomic,retain,readonly) UIImageView *iconImageView;
@property (nonatomic,retain,readonly) UILabel *titleLabel;
@property (nonatomic,retain,readonly) UILabel *subtitleLabel;
@property (nonatomic,retain,readonly) UIImageView *backgroundImageView;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;


@end
