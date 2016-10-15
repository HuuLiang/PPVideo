//
//  PPMineViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineViewController.h"

@interface PPMineViewController ()

@end

@implementation PPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [self.view bk_whenTapped:^{
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
