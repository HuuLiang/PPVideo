//
//  PPWebViewController.h
//  PPVideo
//
//  Created by ylz on 2017/1/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "PPBaseViewController.h"

@interface PPWebViewController : PPBaseViewController

@property (nonatomic,readonly) NSURL *url;
@property (nonatomic,readonly) NSURL *standbyUrl;
@property (nonatomic,readonly) NSString *htmlString;

- (instancetype)initWithURL:(NSURL *)url standbyURL:(NSURL *)standbyUrl;
- (instancetype)initWithHTML:(NSString *)htmlString;

@end
