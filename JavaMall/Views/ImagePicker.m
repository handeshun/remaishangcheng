//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "ImagePicker.h"

@interface ImagePicker()

@end

static BOOL isiOS8 = NO;
static ImagePicker *model;

@implementation ImagePicker {
    BOOL isEdit;
}


+ (id)sharedInstance {
    if (!model) {
        model = [[ImagePicker alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            isiOS8 = YES;
        }
    }
    return model;
}

- (void)startShowSelectTypeViewWithViewController:(id)viewController andIsEdit:(BOOL)edit {
    isEdit = edit;
    _delegate = viewController;
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [actSheet showInView:[_delegate viewControllerView]];
//    [self takePicFromAlbum];
}

- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self takePicFromAlbum];
            break;
        }
        case 1: {
            [self takePicFromCamera];
            break;
        }
        default:
            break;
    }
}

//从相册选取
- (void)takePicFromAlbum {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == 1 || author == 2) {
        UIAlertView *alertView;
        if (isiOS8) {
            alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"没有相册访问权限，请在设置-隐私-相册中进行设置！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        }
        else {
            alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"没有相册访问权限，请在设置-隐私-相册中进行设置！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        }
        [alertView show];
        return;
    }
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pick.delegate = self;
    pick.allowsEditing = isEdit;
    [(UIViewController *) _delegate presentViewController:pick animated:YES completion:nil];
}

//从相机
- (void)takePicFromCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView;
        if (isiOS8) {
            alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"没有相机访问权限，请在设置-隐私-相机中进行设置！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        }
        else {
            alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"没有相机访问权限，请在设置-隐私-相机中进行设置！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        }
        [alertView show];
        return;
        //无权限
    }
    if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                return;
            }
        }];

    }
    if ([UIImagePickerController
            isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.delegate = self;
        pick.allowsEditing = isEdit;
        [(UIViewController *) _delegate presentViewController:pick animated:YES completion:nil];
    }
    else {
        NSLog(@"没有相机权限！");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //iOS8后允许打开系统设置
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [_delegate imagePickerDidFinishWithImage:image];
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_delegate imagePickerDidCancel];
}

@end