//
//  PPDetailPhotoCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPDetailModel.h"

#define PPDetalCellHeight (kScreenWidth - kWidth(80))/3.5/0.79 + kWidth(41)

@interface PPDetailPhotoCell : UITableViewCell
@property (nonatomic) NSArray <PPDetailUrlModel *> *imgUrls;
@property (nonatomic) QBAction popUrlAction;
@end


@interface PPPhotoCell : UICollectionViewCell
@property (nonatomic) NSString *imgUrlStr;
@end

