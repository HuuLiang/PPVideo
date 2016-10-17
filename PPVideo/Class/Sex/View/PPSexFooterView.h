//
//  PPSexFooterView.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^moreAction)(void);

@interface PPSexFooterView : UICollectionReusableView

@property (nonatomic) NSString *timeStr;
@property (nonatomic) moreAction moreAction;

@end
