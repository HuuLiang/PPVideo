//
//  PPPayTypeCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QBOrderInfo.h>

typedef void(^payTypeAction)(void);

@interface PPPayTypeCell : UITableViewCell

@property (nonatomic) QBOrderPayType orderPayType;

@property (nonatomic) payTypeAction payAction;

@end
