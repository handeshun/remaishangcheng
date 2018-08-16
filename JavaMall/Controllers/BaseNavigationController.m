//
// Created by Dawei on 1/27/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry.h>
#import "BaseNavigationController.h"
#import "MBProgressHUD.h"


@implementation BaseNavigationController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

@end