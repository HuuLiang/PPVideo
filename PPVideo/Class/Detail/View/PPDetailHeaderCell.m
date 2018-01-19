//
//  PPDetailHeaderCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailHeaderCell.h"

@interface PPDetailHeaderCell ()
{
    UIImageView *_imgV;
    UIImageView *_playImgV;
    
    UIImageView *_startImgV;
    UIImageView *_slideImgV;
    
    UILabel     *_playLabel;
}

@end

@implementation PPDetailHeaderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        UIView *shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.15];
        [self addSubview:shadowView];
        
        _playImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play"]];
        [self addSubview:_playImgV];
        
        UIView *playView = [[UIView alloc] init];
        playView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.4];
        [self addSubview:playView];
        
        _startImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_start"]];
        [playView addSubview:_startImgV];
        
        _slideImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_slide"]];
        [playView addSubview:_slideImgV];
        
        _playLabel = [[UILabel alloc] init];
        _playLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _playLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad]? 20 : kWidth(22)];
        [playView addSubview:_playLabel];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(114), kWidth(114)));
            }];
            
            [playView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(kWidth(54));
            }];
            
            [_startImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(playView);
                make.left.equalTo(playView.mas_left).offset(kWidth(34));
                make.size.mas_equalTo(CGSizeMake(kWidth(20), kWidth(30)));
            }];
            
            [_slideImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(playView);
                make.left.equalTo(_startImgV.mas_right).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(474), kWidth(20)));
            }];
            
            [_playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(playView);
                make.left.equalTo(_slideImgV.mas_right).offset(kWidth(32));
                make.height.mas_equalTo(kWidth(32));
            }];
        }
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (void)setPlayCount:(NSString *)playCount {
    _playLabel.text = [NSString stringWithFormat:@"播放%@次",playCount];
}

@end
