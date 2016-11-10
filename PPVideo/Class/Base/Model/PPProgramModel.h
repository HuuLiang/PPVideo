//
//  PPProgramModel.h
//  PPVideo
//
//  Created by Liang on 2016/10/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface PPProgramModel : JKDBModel <NSCoding>

@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *detailsCoverImg;
@property (nonatomic) NSInteger payPointType;
@property (nonatomic) NSInteger programId;
@property (nonatomic) NSString *spare;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *videoUrl;

@property (nonatomic) BOOL hasTimeControl;

@end
