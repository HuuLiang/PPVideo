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
}

@end

@implementation PPHotContentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
        

        
    }
    
    UIImageView *_lineLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_line_left"]];
    [self addSubview:_lineLeft];
    
    UIImageView *_lineRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_line_right"]];
    [self addSubview:_lineRight];
    
    {
        [_graphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(166), kWidth(42)));
        }];
        
        [_lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kWidth(20));
            make.right.equalTo(_graphicBtn.mas_left).offset(-kWidth(20));
            make.height.mas_equalTo(kWidth(4));
        }];
        
        [_lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_graphicBtn.mas_right).offset(kWidth(20));
            make.right.equalTo(self.mas_right).offset(-kWidth(20));
            make.height.mas_equalTo(kWidth(4));
        }];
        
    }
    
    
    return self;
}

@end
