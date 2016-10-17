//
//  PPTrailModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>


@interface PPTrailReponse : QBURLResponse

@end

@interface PPTrailModel : QBEncryptedURLRequest

- (BOOL)fetchTrailInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
