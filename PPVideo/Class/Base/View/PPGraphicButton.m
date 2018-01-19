//
//  PPGraphicButton.m
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPGraphicButton.h"

@interface PPGraphicButton ()
{
    BOOL _titleFirst;
    CGFloat _space;
    
    UIImage *_normalImage;
    UIImage *_selectedImage;
    NSString *_normalTitle;
    NSString *_selectedTitle;
}

@end

@implementation PPGraphicButton

- (instancetype)initWithNormalTitle:(NSString *)normalTitle
                      selectedTitle:(NSString *)selectedTitle
                        normalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage
                              space:(CGFloat)space
                       isTitleFirst:(BOOL)isTitleFirst
                        touchAction:(touchAction)action
{
    if (self = [super init]) {
        
        _isSelected = NO;
        _titleFirst = isTitleFirst;
        _space = space;
        
        if (normalImage) {
            _normalImage = normalImage;
        }
        if (selectedImage) {
            _selectedImage = selectedImage;
        }
        if (normalTitle) {
            _normalTitle = normalTitle;
        }
        if (selectedTitle) {
            _selectedTitle = selectedTitle;
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _isSelected ? _selectedTitle : _normalTitle;
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        
        _imageV = [[UIImageView alloc] initWithImage:_isSelected? _selectedImage: _normalImage];
        [self addSubview:_imageV];
        
        CGSize imageSize = (_isSelected ? _selectedImage : _normalImage).size;
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(self);
            make.centerX.equalTo(self.mas_centerX).offset((_titleFirst? -1 : 1)  *  (_space + imageSize.width * 2 )/2 + (_titleFirst? 1 : -1)* kWidth(7.5));
        }];
        
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWidth(imageSize.width * 2), kWidth(imageSize.height * 2)));
            make.centerY.equalTo(self);
            if (_titleFirst) {
                make.left.equalTo(_titleLabel.mas_right).offset(_space);
            } else {
                make.right.equalTo(_titleLabel.mas_left).offset(-_space);
            }
        }];
        
        
        [self bk_whenTapped:^{
            action();
        }];
        
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _titleLabel.text = _isSelected ? _selectedTitle : _normalTitle;
    _imageV.image = _isSelected? _selectedImage: _normalImage;
    
    CGSize imageSize = (_isSelected ? _selectedImage : _normalImage).size;
    
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self);
        make.centerX.equalTo(self.mas_centerX).offset((_titleFirst? -1 : 1)  *  (_space + imageSize.width * 2 )/2 + (_titleFirst? 1 : -1)* kWidth(7.5));
    }];
    
    [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(imageSize.width * 2), kWidth(imageSize.height * 2)));
        make.centerY.equalTo(self);
        if (_titleFirst) {
            make.left.equalTo(_titleLabel.mas_right).offset(_space);
        } else {
            make.right.equalTo(_titleLabel.mas_left).offset(-_space);
        }
    }];
}


@end
