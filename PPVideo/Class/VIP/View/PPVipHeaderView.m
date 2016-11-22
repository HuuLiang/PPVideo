//
//  PPVipHeaderView.m
//  PPVideo
//
//  Created by Liang on 2016/10/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVipHeaderView.h"

@interface PPVipHeaderView ()
{
    UILabel *label;
}
@end

@implementation PPVipHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:kWidth(30)];
        label.textColor = [UIColor colorWithHexString:@"#FF00D0"];
        [self addSubview:label];
        
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.height.mas_equalTo(kWidth(30));
            }];
        }
    }
    return self;
}

- (void)setVipLevel:(PPVipLevel)vipLevel {
    if (vipLevel == PPVipLevelVipA) {
        label.text = @"   当前片库约1200部,仅限黄金会员观看";
    } else if (vipLevel == PPVipLevelVipB) {
        label.text = @"   当前片库约1500部,仅限钻石会员观看";
    } else if (vipLevel == PPVipLevelVipC) {
        label.text = @"   当前片库约1800部,尽显黑金会员观看";
    }
}


@end
