//
//  StoreAddressListViewController.h
//  JavaMall
//
//  Created by Cheerue on 2018/4/16.
//  Copyright © 2018年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface StoreAddressListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate ,CLLocationManagerDelegate>
@property (nonatomic,strong)NSMutableArray *dataArr;
@end
