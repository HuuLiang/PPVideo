//
//  PPVersionUpdateViewController.m
//  PPVideo
//
//  Created by Liang on 2016/12/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPVersionUpdateViewController.h"

@interface PPVersionUpdateViewController ()
{
    NSString *linkUrl;
}
@end

@implementation PPVersionUpdateViewController

- (instancetype)initWithLinkUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        linkUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#7ED321"];
    
    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"请更新最新版本";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:kWidth(72)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_titleLabel];
    
    UILabel *_descLabel = [[UILabel alloc] init];
    _descLabel.text = @"视频内容大幅增加，旧版关停，请下载更新";
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.numberOfLines = 0;
    _descLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    _descLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_descLabel];

    UIButton *_downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadBtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [_downloadBtn setTitle:@"下载最新版" forState:UIControlStateNormal];
    [_downloadBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(48)];
    _downloadBtn.layer.cornerRadius = 10;
    _downloadBtn.layer.masksToBounds = YES;
    [self.view addSubview:_downloadBtn];
    
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(200));
            make.height.mas_equalTo(kWidth(100));
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(40));
            make.height.mas_equalTo(kWidth(100));
        }];
        
        [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_descLabel.mas_bottom).offset(kWidth(100));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.6, kWidth(110)));
        }];
    }
    
    @weakify(self);
    [_downloadBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self->linkUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self->linkUrl]];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
