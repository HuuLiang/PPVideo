//
//  PPDetailMoreCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailMoreCell.h"
#import "PPGraphicButton.h"

@interface PPDetailMoreCell ()
{
    PPGraphicButton *_graphicBtn;
}
@end

@implementation PPDetailMoreCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        @weakify(self);
        _graphicBtn = [[PPGraphicButton alloc] initWithNormalTitle:@"成为会员查看更多"
                                                  selectedTitle:@"成为会员查看更多"
                                                    normalImage:[UIImage imageNamed:@"detail_more"]
                                                  selectedImage:[UIImage imageNamed:@"detail_more"]
                                                          space:kWidth(10)
                                                   isTitleFirst:YES
                                                    touchAction:^
                    {
                        @strongify(self);
                        if (self.moreAction) {
                            self.moreAction(self);
                        }
                        self->_graphicBtn.isSelected = !self->_graphicBtn.isSelected;
                    }];
        _graphicBtn.titleLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 26 : kWidth(28)];
        _graphicBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#B854B4"];
        
        [self addSubview:_graphicBtn];
        
        {
            [_graphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(300), kWidth(40)));
            }];
        }
        
    }
    return self;
}

@end
