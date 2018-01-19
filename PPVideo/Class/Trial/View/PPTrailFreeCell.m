//
//  PPTrailFreeCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrailFreeCell.h"

@interface PPTrailFreeCell ()
{
    UIImageView     *_imgV;
    UILabel         *_titleLabel;
    
    UIImageView     *_playImgV;
    UILabel         *_playLabel;
    
    UIImageView     *_commentImgV;
    UILabel         *_commentLabel;
    
    UIImageView     *_freeTagImgV;
}
@end

@implementation PPTrailFreeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 24 : kWidth(32)];
        [self addSubview:_titleLabel];
        
        UIImage *playImg = [UIImage imageNamed:@"trail_free_play"];
        _playImgV = [[UIImageView alloc] initWithImage:playImg];
        [self addSubview:_playImgV];
        
        _playLabel = [[UILabel alloc] init];
        _playLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _playLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [self addSubview:_playLabel];
        
        UIImage *commentImg = [UIImage imageNamed:@"trail_free_comment"];
        _commentImgV = [[UIImageView alloc] initWithImage:commentImg];
        [self addSubview:_commentImgV];
        
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _commentLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [self addSubview:_commentLabel];
        
        _freeTagImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trail_free_tag"]];
        [self addSubview:_freeTagImgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_equalTo(self.frame.size.width*0.6);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(10));
                make.right.equalTo(self.mas_right).offset(-kWidth(10));
                make.top.equalTo(_imgV.mas_bottom).offset(kWidth(5));
                make.height.mas_equalTo(kWidth(44));
            }];
            
            [_playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(14));
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(10));
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
            
            [_freeTagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(102), kWidth(102)));
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


@end
