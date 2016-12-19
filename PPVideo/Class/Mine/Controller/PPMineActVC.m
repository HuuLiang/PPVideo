//
//  PPMineActVC.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineActVC.h"
#import "PPAutoActManager.h"
#import <QBPaymentManager.h>

#define forthCelHeight kWidth(688)

@interface PPMineActVC () <UITextFieldDelegate>
{
    UIButton *_autoBtn;
    
    UITextField *_textField;
    UIButton *_nonAutoBtn;
    
}

@end

@implementation PPMineActVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"自助激活";
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
//    @weakify(self);
//    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
//        @strongify(self);
//        
//    };
    
    [self initCells];
    
        [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
            NSString *baseURLString = [PP_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, PP_BASE_URL.length-6) withString:@"******"];
            [[PPHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@/%@\nBundleId:%@\nVersion:%@", baseURLString, PP_CHANNEL_NO, PP_PACKAGE_CERTIFICATE, PP_REST_PV, PP_PAYMENT_PV,PP_BUNDLE_IDENTIFIER,PP_REST_APP_VERSION]];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initAutoActTitleInSection:section++];
    [self initAutoFuncButtonInSection:section++];
    
    [self initNonAutoActTitleInSection:section++];
    [self initNonAutoFuncButtonInSection:section++];
    
    [self.layoutTableView reloadData];
}

- (void)initAutoActTitleInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel *aotuLabel = [[UILabel alloc] init];
    aotuLabel.text = @"方法一：付费未激活的用户点击自助激活";
    aotuLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    aotuLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    aotuLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:aotuLabel];
    
    {
        [aotuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView.mas_top).offset(kWidth(60));
            make.height.mas_equalTo(kWidth(44));
        }];
    }
    [self setLayoutCell:cell cellHeight:kWidth(150) inRow:0 andSection:section];
}

- (void)initAutoFuncButtonInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    _autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_autoBtn setTitle:@"点击激活" forState:UIControlStateNormal];
    [_autoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _autoBtn.backgroundColor = [UIColor colorWithHexString:@"#4A90E2"];
    _autoBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
    _autoBtn.layer.cornerRadius = kWidth(10);
    _autoBtn.layer.masksToBounds = YES;
    [cell.contentView addSubview:_autoBtn];
    
    [_autoBtn bk_addEventHandler:^(id sender) {
        [[PPAutoActManager sharedManager] doActivation];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_autoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(kWidth(542), kWidth(88)));
        }];
    }
    [self setLayoutCell:cell cellHeight:kWidth(220) inRow:0 andSection:section];
}

- (void)initNonAutoActTitleInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel *aotuLabel = [[UILabel alloc] init];
    aotuLabel.text = @"方法二：输入支付订单号自助激活";
    aotuLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    aotuLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    aotuLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:aotuLabel];
    
    {
        [aotuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView);
            make.height.mas_equalTo(kWidth(44));
        }];
    }
    [self setLayoutCell:cell cellHeight:kWidth(82) inRow:0 andSection:section];
}

- (void)initNonAutoFuncButtonInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    _textField.font = [UIFont systemFontOfSize:kWidth(34)];
    _textField.textColor = [UIColor colorWithHexString:@"#000000"];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.placeholder = @"  请输入正确的订单号";
    _textField.layer.borderColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.layer.masksToBounds = YES;
    [_textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.contentView addSubview:_textField];
    
    _nonAutoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nonAutoBtn setTitle:@"提交激活" forState:UIControlStateNormal];
    [_nonAutoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _nonAutoBtn.backgroundColor = [UIColor colorWithHexString:@"#FF680D"];
    _nonAutoBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
    _nonAutoBtn.layer.cornerRadius = kWidth(10);
    _nonAutoBtn.layer.masksToBounds = YES;
    [cell.contentView addSubview:_nonAutoBtn];
    
    [_nonAutoBtn bk_addEventHandler:^(id sender) {
        if ([_textField.text isEqualToString:@"PayConfig"]) {
            [PPUtil setDefaultPaymentConfig];
            [QBNetworkingConfiguration defaultConfiguration].useStaticBaseUrl = YES;
            [[QBPaymentManager sharedManager] refreshAvailablePaymentTypesWithCompletionHandler:nil];
            [[PPHudManager manager] showHudWithText:@"启动默认支付接口"];
            return ;
        } else if ([_textField.text isEqualToString:@"ContentConfig"]) {
            [QBNetworkingConfiguration defaultConfiguration].useStaticBaseUrl = YES;
            [[PPHudManager manager] showHudWithText:@"启动静态文件接口"];
            return ;
        }
        [[PPAutoActManager sharedManager] servicesActivationWithOrderId:_textField.text];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(kWidth(560), kWidth(88)));
        }];
        
        [_nonAutoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(kWidth(542), kWidth(88)));
        }];
    }
    
    [self setLayoutCell:cell cellHeight:kWidth(236) inRow:0 andSection:section];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardActionHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)handleKeyBoardActionHide:(NSNotification *)notification {
    [self.layoutTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)handleKeyBoardChangeFrame:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offsetY = forthCelHeight - endFrame.origin.y + 64;
    [self.layoutTableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.layoutTableView.scrollEnabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.layoutTableView.scrollEnabled = YES;
}

- (void)textFieldWillEndEditing:(UITextField *)textField {
    [_textField resignFirstResponder];
}

@end
