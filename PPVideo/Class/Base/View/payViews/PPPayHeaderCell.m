//
//  PPPayHeaderCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPPayHeaderCell.h"

@interface PPPayHeaderCell ()
{
    UILabel *_title;
    UILabel *_subTitle;
}
@end

@implementation PPPayHeaderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _title.font = [UIFont boldSystemFontOfSize:[PPUtil isIpad] ? 38 : kWidth(38)];
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _subTitle.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 32 : kWidth(32)];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subTitle];
        
        {
            [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset([PPUtil isIpad] ? -kWidth(40) : -kWidth(80));
                make.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(44));
            }];
            
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_subTitle.mas_top).offset(-kWidth(20));
                make.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(52));
            }];
        }
    }
    return self;
}

- (void)setVipLevel:(PPVipLevel)vipLevel {
    if (vipLevel == PPVipLevelNone) {
        _title.text = @"成为会员观看完整内容";
        _subTitle.text = @"选择开通的等级";
    } else if (vipLevel == PPVipLevelVipA) {
        _title.text = @"升级观看高清完整视频";
        _subTitle.text = @"提高会员等级";
    } else if (vipLevel == PPVipLevelVipB) {
        _title.text = @"升级观看超清AV视频";
        _subTitle.text = @"提高会员等级";
    }
}


@end
