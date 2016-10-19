//
//  PPSearchModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "PPColumnModel.h"

@interface PPSearchResponse : QBURLResponse

@end

@interface PPSearchModel : QBEncryptedURLRequest

- (BOOL)fetchSearchInfoWithTagStr:(NSString *)tagStr CompletionHandler:(QBCompletionHandler)handler;

@end
