//
//  AdaptationKit.m
//  私募
//
//  Created by Guo Hero on 16/8/17.
//  Copyright © 2016年 Cheerue. All rights reserved.
//
#import "AdaptationKit.h"

//用户设备尺寸
#define iPhone5 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))
#define iPhone6 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667))
#define iPhone6plus CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))

#define FONT_WITH_SIZE(float)  [UIFont systemFontOfSize:float]

#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AdaptationKit

+ (CGFloat)getHorizontalSpace:(CGFloat)space{
    
    CGFloat horizontalSpace;
    if (iPhone6plus) {
        horizontalSpace = space/2.0 * 414 / 375;
    } else if(iPhone6){
        horizontalSpace = space/2.0;
    } else if (iPhone5) {
        horizontalSpace = space/2.0/375*320;
    } else {
        horizontalSpace = space/2.0/375*320;
    }
    return horizontalSpace;
    
}


+ (CGFloat)getVerticalSpace:(CGFloat)space{
    
    CGFloat VerticalSpace;
    if (iPhone6plus) {
        VerticalSpace = space/2.0*736/667;
    } else if(iPhone6){
        VerticalSpace = space/2.0;
    } else if (iPhone5) {
        VerticalSpace = space/2.0/667*568;
    } else {
        VerticalSpace = space/2.0/667*480;
    }
    return VerticalSpace;
}




+ (CGSize)setLabelCustomSize:(CGFloat)width
                   labelText:(NSString *)text
                   labelFont:(CGFloat)font {
    
    CGRect labelRect = [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_WITH_SIZE(font), NSFontAttributeName, nil] context:nil];
    CGSize labelSize = CGSizeMake(labelRect.size.width, labelRect.size.height);
    return labelSize;
}

+ (CGFloat)bottomLabelHeightWithContentString:(NSString *)content withFontSize:(CGFloat)fontSize withSpacing:(CGFloat)spacing withWidth:(CGFloat)width{
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attributes;
    
    if (iPhone6plus) {
        paragraphStyle.lineSpacing = spacing/2.0*736/667;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE([self setFontSize:fontSize]), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
        
    } else if (iPhone6) {
        
        paragraphStyle.lineSpacing = spacing/2.0;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE([self setFontSize:fontSize]), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
        
    } else if (iPhone5) {
        
        paragraphStyle.lineSpacing = spacing/2.0/667*568;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE([self setFontSize:fontSize]), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
    } else {
        
        paragraphStyle.lineSpacing = spacing/2.0/667*480;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE([self setFontSize:fontSize]), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
    }
    
    CGFloat contentW = [AdaptationKit getHorizontalSpace:width];
    CGRect contentR = [content boundingRectWithSize:CGSizeMake(contentW, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return contentR.size.height;
}

+ (NSAttributedString *)bottomContentString:(NSString *)content withTextSize:(CGFloat)size withSpacing:(CGFloat)spacing {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attributes;
    
    if (iPhone6plus) {
        
        paragraphStyle.lineSpacing = spacing/2.0*736/667;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE(size/2), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
        
    } else if (iPhone6) {
        
        paragraphStyle.lineSpacing = spacing/2.0;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE(size/2), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
        
    } else if (iPhone5) {
        
        paragraphStyle.lineSpacing = spacing/2.0/667*568;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE(size/2), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
    } else {
        
        paragraphStyle.lineSpacing = spacing/2.0/667*480;
        attributes = @{ NSFontAttributeName:FONT_WITH_SIZE(size/2), NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromRGB(0x616161)};
    }
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:content attributes:attributes];
    return attributeStr;
}

+ (CGFloat)setFontSize:(CGFloat)size
{
    CGFloat fontSize;
    if (iPhone6plus) {
        fontSize = size/2.0*414/375;
    } else if (iPhone6) {
        fontSize = size/2.0;
    } else if (iPhone5) {
        fontSize = size/2.0/375*320;
    } else {
        fontSize = size/2.0/375*320;
    }
    return fontSize;
}

@end
