//
//  PPTrailNormalCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTrailNormalCell : UICollectionViewCell

@property (nonatomic) NSString *imgUrlStr;
@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSInteger commentCount;

@property (nonatomic) BOOL isVipCell;
@property (nonatomic) BOOL isFreeCell;

@end
