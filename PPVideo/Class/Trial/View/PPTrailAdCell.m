//
//  PPTrailAdCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrailAdCell.h"

@interface PPTrailAdCell ()
{
    UIImageView *_adImgV;
}
@end

@implementation PPTrailAdCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _adImgV = [[UIImageView alloc] init];
        [self addSubview:_adImgV];
        
        {
            [_adImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setAdUrlStr:(NSString *)adUrlStr {
    [_adImgV sd_setImageWithURL:[NSURL URLWithString:adUrlStr]];
}

@end
