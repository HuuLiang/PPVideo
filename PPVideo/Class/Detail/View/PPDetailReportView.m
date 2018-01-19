//
//  PPDetailReportView.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailReportView.h"

@interface PPDetailReportView () <UITextFieldDelegate>
{
    UIView *_view;
}
@end

@implementation PPDetailReportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#21243F"];
        
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor clearColor];
        _view.layer.cornerRadius = kWidth(8);
        _view.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.57].CGColor;
        _view.layer.borderWidth = 1;
        _view.layer.masksToBounds = YES;
        [self addSubview:_view];
        
        UIImageView *_imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_comment"]];
        [_view addSubview:_imgV];
        
        
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
        _textField.placeholder = @"期待你的神评";
        _textField.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 30 : kWidth(30)];
        [_textField setValue:[[UIColor whiteColor] colorWithAlphaComponent:0.57] forKeyPath:@"_placeholderLabel.textColor"];
        [_view addSubview:_textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardActionHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        {
            [_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(kWidth(14), kWidth(40), kWidth(14), kWidth(40)));
            }];
            
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_view);
                make.left.equalTo(_view.mas_left).offset(kWidth(12));
                if ([PPUtil isIpad]) {
                    make.size.mas_equalTo(CGSizeMake(30, 34));
                } else {
                    make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(34)));
                }
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(20));
                make.centerY.equalTo(_view);
                make.right.equalTo(_view.mas_right).offset(-kWidth(20));
                make.height.mas_equalTo(kWidth(50));
            }];
        }
        
    }
    return self;
}

- (void)handleKeyBoardActionHide:(NSNotification *)notification {
    self.frame = CGRectMake(0, kScreenHeight - 64 - kWidth(88), self.frame.size.width, kWidth(88));
}

- (void)handleKeyBoardChangeFrame:(NSNotification *)notification {
    
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(endFrame));
    
    self.frame = CGRectMake(0, endFrame.origin.y - kWidth(88) - 64, self.frame.size.width, kWidth(88));
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    @weakify(self);
    if (self.endEditing) {
        @strongify(self)
        self.endEditing(self.textField.text);
    }
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [_textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//     [_textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//}

@end
