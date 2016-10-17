//
//  PPSexCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSexCell : UICollectionViewCell

@property (nonatomic) NSString *imgUrlStr;
@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSString *tagStr;
@property (nonatomic) NSString *tagHexStr;

@end
