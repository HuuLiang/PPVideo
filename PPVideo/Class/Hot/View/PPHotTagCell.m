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
        
        self.layer.cornerRadius = kWidth(6);
        self.layer.masksToBounds = YES;
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _tagLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.layer.cornerRadius = kWidth(6);
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [self addSubview:_tagLabel];
                
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _tagLabel.text = titleStr;
    CGFloat width =  [titleStr sizeWithFont:[UIFont systemFontOfSize:kWidth(26)] maxSize:CGSizeMake(MAXFLOAT, kWidth(56))].width + kWidth(40);
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(width);
    }];
}

@end
