//
//  PPDetailFuncCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailFuncCell.h"

@interface PPDetailFuncCell ()
{
    UIImageView *_goodImgV;
    UILabel     *_goodLabel;
    
    UIImageView *_badImgV;
    UILabel     *_badLabel;
    
    UIButton    *_vipBtn;
}
@end

@implementation PPDetailFuncCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _goodImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_good"]];
        _goodImgV.userInteractionEnabled = YES;
        [self addSubview:_goodImgV];
        
        _goodLabel = [[UILabel alloc] init];
        _goodLabel.userInteractionEnabled = YES;
        _goodLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _goodLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 26: kWidth(28)];
        [self addSubview:_goodLabel];
        
        _badImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_bad"]];
        _badImgV.userInteractionEnabled = YES;
        [self addSubview:_badImgV];
        
        _badLabel = [[UILabel alloc] init];
        _badLabel.userInteractionEnabled = YES;
        _badLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _badLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 26: kWidth(28)];
        [self addSubview:_badLabel];
        
        @weakify(self);
        [_goodImgV bk_whenTapped:^{
            @strongify(self);
            if (self->_likeAction) {
                self->_likeAction(@(self->_isChanged));
            }
        }];
        
        [_goodLabel bk_whenTapped:^{
            @strongify(self);
            if (self->_likeAction) {
                self->_likeAction(@(self->_isChanged));
            }
        }];
        
        [_badImgV bk_whenTapped:^{
            @strongify(self);
            if (self->_hateAction) {
                self->_hateAction(@(self->_isChanged));
            }
        }];
        
        [_badLabel bk_whenTapped:^{
            @strongify(self);
            if (self->_hateAction) {
                self->_hateAction(@(self->_isChanged));
            }
        }];
        
        {
            [_goodImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(52));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
            
            [_goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_goodImgV.mas_right).offset(kWidth(14));
                make.height.mas_equalTo(kWidth(40));
            }];
        
            [_badImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_goodImgV.mas_right).offset(kWidth(116));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
            
            [_badLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_badImgV.mas_right).offset(kWidth(14));
                make.height.mas_equalTo(kWidth(40));
            }];
            
        }
        
        if ([PPUtil currentVipLevel] != PPVipLevelVipC) {
            _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_vipBtn setTitle:[PPUtil currentVipLevel] == PPVipLevelNone ? @"成为会员" : @"升级会员" forState:UIControlStateNormal];
            [_vipBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            _vipBtn.titleLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 26 : kWidth(28)];
            _vipBtn.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
            _vipBtn.layer.cornerRadius = kWidth(10);
            _vipBtn.layer.masksToBounds = YES;
            [self addSubview:_vipBtn];
            
            [_vipBtn bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self->_upAction) {
                    self->_upAction(self);
                }
                
            } forControlEvents:UIControlEventTouchUpInside];
            
            [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self.mas_right).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(300), kWidth(64)));
            }];
        }
    }
    return self;
}

- (void)setLikeCount:(NSInteger)likeCount {
    _likeCount = likeCount;
    _goodLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
}

- (void)setHateCount:(NSInteger)hateCount {
    _hateCount = hateCount;
    _badLabel.text = [NSString stringWithFormat:@"%ld",hateCount];
}

- (void)setIsChanged:(BOOL)isChanged {
    _isChanged = isChanged;
}

@end
