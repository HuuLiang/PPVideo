//
//  PPForumHeaderView.m
//  PPVideo
//
//  Created by Liang on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPForumHeaderView.h"

@interface PPForumHeaderView ()
{
    UIImageView *_shadowView;
    UILabel     *_titleLabel;
    UILabel     *_ownerLabel;
}
@end

@implementation PPForumHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [self addSubview:grayView];

        
        _shadowView = [[UIImageView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_shadowView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:kWidth(32)];
        [self addSubview:_titleLabel];
        
        _ownerLabel = [[UILabel alloc] init];
        _ownerLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _ownerLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:_ownerLabel];
        
        {
            [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(10));
                make.left.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
            
            [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(22));
                make.size.mas_equalTo(CGSizeMake(kWidth(26), kWidth(26)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_shadowView.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self.mas_right).offset(-kWidth(20));
                make.height.mas_equalTo(kWidth(30));
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setOwner:(NSString *)owner {
    _ownerLabel.text = owner;
}

@end



@interface PPForumTitleView ()
{
    UILabel *mainTitleLabel;
}
@end

@implementation PPForumTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        
        mainTitleLabel = [[UILabel alloc] init];
        mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        mainTitleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        mainTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:mainTitleLabel];
        
        {
            [mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(kWidth(40));
            }];
        }
    }
    return self;
}

- (void)setAttriString:(NSAttributedString *)attriString {
    mainTitleLabel.attributedText = attriString;
}

@end
