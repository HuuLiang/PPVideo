//
//  PPTrailHeaderView.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrailHeaderView.h"
#import "PPGraphicButton.h"

@interface PPTrailHeaderView ()
{
    PPGraphicButton *_graphicBtn;
}

@end

@implementation PPTrailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        _graphicBtn = [[PPGraphicButton alloc] initWithNormalTitle:@"查看更多"
                                                     selectedTitle:@"收起"
                                                       normalImage:[UIImage imageNamed:@"trail_free_more"]
                                                     selectedImage:[UIImage imageNamed:@"trail_free_less"]
                                                             space:kWidth(5)
                                                      isTitleFirst:YES
                                                       touchAction:^
        {
            @strongify(self);
            if (self.selected) {
                self.selected();
            }
            self->_graphicBtn.isSelected = !self->_graphicBtn.isSelected;
        }];
        _graphicBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        _graphicBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#B854B4"];
        
        [self addSubview:_graphicBtn];
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [self addSubview:grayView];
        
        {
            [_graphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.mas_top).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
            }];
            
            [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
        }
        
    }
    return self;
}

- (void)setSelectedMoreBtn:(BOOL)selectedMoreBtn {
    if (self->_graphicBtn) {
        self->_graphicBtn.isSelected = selectedMoreBtn;
    }
}

@end
