//
//  PPHotTagCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPHotTagCell.h"

@interface PPHotTagCell ()
{
    UILabel *_tagLabel;
}
@end

@implementation PPHotTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = kWidth(8);
        self.layer.masksToBounds = YES;
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _tagLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.backgroundColor = [[UIColor colorWithHexString:@"#B854B4"] colorWithAlphaComponent:0.78];
        [self addSubview:_tagLabel];
        
        @weakify(self);
        [_tagLabel bk_whenTapped:^{
            @strongify(self);
            if (self.tagAction) {
                self.tagAction();
            }
        }];
        
        {
            [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _tagLabel.text = titleStr;
}

@end
