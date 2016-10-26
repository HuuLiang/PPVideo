//
//  PPHotContentHeaderView.h
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isSelected)(void);

@interface PPHotContentHeaderView : UICollectionReusableView

@property (nonatomic) isSelected isSelected;

@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSString *titleColorStr;

@property (nonatomic) BOOL selectedMoreBth;

@end
