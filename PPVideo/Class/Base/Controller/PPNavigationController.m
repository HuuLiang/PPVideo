//
//  PPNavigationController.m
//  PPVideo
//
//  Created by Liang on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPNavigationController.h"
#import "PPBaseViewController.h"
#import "PPLiveViewController.h"

@interface PPNavigationController () <UINavigationControllerDelegate>

@end

@implementation PPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL alwaysHideNavigationBar = NO;
    if ([viewController isKindOfClass:[PPBaseViewController class]]) {
        alwaysHideNavigationBar = ((PPBaseViewController *)viewController).alwaysHideNavigationBar;
    }
    if (self.navigationBarHidden != alwaysHideNavigationBar) {
        [self setNavigationBarHidden:alwaysHideNavigationBar animated:animated];
    }
    
//    BOOL alwaysHideNavigationSearchView = ((PPBaseViewController *)viewController).alwaysHideNavigationSearchView;
//    [((PPBaseViewController *)viewController) setAlwaysHideNavigationSearchView:alwaysHideNavigationSearchView];
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//}



@end

