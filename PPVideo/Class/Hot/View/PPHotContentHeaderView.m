//
//  PPHotContentHeaderView.m
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPHotContentHeaderView.h"
#import "PPGraphicButton.h"


@interface PPHotContentHeaderView ()
{
    PPGraphicButton *_graphicBtn;
    UILabel *_titleLabel;
}

@end

@implementation PPHotContentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        @weakify(self);
        _graphicBtn = [[PPGraphicButton alloc] initWithNormalTitle:@"查看更多"
                                                     selectedTitle:@"收起"
                                                       normalImage:[UIImage imageNamed:@"hot_more"]
                                                     selectedImage:[UIImage imageNamed:@"hot_less"]
                                                             space:kWidth(16)
                                                      isTitleFirst:YES
                                                       touchAction:^
                       {
                           @strongify(self);
                           if (self.isSelected) {
                               self.isSelected();
                           }
                           self->_graphicBtn.isSelected = !self->_graphicBtn.isSelected;
                       }];
        _graphicBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        _graphicBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#B854B4"];
        
        [self addSubview:_graphicBtn];
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [self addSubview:_titleLabel];
        
        
    }
    
    UIImageView *_lineLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_line_left"]];
    [self addSubview:_lineLeft];
    
    UIImageView *_lineRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_line_right"]];
    [self addSubview:_lineRight];
    
    {
        [_graphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(kWidth(20));
            make.size.mas_equalTo(CGSizeMake(kWidth(166), kWidth(42)));
        }];
        
        [_lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_graphicBtn);
            make.left.equalTo(self).offset(kWidth(20));
            make.right.equalTo(_graphicBtn.mas_left).offset(-kWidth(20));
            make.height.mas_equalTo(kWidth(4));
        }];
        
        [_lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_graphicBtn);
            make.left.equalTo(_graphicBtn.mas_right).offset(kWidth(20));
            make.right.equalTo(self.mas_right).offset(-kWidth(20));
            make.height.mas_equalTo(kWidth(4));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(_graphicBtn.mas_bottom).offset(kWidth(20));
        }];
        
    }
    
    
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setTitleColorStr:(NSString *)titleColorStr {
    _titleLabel.textColor = [UIColor colorWithHexString:titleColorStr];
}

- (void)setSelectedMoreBth:(BOOL)selectedMoreBth {
    if (self->_graphicBtn) {
        self->_graphicBtn.isSelected = selectedMoreBth;
    }
}

@end
