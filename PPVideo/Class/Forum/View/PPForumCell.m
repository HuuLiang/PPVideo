//
//  PPForumCell.m
//  PPVideo
//
//  Created by Liang on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPForumCell.h"

@interface PPForumCell ()
{
    UIImageView *_imgV;
    UILabel     *_titleLabel;
    UILabel     *_themeLabel;
    UILabel     *_latestLabel;
}
@end

@implementation PPForumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:kWidth(26)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_titleLabel];
        
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        _themeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:_themeLabel];
        
        _latestLabel = [[UILabel alloc] init];
        _latestLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        _latestLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:_latestLabel];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(168), kWidth(130)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(8));
                make.top.equalTo(_imgV.mas_top).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(8));
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(16));
                make.height.mas_equalTo(kWidth(22));
            }];
            
            [_latestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(8));
                make.top.equalTo(_themeLabel.mas_bottom).offset(kWidth(12));
                make.height.mas_equalTo(kWidth(22));
            }];
        }
        
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setTheme:(NSString *)theme {
    _themeLabel.text = [NSString stringWithFormat:@"主题:%@",theme];
}

- (void)setLatest:(NSString *)latest {
    NSUInteger randomTime = arc4random() % 300 + 1;
    NSString *timeStr;
    if ((long)(randomTime / 60) > 0) {
        timeStr = [NSString stringWithFormat:@"%ld分钟前",(long)(randomTime/60)];
    } else {
        timeStr = [NSString stringWithFormat:@"%ld秒前",randomTime];
    }
    
    _latestLabel.text = [NSString stringWithFormat:@"最后发表:%@",timeStr];
}


@end
