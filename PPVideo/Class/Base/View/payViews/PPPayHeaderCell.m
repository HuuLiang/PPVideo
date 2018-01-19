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
        _title.text = @"获取观看完整视频资格";
        _subTitle.text = @"选取会员等级";
    } else if (vipLevel == PPVipLevelVipA) {
        _title.text = @"获取观看高清完整视频资格";
        _subTitle.text = @"升级会员等级";
    } else if (vipLevel == PPVipLevelVipB) {
        _title.text = @"获取观看超清AV视频资格";
        _subTitle.text = @"升级会员等级";
    }
}


@end
