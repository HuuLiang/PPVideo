//
//  NSString+StringHeight.h
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringHeight)

- (CGFloat)getStringHeightWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)size;

- (NSAttributedString *)getAttriStringWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)size;

- (NSAttributedString *)getAttriCenterStringWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)size;

@end
