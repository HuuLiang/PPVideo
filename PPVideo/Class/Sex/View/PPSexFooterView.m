//
//  PPSexFooterView.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPSexFooterView.h"
#import "PPGraphicButton.h"

@interface PPSexFooterView ()
{
    UILabel *_timeLabel;
    PPGraphicButton *_moreBtn;
}
@end

@implementation PPSexFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:view];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [view addSubview:_timeLabel];

        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kWidth(60));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(10));
                make.left.equalTo(self).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(30));
            }];
        }
        
        if ([PPUtil currentVipLevel] == PPVipLevelNone || [PPUtil currentVipLevel] == PPVipLevelVipA) {
            @weakify(self);
            _moreBtn = [[PPGraphicButton alloc] initWithNormalTitle:@"更多"
                                                      selectedTitle:@"更多"
                                                        normalImage:[UIImage imageNamed:@"sex_more"]
                                                      selectedImage:[UIImage imageNamed:@"sex_more"]
                                                              space:kWidth(12)
                                                       isTitleFirst:YES
                                                        touchAction:^
                        {
                            @strongify(self);
                            if (self.moreAction) {
                                self.moreAction();
                            }
                            self->_moreBtn.isSelected = !self->_moreBtn.isSelected;
                        }];
            _moreBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
            _moreBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#B854B4"];
            
            [view addSubview:_moreBtn];
            
            {
                [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_timeLabel);
                    make.right.equalTo(self.mas_right).offset(-kWidth(20));
                    make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
                }];
            }
        }

        
    }
    return self;
}

- (void)setTime:(NSInteger)time {
    NSDate *currentDate = [NSDate date];
    NSDate *lastDate = [NSDate dateWithTimeInterval:-24*60*60*(time + 1) sinceDate:currentDate];
    _timeLabel.text = [NSString stringWithFormat:@"%@上传",[PPUtil UTF8DateStringFromString:lastDate]];
}

- (void)setHideBtn:(BOOL)hideBtn {
    _hideBtn = hideBtn;
    if (self->_moreBtn) {
        _moreBtn.hidden = hideBtn;
    }
}

@end
