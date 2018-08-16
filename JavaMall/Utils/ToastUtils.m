//
// Created by Dawei on 5/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ToastUtils.h"
#import "MBProgressHUD.h"


@implementation ToastUtils {

}

+ (void)show:(NSString *)text {
    [ToastUtils show:text hideAfterDelay:2];
}

+ (void)show:(NSString *)text hideAfterDelay:(NSTimeInterval)interval {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:interval];
}

+ (void)showLoading {
    MBProgressHUD *showingHud = [MBProgressHUD HUDForView:kKeyWindow];
    if(showingHud != nil && showingHud.mode != MBProgressHUDModeText){
        [showingHud hide:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
}

+ (void)showLoading:(NSString *)text {
    MBProgressHUD *showingHud = [MBProgressHUD HUDForView:kKeyWindow];
    if(showingHud != nil && showingHud.mode != MBProgressHUDModeText){
        [showingHud hide:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:12];
}

+ (void)hideLoading {
    [MBProgressHUD hideHUDForView:kKeyWindow animated:YES];
}

@end