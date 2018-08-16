//
//  AdaptationKit.h
//  私募
//
//  Created by Guo Hero on 16/8/17.
//  Copyright © 2016年 Cheerue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AdaptationKit : NSObject

+ (CGFloat)getHorizontalSpace:(CGFloat)space;
+ (CGFloat)getVerticalSpace:(CGFloat)space;

+ (CGSize)setLabelCustomSize:(CGFloat)width
                   labelText:(NSString *)text
                   labelFont:(CGFloat)font;

+ (CGFloat)setFontSize:(CGFloat)size;

+ (CGFloat)bottomLabelHeightWithContentString:(NSString *)content withFontSize:(CGFloat)fontSize withSpacing:(CGFloat)spacing withWidth:(CGFloat)width;

+ (NSAttributedString *)bottomContentString:(NSString *)content withTextSize:(CGFloat)size withSpacing:(CGFloat)spacing;

@end
