//
//  PPSearchResultViewController.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"

@class PPSearchProgramModel;

@interface PPSearchResultViewController : PPBaseViewController

- (instancetype)initWithProgramList:(NSArray <PPSearchProgramModel *> *)programList searchWords:(NSString *)searchWords ColumnId:(NSInteger)columnId;

@end
