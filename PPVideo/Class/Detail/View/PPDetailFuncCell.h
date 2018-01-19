//
//  PPDetailFuncCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPDetailFuncCell : UITableViewCell

@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger hateCount;
@property (nonatomic) BOOL isChanged;

@property (nonatomic) QBAction likeAction;
@property (nonatomic) QBAction hateAction;
@property (nonatomic) QBAction upAction;
@end
