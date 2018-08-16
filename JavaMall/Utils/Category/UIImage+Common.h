//
// Created by Dawei on 10/21/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Common)
+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
@end