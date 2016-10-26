//
//  NSString+StringHeight.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "NSString+StringHeight.h"

@implementation NSString (StringHeight)

- (CGFloat)getStringHeightWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:[self getAttrsWithFont:font lineSpace:lineSpace]
                              context:nil].size.height;
}

- (NSAttributedString *)getAttriStringWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)size {
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithString:self
                                                                   attributes:[self getAttrsWithFont:font lineSpace:lineSpace]];
    return attriStr;
}

- (NSDictionary *)getAttrsWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = lineSpace;
    NSDictionary *attrs = @{NSFontAttributeName : font,
                            NSParagraphStyleAttributeName:style};
    return  attrs;
}

- (NSAttributedString *)getAttriCenterStringWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)size {
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = lineSpace;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSFontAttributeName : font,
                            NSParagraphStyleAttributeName:style};
    
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithString:self
                                                                   attributes:attrs];
    return attriStr;
}

@end
