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
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:_timeLabel];
        
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
        
        [self addSubview:_moreBtn];
        
        {
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(10));
                make.left.equalTo(self).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_timeLabel);
                make.right.equalTo(self.mas_right).offset(-kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
            }];
        }
        
    }
    return self;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = [NSString stringWithFormat:@"%@上传",[PPUtil UTF8DateStringFromString:timeStr]]; 
}

@end
