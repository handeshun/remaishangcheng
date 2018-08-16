//
//  FenxiaoManagerViewController.h
//  JavaMall
//
//  Created by Cheerue on 2017/9/2.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseViewController.h"
#import "SearchDelegate.h"
@interface FenxiaoManagerViewController : BaseViewController<UIScrollViewDelegate,UIWebViewDelegate, SearchDelegate>
@property (nonatomic,copy) NSString *uname;
@end
