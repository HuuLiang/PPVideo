//
//  PPPayTypeCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPPayTypeCell.h"

@interface PPPayTypeCell ()
{
    UIButton *_payButton;
}
@end

@implementation PPPayTypeCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 36 : kWidth(36)];
        _payButton.layer.cornerRadius = [PPUtil isIpad] ? 10 : kWidth(10);
        _payButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_payButton];
        
        {
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(480), kWidth(98)));
            }];
        }
        
        @weakify(self);
        [_payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setOrderPayType:(QBOrderPayType)orderPayType {
    if (orderPayType == QBOrderPayTypeWeChatPay) {
        [_payButton setTitle:@"微信支付" forState:UIControlStateNormal];
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#72BC22"];
    } else if (orderPayType == QBOrderPayTypeAlipay) {
        [_payButton setTitle:@"支付宝支付" forState:UIControlStateNormal];
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#4A90E2"];
    }
}


@end
