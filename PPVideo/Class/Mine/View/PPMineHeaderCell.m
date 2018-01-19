//
//  PPMineHeaderCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineHeaderCell.h"

@interface PPMineHeaderCell ()
{
    UILabel *_vipLabel;
    UIView * _vipView;
    UILabel *_levelLabel;
}
@end

@implementation PPMineHeaderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#1F233E"];
        
        _vipView = [[UIView alloc] init];
        _vipView.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
        _vipView.layer.cornerRadius = kWidth(64);
        _vipView.layer.masksToBounds = YES;
        [self addSubview:_vipView];
        
        NSDictionary *vipDesc = @{@(PPVipLevelNone):@"成为\nVIP",
                                   @(PPVipLevelVipA):@"升级钻石",
                                   @(PPVipLevelVipB):@"升级黑金",
                                   @(PPVipLevelVipC):@"黑金会员"};
        
        _vipLabel = [[UILabel alloc] init];
        _vipLabel.text = vipDesc[@([PPUtil currentVipLevel])];
        _vipLabel.numberOfLines = 2;
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _vipLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [_vipView addSubview:_vipLabel];
        
        NSDictionary *vipLevel = @{@(PPVipLevelNone):@"游客",
                                   @(PPVipLevelVipA):@"黄金会员",
                                   @(PPVipLevelVipB):@"钻石会员",
                                   @(PPVipLevelVipC):@"黑金会员"};
        
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _levelLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.text = vipLevel[@([PPUtil currentVipLevel])];
        [self addSubview:_levelLabel];
        
        {
            [_vipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(124));
                make.size.mas_equalTo(CGSizeMake(kWidth(128), kWidth(128)));
            }];
            
            [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_vipView);
                make.size.mas_equalTo(CGSizeMake(kWidth(66), kWidth(88)));
            }];
            
            [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.height.mas_equalTo(kWidth(32));
                make.top.equalTo(_vipView.mas_bottom).offset(kWidth(10));
            }];
        }
    }
    return self;
}


@end
