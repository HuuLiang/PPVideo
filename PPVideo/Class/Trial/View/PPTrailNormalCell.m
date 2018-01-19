//
//  PPTrailNormalCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrailNormalCell.h"

@interface PPTrailNormalCell ()
{
    UIImageView     *_imgV;
    UIImageView     *_shadewImgV;
    UILabel         *_titleLabel;
    
    UIImageView     *_playImgV;
    UILabel         *_playLabel;
    
    UIImageView     *_commentImgV;
    UILabel         *_commentLabel;
    
    UIImageView     *_freeTagImgV;
}

@end

@implementation PPTrailNormalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        UIImage *shadowImg = [UIImage imageNamed:@"trail_normal_shadow"];
        _shadewImgV = [[UIImageView alloc] initWithImage:shadowImg];
        [self addSubview:_shadewImgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 22 : kWidth(28)];
        [_shadewImgV addSubview:_titleLabel];
        
        UIImage *playImg = [UIImage imageNamed:@"trail_normal_play"];
        _playImgV = [[UIImageView alloc] initWithImage:playImg];
        [self addSubview:_playImgV];
        
        _playLabel = [[UILabel alloc] init];
        _playLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _playLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [self addSubview:_playLabel];
        
        UIImage *commentImg = [UIImage imageNamed:@"trail_normal_comment"];
        _commentImgV = [[UIImageView alloc] initWithImage:commentImg];
        [self addSubview:_commentImgV];
        
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _commentLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [self addSubview:_commentLabel];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_equalTo(self.frame.size.width*9/7);
            }];
            
            [_shadewImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(self.frame.size.width * shadowImg.size.height / shadowImg.size.width);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_shadewImgV).offset(kWidth(10));
                make.right.equalTo(_shadewImgV.mas_right).offset(-kWidth(10));
                make.top.equalTo(_shadewImgV).offset(kWidth(4));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_shadewImgV).offset(kWidth(14));
                make.bottom.equalTo(_shadewImgV.mas_bottom).offset(-kWidth(8));
//                make.size.mas_equalTo(CGSizeMake(playImg.size.width, playImg.size.height));
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
            }];
            
            [_playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_playImgV);
                make.left.equalTo(_playImgV.mas_right).offset(kWidth(6));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_commentImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_playLabel);
                make.left.equalTo(_playLabel.mas_right).offset(kWidth(20));
//                make.size.mas_equalTo(CGSizeMake(commentImg.size.width, commentImg.size.height));
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(20)));
            }];
            
            [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_commentImgV);
                make.left.equalTo(_commentImgV.mas_right).offset(kWidth(6));
                make.height.mas_equalTo(kWidth(32));
            }];
            
        }
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setPlayCount:(NSInteger)playCount {
    _playLabel.text = [NSString stringWithFormat:@"%ld",playCount];
}

- (void)setCommentCount:(NSInteger)commentCount {
    _commentLabel.text = [NSString stringWithFormat:@"%ld",commentCount];
}

- (void)setIsVipCell:(BOOL)isVipCell {
    if (isVipCell) {
        UIImage *shadowImg = [UIImage imageNamed:@"trail_short_shadow"];
        _shadewImgV.image = shadowImg;
        [_shadewImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.frame.size.width * shadowImg.size.height / shadowImg.size.width);
        }];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shadewImgV).offset(kWidth(10));

        }];
        
        [_playImgV removeFromSuperview];
        [_playLabel removeFromSuperview];
        [_commentImgV removeFromSuperview];
        [_commentLabel removeFromSuperview];
    }
}

- (void)setIsFreeCell:(BOOL)isFreeCell {
    if (isFreeCell) {
        _freeTagImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trail_free_tag"]];
        [self addSubview:_freeTagImgV];
        [_freeTagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(102), kWidth(102)));
        }];
    }
}

@end
