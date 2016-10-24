//
//  PPPayIntroCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPPayIntroCell.h"

@interface PPPayIntroCell ()
{
    UILabel *_title;
}
@end

@implementation PPPayIntroCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#666666"];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 2;
        _title.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 30 : kWidth(30)];
        [self.contentView addSubview:_title];
        
        {
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(68));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(68));
                make.top.equalTo(self.contentView);
//                make.bottom.equalTo(self.contentView);
            }];
        }
        
    }
    return self;
}

- (void)setAttStr:(NSAttributedString *)attStr {
    _title.attributedText = attStr;
}

@end
