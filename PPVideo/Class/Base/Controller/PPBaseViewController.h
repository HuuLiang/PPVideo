//
//  PPBaseViewController.h
//  PPVideo
//
//  Created by Liang on 2016/10/15.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPBaseViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title;

//- (instancetype)initWithTitle:(NSString *)title vipLevel:(PPVipLevel)vipLevel;

- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(QBAction) action;
- (void)removeCurrentRefreshBtn;

- (void)pushDetailViewControllerWithColumnId:(NSInteger)columnId
                                RealColumnId:(NSInteger)RealColumnId
                                  columnType:(NSInteger)columnType
                             programLocation:(NSInteger)programLocation
                              andProgramInfo:(PPProgramModel *)programModel;

- (void)presentPayViewControllerWithBaseModel:(QBBaseModel *)baseModel;

- (void)playVideoWithUrl:(PPProgramModel *)programModel baseModel:(QBBaseModel *)baseModel vipLevel:(PPVipLevel)vipLevel hasTomeControl:(BOOL)hasTomeControl;

@end
