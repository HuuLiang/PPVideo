//
//  PPMineVipHeaderCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineVipHeaderCell.h"


@interface PPMineVipHeaderCell ()
{
    UIImageView *_backImgV;
    UIImageView *_userImgV;
    
    UILabel     *_accountLabel;
    UILabel     *_passwordLabel;
    
    UILabel     *_vipLevelLabel;
    UILabel     *_vipRightsLabel;
}
@end

@implementation PPMineVipHeaderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        
        NSDictionary *vipLevels = @{@(PPVipLevelNone):@"游客",
                                    @(PPVipLevelVipA):@"黄金会员",
                                    @(PPVipLevelVipB):@"钻石会员",
                                    @(PPVipLevelVipC):@"黑金会员"};
        
        NSDictionary *vipRights = @{@(PPVipLevelNone):@"观看体验区电影",
                                    @(PPVipLevelVipA):@"观看黄金区电影",
                                    @(PPVipLevelVipB):@"观看钻石区电影",
                                    @(PPVipLevelVipC):@"观看黑钻区电影"};
        
        
        _backImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_back.jpg"]];
        [self addSubview:_backImgV];
        
        _userImgV = [[UIImageView alloc] initWithImage:[PPUtil getUserImage] ? [PPUtil getUserImage] : [UIImage imageNamed:@"mine_user"]];
        _userImgV.layer.cornerRadius = kWidth(70);
        _userImgV.layer.masksToBounds = YES;
        _userImgV.userInteractionEnabled = YES;
        @weakify(self);
        [_userImgV bk_whenTapped:^{
            @strongify(self);
            if (self.uploadImg) {
                self.uploadImg(self);
            }
        }];
        [self addSubview:_userImgV];
        
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = @"您的专属账号：54935925";
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        _accountLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _accountLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:_accountLabel];
        
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"密码：14276798";
        _passwordLabel.textAlignment = NSTextAlignmentCenter;
        _passwordLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _passwordLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:_passwordLabel];
        
        _vipLevelLabel = [[UILabel alloc] init];
        _vipLevelLabel.text = vipLevels[@([PPUtil currentVipLevel])];
        _vipLevelLabel.textAlignment = NSTextAlignmentCenter;
        _vipLevelLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _vipLevelLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:_vipLevelLabel];
        
        _vipRightsLabel = [[UILabel alloc] init];
        _vipRightsLabel.text = vipRights[@([PPUtil currentVipLevel])];
        _vipRightsLabel.textAlignment = NSTextAlignmentCenter;
        _vipRightsLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _vipRightsLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:_vipRightsLabel];
        
        {
            [_backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(44));
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
            }];
            
            [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(_userImgV.mas_bottom).offset(kWidth(22));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(_accountLabel.mas_bottom).offset(kWidth(2));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_vipLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self.mas_centerX);
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(24));
                make.height.mas_equalTo(kWidth(42));
            }];
            
            [_vipRightsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(24));
                make.height.mas_equalTo(kWidth(42));
            }];
        }
    }
    return self;
}

- (void)setBgImgUrl:(NSString *)bgImgUrl {
    [_backImgV sd_setImageWithURL:[NSURL URLWithString:bgImgUrl]];
}

- (void)setUserImg:(UIImage *)userImg {
    _userImgV.image = userImg;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CAShapeLayer *lineA = [CAShapeLayer layer];
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [lineA setFillColor:[[UIColor clearColor] CGColor]];
    [lineA setStrokeColor:[[[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.4] CGColor]];
    lineA.lineWidth = 1.0f;
    CGPathMoveToPoint(linePathA, NULL, self.frame.size.width/2 , self.frame.size.height - kWidth(66));
    CGPathAddLineToPoint(linePathA, NULL, self.frame.size.width/2 , self.frame.size.height - kWidth(24));
    [lineA setPath:linePathA];
    CGPathRelease(linePathA);
    [self.layer addSublayer:lineA];
}

@end
