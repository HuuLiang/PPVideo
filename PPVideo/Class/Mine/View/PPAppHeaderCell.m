//
//  PPAppHeaderCell.m
//  PPVideo
//
//  Created by Liang on 2016/11/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPAppHeaderCell.h"

@interface PPAppHeaderCell ()
{
    UILabel *label;
}
@end

@implementation PPAppHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        label = [[UILabel alloc] init];
        label.text = @"精品应用";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:kWidth(32)];
        label.textColor = [UIColor colorWithHexString:@"#9012fe"];
        [self.contentView addSubview:label];
        
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(35));
            }];
        }
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat originalY = label.frame.origin.y + label.frame.size.height / 2;
    
    
    CAShapeLayer *lineA = [CAShapeLayer layer];
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [lineA setFillColor:[[UIColor clearColor] CGColor]];
    [lineA setStrokeColor:[[[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4] CGColor]];
    lineA.lineWidth = 2.0f;
    CGPathMoveToPoint(linePathA, NULL, 40 , originalY);
    CGPathAddLineToPoint(linePathA, NULL, label.frame.origin.x - 20 , originalY);
    [lineA setPath:linePathA];
    CGPathRelease(linePathA);
    [self.layer addSublayer:lineA];
    
    CAShapeLayer *lineB = [CAShapeLayer layer];
    CGMutablePathRef linePathB = CGPathCreateMutable();
    [lineB setFillColor:[[UIColor clearColor] CGColor]];
    [lineB setStrokeColor:[[[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4] CGColor]];
    lineB.lineWidth = 2.0f;
    CGPathMoveToPoint(linePathB, NULL,  label.frame.origin.x + label.frame.size.width + 20, originalY);
    CGPathAddLineToPoint(linePathB, NULL, self.frame.size.width - 40 , originalY);
    [lineB setPath:linePathB];
    CGPathRelease(linePathB);
    [self.layer addSublayer:lineB];
    
}

@end
