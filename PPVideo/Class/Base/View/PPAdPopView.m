//
//  PPAdPopView.m
//  PPVideo
//
//  Created by Liang on 2016/11/29.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPAdPopView.h"

@interface PPAdPopView ()
{
    UIImageView *_codeImgV;
    UIImageView *_closeImgV;
    UIButton    *_saveButton;
}
@end

@implementation PPAdPopView

- (instancetype)initWithSuperView:(UIView *)superView
{
    self = [super init];
    if (self) {
        
        @weakify(self);

        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
        
        [superView addSubview:self];
        
        _closeImgV = [[UIImageView alloc] init];
        _closeImgV.image = [UIImage imageNamed:@"trail_close"];
        _closeImgV.userInteractionEnabled = YES;
        [self addSubview:_closeImgV];
        
        [_closeImgV bk_whenTapped:^{
            @strongify(self);
            self.hidden = YES;
        }];
        
        _codeImgV = [[UIImageView alloc] init];
        [self addSubview:_codeImgV];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"点击保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _saveButton.layer.cornerRadius = kWidth(10);
        _saveButton.layer.masksToBounds = YES;
        [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"#df1640"]];
        [self addSubview:_saveButton];
        
        [_saveButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            UIImageWriteToSavedPhotosAlbum(_codeImgV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superView);
        }];
        
        [_codeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kWidth(117));
            make.centerX.equalTo(self);
            make.width.mas_equalTo([PPUtil isIpad] ? kWidth(380) : kWidth(540));
            make.height.mas_equalTo(([PPUtil isIpad] ? kWidth(380) : kWidth(540)) *873/580);
        }];
        
        [_closeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_codeImgV.mas_top);
            make.right.equalTo(_codeImgV.mas_right);
            make.size.mas_equalTo(CGSizeMake(kWidth(51), kWidth(117)));
        }];
        
        [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_codeImgV.mas_bottom).offset(kWidth(38));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(358), kWidth(80)));
        }];
    }
    self.hidden = YES;
    return self;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error.userInfo != nil) {
        [[PPHudManager manager] showHudWithText:@"保存失败"];
    } else {
        [[PPHudManager manager] showHudWithText:@"保存成功"];
    }

    if (!self.isHidden) {
        self.hidden = YES;
    }
}

- (void)setCodeImgUrlStr:(NSString *)codeImgUrlStr {
    [_codeImgV sd_setImageWithURL:[NSURL URLWithString:codeImgUrlStr]];
}


@end
