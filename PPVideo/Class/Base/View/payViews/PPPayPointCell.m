//
//  PPPayPointCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPPayPointCell.h"
#import "PPSystemConfigModel.h"

@interface PPPayPointCell ()
{
    UIView *_frameView;
    UILabel *_title;
    UILabel *_subTitle;
    UILabel *_moneyLabel;
    UIImageView *_seletedImgV;
}
@end

@implementation PPPayPointCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _frameView = [[UIView alloc] init];
        _frameView.layer.cornerRadius = [PPUtil isIpad] ? 10 : kWidth(10);
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#B854B4"].CGColor;
        _frameView.layer.borderWidth = 2.f;
        _frameView.layer.masksToBounds = YES;
        [self.contentView addSubview:_frameView];
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _title.font = [UIFont boldSystemFontOfSize:[PPUtil isIpad] ? 38 : kWidth(38)];
        _title.textAlignment = NSTextAlignmentCenter;
        [_frameView addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _subTitle.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 28 : kWidth(28)];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        [_frameView addSubview:_subTitle];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
        _moneyLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 36 : kWidth(36)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [_frameView addSubview:_moneyLabel];
        
        _seletedImgV = [[UIImageView alloc] init];
        [_frameView addSubview:_seletedImgV];
        
        {
            [_frameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kWidth(40), 0, kWidth(40)));
            }];
            
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_frameView).offset(kWidth(20));
                make.top.equalTo(_frameView).offset(kWidth(16));
                make.height.mas_equalTo(kWidth(52));
            }];
            
            [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_frameView).offset(kWidth(20));
                make.bottom.equalTo(_frameView.mas_bottom).offset(-kWidth(16));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_frameView);
                make.right.equalTo(_frameView.mas_right).offset(-kWidth(106));
                make.height.mas_equalTo(kWidth(50));
            }];
            
            [_seletedImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_frameView);
                make.right.equalTo(_frameView.mas_right).offset(-kWidth(46));
                make.size.mas_equalTo(CGSizeMake(kWidth(36), kWidth(36)));
            }];
        }
        
    }
    return self;
}

- (void)setVipLevel:(PPVipLevel)vipLevel {
    _vipLevel = vipLevel;
    if (vipLevel == PPVipLevelVipA) {
        _title.text = @"黄金会员";
        _subTitle.text = @"可观看上百部完整版爽片";
        _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[PPSystemConfigModel sharedModel].payAmount/100];
    } else if (vipLevel == PPVipLevelVipB) {
        _title.text = [PPUtil currentVipLevel] == PPVipLevelVipA ? @"升级为钻石会员" : @"钻石会员";
        _subTitle.text = @"上千部高清限制级精彩视频";
        if ([PPUtil currentVipLevel] == PPVipLevelNone) {
            _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[PPSystemConfigModel sharedModel].payzsAmount/100+[PPSystemConfigModel sharedModel].payAmount/100];
        } else {
            _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[PPSystemConfigModel sharedModel].payzsAmount/100];
        }
    } else if (vipLevel == PPVipLevelVipC) {
        _title.text = @"升级为黑金会员";
        _subTitle.text = @"享日本最新超清AV大片";
        _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[PPSystemConfigModel sharedModel].payhjAmount/100];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (_isSelected) {
        _title.textColor = [UIColor colorWithHexString:@"#B854B4"];
        _subTitle.textColor = [UIColor colorWithHexString:@"#B854B4"];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
        _seletedImgV.image = [UIImage imageNamed:@"pay_selected"];
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#B854B4"].CGColor;
    } else {
        _title.textColor = [UIColor colorWithHexString:@"#999999"];
        _subTitle.textColor = [UIColor colorWithHexString:@"#999999"];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _seletedImgV.image = [UIImage imageNamed:@"pay_normal"];
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    }
}
@end
