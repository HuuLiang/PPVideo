//
//  PPHudManager.h
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPHudManager : NSObject

@property (nonatomic,retain,readonly) UIView *hudView;

+(instancetype)manager;
-(void)showHudWithText:(NSString *)text;
-(void)showHudWithTitle:(NSString *)title message:(NSString *)msg;
-(void)showProgressInDuration:(NSTimeInterval)duration;

@end

