//
//  ManagetStoreViewController.h
//  JavaMall
//
//  Created by Cheerue on 2017/9/5.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchDelegate.h"
@interface ManagetStoreViewController : BaseViewController <UIScrollViewDelegate,UIWebViewDelegate,SearchDelegate>
@property (nonatomic,copy)NSString *managetStr;
@property (nonatomic,copy)NSString *username;

@end
