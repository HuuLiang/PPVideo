//
//  PPMineAppCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineAppCell.h"

@interface PPMineAppCell ()
{
    UIImageView *_bgImgv;
    UILabel *_title;
    
    UIView *_isInstallView;
    UILabel *_isInstallLabel;
}

@end

@implementation PPMineAppCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = kWidth(5);
        self.layer.masksToBounds = YES;
        
        _bgImgv = [[UIImageView alloc] init];
        _bgImgv.backgroundColor = [UIColor clearColor];
//        _bgImgv.layer.cornerRadius = kWidth(30);
//        _bgImgv.layer.masksToBounds = YES;
        [self addSubview:_bgImgv];
        
//        _title = [[UILabel alloc] init];
//        _title.textAlignment = NSTextAlignmentCenter;
//        _title.font = [UIFont systemFontOfSize:kWidth(34)];
//        _title.textColor = [UIColor colorWithHexString:@"#333333"];
//        [self addSubview:_title];
        
        _isInstallView = [[UIView alloc] init];
        _isInstallView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.7];
        _isInstallView.layer.cornerRadius = kWidth(30);
        _isInstallView.layer.masksToBounds = YES;
        [self addSubview:_isInstallView];
        
        _isInstallLabel = [[UILabel alloc] init];
        _isInstallLabel.textAlignment = NSTextAlignmentCenter;
        _isInstallLabel.text = @"已安装";
        _isInstallLabel.backgroundColor = [UIColor clearColor];
        _isInstallLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _isInstallLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [_isInstallView addSubview:_isInstallLabel];
        
        {
            [_bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self);
//                make.height.mas_equalTo(self.frame.size.width);
            }];
            
//            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_bgImgv.mas_bottom).offset(kWidth(5));
//                make.bottom.left.right.equalTo(self);
//            }];
            
            [_isInstallView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self);
//                make.height.mas_equalTo(self.frame.size.width);
            }];
            
            [_isInstallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_isInstallView.center);
                make.height.mas_equalTo(kWidth(40));
            }];
        }
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _title.text = titleStr;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setIsInstall:(BOOL)isInstall {
    _isInstallView.hidden = !isInstall;
}

@end
