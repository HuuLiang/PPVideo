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
        
        _vipLabel = [[UILabel alloc] init];
        _vipLabel.text = @"成为\nVIP";
        _vipLabel.numberOfLines = 2;
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _vipLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [_vipView addSubview:_vipLabel];
        
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
        }
        
    }
    return self;
}


@end
