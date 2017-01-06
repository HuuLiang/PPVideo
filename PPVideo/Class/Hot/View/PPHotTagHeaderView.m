//
//  PPHotTagHeaderView.m
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPHotTagHeaderView.h"

@interface PPHotTagHeaderView ()
{
    UILabel *_titleLabel;
}
@end

@implementation PPHotTagHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:imgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:kWidth(32)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        {
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(26), kWidth(26)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(imgV.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(48));
            }];
        }
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setTitleColorStr:(NSString *)titleColorStr {
    _titleLabel.textColor = [UIColor colorWithHexString:titleColorStr];
}

@end
