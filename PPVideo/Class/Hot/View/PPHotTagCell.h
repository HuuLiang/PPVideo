//
//  PPHotTagCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchTagAction)(void);

@interface PPHotTagCell : UICollectionViewCell

@property (nonatomic) NSString *titleStr;

@property (nonatomic) touchTagAction tagAction;

@end
