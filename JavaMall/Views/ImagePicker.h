//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ImagePickerDelegate
- (void)imagePickerDidFinishWithImage:(UIImage *)image;

- (void)imagePickerDidCancel;

//弹出警告框的视图
- (UIView *)viewControllerView;

@end

@interface ImagePicker : NSObject

@property (assign, nonatomic) id<ImagePickerDelegate> delegate;

+ (id)sharedInstance;

- (void)startShowSelectTypeViewWithViewController:(id)viewController andIsEdit:(BOOL)edit;

@end