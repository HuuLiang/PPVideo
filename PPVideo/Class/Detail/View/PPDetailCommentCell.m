//
//  PPDetailCommentCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailCommentCell.h"

@interface PPDetailCommentCell ()
{
    UIImageView *_userImgV;
    UILabel *_userLabel;
    
    UIImageView *_timeImgV;
    UILabel *_timeLabel;
    
    UILabel *_commentLabel;
}
@end

@implementation PPDetailCommentCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = kWidth(34);
        _userImgV.layer.masksToBounds = YES;
        [self addSubview:_userImgV];
        
        _userLabel = [[UILabel alloc] init];
        _userLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _userLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 28 : kWidth(30)];
        [self addSubview:_userLabel];
        
        _timeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_time"]];
        [self addSubview:_timeImgV];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 20 : kWidth(22)];
        [self addSubview:_timeLabel];
        
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _commentLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 32 : kWidth(36)];
        _commentLabel.numberOfLines = 0;
        [self addSubview:_commentLabel];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(28));
                make.left.equalTo(self).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(68), kWidth(68)));
            }];
            
            [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userImgV);
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(15));
                make.height.mas_equalTo(kWidth(42));
            }];
            
            [_timeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userImgV);
                make.right.equalTo(self.mas_right).offset(-kWidth(80));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userImgV);
                make.left.equalTo(_timeImgV.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(24));
            }];
            
            [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(15));
                make.top.equalTo(_userLabel.mas_bottom).offset(kWidth(30));
                make.right.equalTo(self).offset(-kWidth(8));
            }];
        }
        
    }
    return self;
}

- (void)setUserImgUrlStr:(NSString *)userImgUrlStr {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgUrlStr] placeholderImage:[UIImage imageNamed:@"detail_user"]];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = [PPUtil compareCurrentTime:timeStr];
}

- (void)setUserNameStr:(NSString *)userNameStr {
    _userLabel.text = userNameStr;
}

-(void)setCommandAttriStr:(NSAttributedString *)commandAttriStr {
    _commentLabel.attributedText = commandAttriStr;
}


@end
