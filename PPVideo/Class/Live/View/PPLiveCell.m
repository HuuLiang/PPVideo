//
//  PPLiveCell.m
//  PPVideo
//
//  Created by Liang on 2017/1/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPLiveCell.h"


@interface PPLiveCell ()
{
    UIImageView *_userImgV;
    UILabel     *_nickNameLabel;
    UILabel     *_hotLabel;
    UIButton    *_liveButton;
}
@end

@implementation PPLiveCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_userImgV];
        
        _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveButton setTitle:@"Live" forState:UIControlStateNormal];
        [_liveButton setImage:[UIImage imageNamed:@"live_redPoint"] forState:UIControlStateNormal];
        _liveButton.layer.cornerRadius = kWidth(13);
        _liveButton.layer.masksToBounds = YES;
        _liveButton.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [self.contentView addSubview:_liveButton];
        
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self.contentView addSubview:_nickNameLabel];
        
        _hotLabel = [[UILabel alloc] init];
        _hotLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.56];
        _hotLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [self.contentView addSubview:_hotLabel];
        
        [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(frame.size.width);
        }];
        
        [_liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kWidth(10));
            make.right.equalTo(self.contentView.mas_right).offset(-kWidth(12));
            make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(32)));
        }];
        
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userImgV.mas_bottom).offset(kWidth(6));
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(kWidth(28));
        }];
        
        [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nickNameLabel.mas_bottom).offset(kWidth(10));
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(kWidth(22));
        }];
        
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setHotCount:(NSString *)hotCount {
    _hotLabel.text = [NSString stringWithFormat:@"人气值:%@",hotCount];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIEdgeInsets imageInsets = _liveButton.imageEdgeInsets;
    _liveButton.imageEdgeInsets = UIEdgeInsetsMake(imageInsets.top,imageInsets.left-kWidth(8),imageInsets.bottom,imageInsets.right+kWidth(8));
    UIEdgeInsets titleInsets = _liveButton.titleEdgeInsets;
    _liveButton.titleEdgeInsets = UIEdgeInsetsMake(titleInsets.top,titleInsets.left+kWidth(8),titleInsets.bottom,titleInsets.right-kWidth(8));
}

@end
