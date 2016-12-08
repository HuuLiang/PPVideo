//
//  PPTrailFreeAdCell.m
//  PPVideo
//
//  Created by Liang on 2016/11/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPTrailFreeAdCell.h"

@interface PPTrailFreeAdCell ()
{
    UIImageView     *_imgV;
    UILabel         *_titleLabel;
    
    UIImageView     *_playImgV;
    UILabel         *_playLabel;
    
    UIImageView     *_commentImgV;
    UILabel         *_commentLabel;
    
//    UIImageView     *_freeTagImgV;
}
@end

@implementation PPTrailFreeAdCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        
//        _freeTagImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trail_free_ad"]];
//        [self addSubview:_freeTagImgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            
//            [_freeTagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.equalTo(self);
//                make.size.mas_equalTo(CGSizeMake(kWidth(102), kWidth(102)));
//            }];
        }
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

@end
