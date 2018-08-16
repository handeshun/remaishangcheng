//
//  StoreAddressListViewController.m
//  JavaMall
//
//  Created by Cheerue on 2018/4/16.
//  Copyright © 2018年 Enation. All rights reserved.
//

#import "StoreAddressListViewController.h"
#import "HeaderView.h"
#import "Address.h"
#import "AddressApi.h"
#import "StoreListTableViewCell.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "StoreViewController.h"

@interface StoreAddressListViewController ()
@end

@implementation StoreAddressListViewController{
    HeaderView *headerView;
    UITableView *storeListtableview;
    AddressApi *addressApi;
    NSMutableArray *addressArray;
    CLLocationManager *locationmanager;
    CGFloat latitude;//经度
    CGFloat longitude;//纬度
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    
    addressApi = [AddressApi new];
    addressArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"我附近的店铺";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];
    [self makeUI];

    [self getLocation];
}

- (IBAction)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)makeUI
{
    storeListtableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    storeListtableview.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    storeListtableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    storeListtableview.dataSource = self;
    storeListtableview.delegate = self;
    [storeListtableview registerClass:[StoreListTableViewCell class] forCellReuseIdentifier:kCellIdentifier_StoreListTableViewCell];
    [self.view addSubview:storeListtableview];
    [storeListtableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
    storeListtableview.rowHeight = 110;
    storeListtableview.tableFooterView = [UIView new];
    
}
-(void)loadData
{

    [addressApi getAddress:latitude lon:longitude success:^(NSMutableArray *address) {
        [addressArray removeAllObjects];
        [addressArray addObjectsFromArray:address];
        [storeListtableview reloadData];
    } failure:^(NSError *error) {
        [ToastUtils show:[error localizedDescription]];
    }];
}

-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 100.0;
        [locationmanager startUpdatingLocation];
    }
}

#pragma TableView

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addressArray.count;
}


/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StoreListTableViewCell forIndexPath:indexPath];
    [cell configData:[addressArray objectAtIndex:indexPath.row]];
    
    return cell;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     Address *address = [addressArray objectAtIndex:indexPath.row];
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = address.store_id;
    [[self navigationController] pushViewController:storeViewController animated:YES];
   // [self.navigationController popViewControllerAnimated:YES];
    //发送购物车商品项改变的通知
    NSString *storeAddress =  [NSString stringWithFormat:@"%@:%@",address.store_name,address.attr];
    [[NSNotificationCenter defaultCenter] postNotificationName:nchangStoreAddress object:storeAddress];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
    
    [self loadData];
    
}

//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self loadData];
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
