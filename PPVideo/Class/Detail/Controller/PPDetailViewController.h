//
//  PPDetailViewController.h
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPLayoutViewController.h"

@interface PPDetailViewController : PPLayoutViewController

- (instancetype)initWithBaseModelInfo:(QBBaseModel *)baseModel ColumnId:(NSInteger)columnId programInfo:(PPProgramModel *)programModel;

@end
