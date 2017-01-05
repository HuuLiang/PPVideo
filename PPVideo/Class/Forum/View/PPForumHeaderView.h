//
//  PPForumHeaderView.h
//  PPVideo
//
//  Created by Liang on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPForumHeaderView : UICollectionReusableView
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *owner;
@end


@interface PPForumTitleView : UICollectionReusableView

@property (nonatomic) NSAttributedString *attriString;

@end
