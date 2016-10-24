//
//  PPNickNameCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPNickNameCell.h"

@interface PPNickNameCell ()
{
    UILabel *_titleLabel;
    UIButton *_sureBtn;
}
@end

@implementation PPNickNameCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        view.layer.borderColor = [UIColor colorWithHexString:@"#efefef"].CGColor;
        view.layer.borderWidth = 0.5f;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的昵称:";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 30 : kWidth(30)];
        [self addSubview:_titleLabel];
        
        _nameField = [[UITextField alloc] init];
        _nameField.backgroundColor = [UIColor clearColor];
        _nameField.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 34 : kWidth(34)];
        _nameField.textColor = [UIColor colorWithHexString:@"#000000"];
        _nameField.returnKeyType = UIReturnKeyDone;
//        _nameField.delegate = self;
//        _nameField.layer.borderColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3].CGColor;
//        _nameField.layer.borderWidth = 1;
//        _nameField.layer.masksToBounds = YES;
        [_nameField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:_nameField];
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 30 : kWidth(30)];
        _sureBtn.layer.cornerRadius = kWidth(5);
        _sureBtn.layer.borderColor = [[UIColor colorWithHexString:@"#222222"] colorWithAlphaComponent:0.5].CGColor;
        _sureBtn.layer.borderWidth = 1.f;
        _sureBtn.layer.masksToBounds = YES;
        [self addSubview:_sureBtn];
        
        @weakify(self);
        [_sureBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.nickAction) {
                self.nickAction(_nameField.text);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(20));
                make.right.equalTo(self.mas_right).offset(-kWidth(20));
                make.bottom.top.equalTo(self);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.top.bottom.equalTo(self);
                make.left.equalTo(self).offset(kWidth(20));
                make.width.mas_equalTo(kWidth(150));
            }];
            
            [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(170));
                make.right.equalTo(self.mas_right).offset(-kWidth(200));
                make.height.mas_equalTo(kWidth(50));
            }];
            
            [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self).offset(kWidth(5));
                make.right.equalTo(self.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(40)));
            }];
            
        }
        
    }
    return self;
}

- (void)setNickName:(NSString *)nickName {
    _nameField.placeholder = nickName;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CAShapeLayer *lineA = [CAShapeLayer layer];
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [lineA setFillColor:[[UIColor clearColor] CGColor]];
    [lineA setStrokeColor:[[[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4] CGColor]];
    lineA.lineWidth = 1.0f;
    CGPathMoveToPoint(linePathA, NULL, _nameField.frame.origin.x , _nameField.frame.origin.y+_nameField.frame.size.height);
    CGPathAddLineToPoint(linePathA, NULL, _nameField.frame.origin.x+_nameField.frame.size.width , _nameField.frame.origin.y+_nameField.frame.size.height);
    [lineA setPath:linePathA];
    CGPathRelease(linePathA);
    [self.layer addSublayer:lineA];
}

@end
