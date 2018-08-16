//
//  ConnectLoginBindController.h
//  JavaMall
//
//  Created by LDD on 17/7/19.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "BaseViewController.h"

@interface ConnectLoginBindController : BaseViewController
@property(assign, nonatomic) NSInteger connectType;
@property(strong, nonatomic) NSString  *openid;
@property(strong, nonatomic) NSString  *nikename;
@property(strong, nonatomic) NSString  *face;
@end
