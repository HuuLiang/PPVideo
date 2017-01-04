//
//  PPSearchView.m
//  PPVideo
//
//  Created by Liang on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPSearchView.h"
#import "LeftSlideViewController.h"

@interface PPSearchView () <UITextFieldDelegate>
{
    UIButton    *_userButton;
    PPSearchBar *_searchBar;
    UIButton    *_cancleButton;
    NSString    *_placeholderStr;
}
@end

@implementation PPSearchView

+(instancetype)showView {
    static PPSearchView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PPSearchView alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _placeholderStr = @"波多野结衣最新力作";
        _bgColorAlpha = 0;
        _firstResponder = NO;
        
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userButton setBackgroundImage:[UIImage imageNamed:@"mine_avatar"] forState:UIControlStateNormal];
        [self addSubview:_userButton];
        
        _searchBar = [[PPSearchBar alloc] init];
        _searchBar.backgroundColor = [[UIColor colorWithHexString:@"#ebebeb"] colorWithAlphaComponent:0.3];
        _searchBar.delegate = self;
        _searchBar.font = [UIFont systemFontOfSize:13];
        _searchBar.placeholder = _placeholderStr;
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_search_normal"]];
        _searchBar.leftView = image;
        _searchBar.leftViewMode = UITextFieldViewModeAlways;
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:_searchBar];
        
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancleButton.hidden = YES;
        [self addSubview:_cancleButton];
        
        
        @weakify(self);
        [_userButton bk_addEventHandler:^(id sender) {
            LeftSlideViewController *rootVC = (LeftSlideViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC openLeftView];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_cancleButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self removeFromSuperview];
            [self->_searchBar resignFirstResponder];
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_userButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(10));
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(8));
                make.size.mas_equalTo(CGSizeMake(36, 36));
            }];
            
            [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-7);
                make.height.mas_equalTo(30);
                make.left.equalTo(self).offset(kWidth(45)+36);
                make.right.equalTo(self.mas_right).offset(-kWidth(120));
            }];
            
            [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-kWidth(12));
                make.centerY.equalTo(_searchBar);
                make.size.mas_equalTo(CGSizeMake(30, kWidth(28)));
            }];
        }

    }
    return self;
}

- (void)showInSuperView:(UIView *)view animated:(BOOL)animated {
    if (animated) {
        self.bgColorAlpha = _bgColorAlpha;
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_search_normal"]];
        _searchBar.leftView = image;
    } else {
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_search_selected"]];
        _searchBar.leftView = image;
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:_placeholderStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                                                                                           NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        _searchBar.attributedPlaceholder = attr;
        _searchBar.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    self.frame = CGRectMake(0, 0, kScreenWidth, 64);
    [view addSubview:self];
}

- (void)setBgColorAlpha:(CGFloat)bgColorAlpha {
    _bgColorAlpha = bgColorAlpha;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:bgColorAlpha];
    _searchBar.backgroundColor = [[UIColor colorWithHexString:@"#ebebeb"] colorWithAlphaComponent:(0.3+bgColorAlpha*0.7)];
}

- (void)hideFormSuperView {
    [self removeFromSuperview];
}

- (void)setFirstResponder:(BOOL)firstResponder {
    _firstResponder = firstResponder;
    
    
//    if (_firstResponder) {
//        [self->_searchBar becomeFirstResponder];
//    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_firstResponder) {
        return YES;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPopSearchNotificationName object:nil];
        _firstResponder = YES;
        return NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self->_cancleButton.hidden = NO;
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_search_selected"]];
    self->_searchBar.leftView = image;
    self->_searchBar.text = _placeholderStr;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _cancleButton.hidden = YES;
    _placeholderStr = textField.text;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:_placeholderStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    _searchBar.attributedPlaceholder = attr;
    textField.text = @"";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideSearchNotificationName object:nil];
}

@end


@implementation PPSearchBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = kWidth(6);
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x += 10;
    editingRect.origin.y += 2.5;
    return editingRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRect = [super textRectForBounds:bounds];
//    textRect.origin.x += 10;
    return textRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.placeholder
//                                                                              attributes:@{NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.54],
//                                                                                           NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//    self.attributedPlaceholder = attri;
    
    placeholderRect.origin.x += 10;
    placeholderRect.size.width -= 10;
    placeholderRect.origin.y += 2.5;
    return placeholderRect;
}

@end


