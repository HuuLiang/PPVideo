//
//  PPVipIntroduceCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVipIntroduceCell.h"

@interface PPIntroduceView ()
{
    UIImageView *_imgV;
    UILabel *_label;
}
@end

@implementation PPIntroduceView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title
{
    self = [super init];
    if (self) {
        
        _imgV = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_imgV];
        
        _label = [[UILabel alloc] init];
        _label.text = title;
        _label.font = [UIFont systemFontOfSize:kWidth(28)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_label];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(26));
                make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(80)));
            }];
            
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(_imgV.mas_bottom).offset(kWidth(16));
                make.height.mas_equalTo(kWidth(40));
            }];
        }
        
    }
    return self;
}

@end




@interface PPVipIntroduceCell ()
{
    UILabel *_titleLabel;
}
@end

@implementation PPVipIntroduceCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"会员特权";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        [self addSubview:_titleLabel];
        
        PPIntroduceView *viewA = [[PPIntroduceView alloc] initWithImage:[UIImage imageNamed:@"mine_videos"] title:@"海量视频"];
        [self addSubview:viewA];
        
        PPIntroduceView *viewB = [[PPIntroduceView alloc] initWithImage:[UIImage imageNamed:@"mine_photos"] title:@"海量图库"];
        [self addSubview:viewB];
        
        PPIntroduceView *viewC = [[PPIntroduceView alloc] initWithImage:[UIImage imageNamed:@"mine_hds"] title:@"高清共享"];
        [self addSubview:viewC];
        
        PPIntroduceView *viewD = [[PPIntroduceView alloc] initWithImage:[UIImage imageNamed:@"mine_services"] title:@"美女客服"];
        [self addSubview:viewD];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(20));
                make.top.equalTo(self).offset(kWidth(16));
                make.height.mas_equalTo(kWidth(48));
            }];
            
            [viewA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, kScreenWidth/4));
            }];
            
            [viewB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.left.equalTo(viewA.mas_right);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, kScreenWidth/4));
            }];
            
            [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.left.equalTo(viewB.mas_right);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, kScreenWidth/4));
            }];
            
            [viewD mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, kScreenWidth/4));
            }];
        }
        
    }
    return self;
}

@end
