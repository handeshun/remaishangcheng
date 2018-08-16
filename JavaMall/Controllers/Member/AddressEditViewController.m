//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "AddressEditViewController.h"
#import "HeaderView.h"
#import "AddressApi.h"
#import "Address.h"
#import "TPKeyboardAvoidingTableView.h"
#import "InputTextCell.h"
#import "Masonry.h"
#import "SelectTextCell.h"
#import "SwitchTextCell.h"
#import "ESTextField.h"
#import "RedButtonCell.h"
#import "ESRedButton.h"
#import "SelectRegionView.h"
#import "Region.h"
#import "ToastUtils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation AddressEditViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *addressTableView;

    AddressApi *addressApi;

    RedButtonCell *saveCell;
    SelectTextCell *regionCell;
    SelectRegionView *selectRegionView;

}

@synthesize address;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    addressApi = [AddressApi new];
    headerView = [[HeaderView alloc] initWithTitle:@""];
    if (address) {
        headerView.titleLbl.text = @"编辑收货地址";
    } else {
        headerView.titleLbl.text = @"新建收货地址";
    }

    if (address == nil) {
        address = [Address new];
    }
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    addressTableView = [TPKeyboardAvoidingTableView new];
    addressTableView.backgroundColor = [UIColor whiteColor];
    addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [addressTableView registerClass:[InputTextCell class] forCellReuseIdentifier:kCellIdentifier_InputTextCell];
    [addressTableView registerClass:[SelectTextCell class] forCellReuseIdentifier:kCellIdentifier_SelectTextCell];
    [addressTableView registerClass:[SwitchTextCell class] forCellReuseIdentifier:kCellIdentifier_SwitchTextCell];
    [addressTableView registerClass:[RedButtonCell class] forCellReuseIdentifier:kCellIdentifier_RedButtonCell];
    addressTableView.dataSource = self;
    addressTableView.delegate = self;
    [self.view addSubview:addressTableView];

    [addressTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 5) {
        return 44;
    }
    return 100;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        InputTextCell *nameCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [nameCell setTitle:@"收货人" andPlaceHolder:@""];
        [nameCell setValue:address.name];
        nameCell.textValueChangedBlock = ^(NSString *name) {
            address.name = name;
        };
        nameCell.editDidEndBlock = ^(NSString *name) {
            address.name = name;
        };
        return nameCell;
    } else if (indexPath.row == 1) {
        InputTextCell *mobileCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        mobileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [mobileCell.textField setKeyboardType:UIKeyboardTypeNumberPad];
        [mobileCell setTitle:@"联系方式" andPlaceHolder:@""];
        [mobileCell setValue:address.mobile];
        mobileCell.textValueChangedBlock = ^(NSString *mobile) {
            address.mobile = mobile;
        };
        mobileCell.editDidEndBlock = ^(NSString *mobile) {
            address.mobile = mobile;
        };
        return mobileCell;
    } else if (indexPath.row == 2) {
        regionCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectTextCell forIndexPath:indexPath];
        regionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [regionCell setTitle:@"所在地区"];

        if (address.province.length > 0) {
            NSString *addr = address.province;
            if (address.city.length > 0) {
                addr = [addr stringByAppendingFormat:@" %@", address.city];
            }
            if (address.region.length > 0) {
                addr = [addr stringByAppendingFormat:@" %@", address.region];
            }
            [regionCell setValue:addr];
        }

        return regionCell;
    } else if (indexPath.row == 3) {
        InputTextCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [addressCell setTitle:@"详细地址" andPlaceHolder:@""];
        [addressCell setValue:address.address];
        addressCell.textValueChangedBlock = ^(NSString *addr) {
            address.address = addr;
        };
        addressCell.editDidEndBlock = ^(NSString *addr) {
            address.address = addr;
        };
        return addressCell;
    } else if (indexPath.row == 4) {
        SwitchTextCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SwitchTextCell forIndexPath:indexPath];
        defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [defaultCell setTitle:@"设为默认地址"];
        [defaultCell setSwitchOn:address.isDefault];
        defaultCell.switchChangedBlock = ^(BOOL on) {
            address.isDefault = on;
        };
        return defaultCell;
    } else if (indexPath.row == 5) {
        saveCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [saveCell.button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [saveCell.button setTitle:@"保存" forState:UIControlStateNormal];

        RAC(saveCell.button, enabled) = [RACSignal combineLatest:@[
                        RACObserve(self, address.name),
                        RACObserve(self, address.mobile),
                        RACObserve(self, address.address),
                        RACObserve(self, address.province)
                ]
                                                          reduce:^id(
                                                                  NSString *name,
                                                                  NSString *mobile,
                                                                  NSString *addr,
                                                                  NSString *province) {
                                                              return @(name.length > 0 && mobile.length > 0 && addr.length > 0 && province.length > 0);
                                                          }];
        return saveCell;
    }
    return nil;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (selectRegionView == nil) {
            selectRegionView = [SelectRegionView new];
            selectRegionView.complete = ^(Region *province, Region *city, Region *region) {
                address.provinceId = province.id;
                address.province = province.name;

                address.cityId = city.id;
                address.city = city.name;

                address.regionId = region.id;
                address.region = region.name;

                NSString *addr = province.name;
                if (city != nil) {
                    addr = [addr stringByAppendingFormat:@" %@", city.name];
                }
                if (region != nil) {
                    addr = [addr stringByAppendingFormat:@" %@", region.name];
                }
                [regionCell setValue:addr];
            };
            [self.view addSubview:selectRegionView];
        }
        [selectRegionView show];
    }
}

/**
 * 保存信息
 */
- (IBAction)save {
    [ToastUtils showLoading];
    if(address.id > 0){
        [addressApi edit:address success:^(Address *add){
            [ToastUtils hideLoading];
            [[NSNotificationCenter defaultCenter] postNotificationName:nEditAddress object:nil userInfo:add];
            [self back];
        } failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:[error localizedDescription]];
        }];
        return;
    }
    [addressApi add:address success:^(Address *add){
        [ToastUtils hideLoading];
        [[NSNotificationCenter defaultCenter] postNotificationName:nAddAddress object:nil userInfo:add];
        [self back];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 后退
 */
- (IBAction)back {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end