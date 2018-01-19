//
//  PPTrailHeaderView.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBtn)(void);

@interface PPTrailHeaderView : UICollectionReusableView

@property (nonatomic) touchBtn selected;
@property (nonatomic) BOOL selectedMoreBtn;

@end
