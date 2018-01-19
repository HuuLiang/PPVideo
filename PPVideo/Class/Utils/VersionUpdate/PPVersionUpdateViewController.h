//
//  PPVersionUpdateViewController.h
//  PPVideo
//
//  Created by Liang on 2016/12/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"

@interface PPVersionUpdateViewController : PPBaseViewController

- (instancetype)init __attribute__ ((unavailable("Use initWithUrl: instead")));

- (instancetype)initWithLinkUrl:(NSString *)url;

@end
