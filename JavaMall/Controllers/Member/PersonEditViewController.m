//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PersonEditViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MemberApi.h"
#import "InputTextCell.h"
#import "SelectTextCell.h"
#import "Member.h"
#import "RedButtonCell.h"
#import "SelectImageCell.h"
#import "Masonry.h"
#import "ESTextField.h"
#import "DateUtils.h"
#import "ESRedButton.h"
#import "ESButton.h"
#import "SelectRegionView.h"
#import "Region.h"
#import "ToastUtils.h"
#import "SelectDateView.h"
#import "SelectValueView.h"
#import "UIImage+Common.h"
#import "NSString+Common.h"

@implementation PersonEditViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *myTable;

    SelectRegionView *selectRegionView;
    SelectDateView *selectDateView;
    SelectValueView *selectSexView;

    SelectImageCell *faceCell;
    SelectTextCell *regionCell;
    SelectTextCell *birthdayCell;
    SelectTextCell *sexCell;

    MemberApi *memberApi;
    NSMutableArray *sexArray;
}

@synthesize member;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    sexArray = [[NSMutableArray alloc] initWithObjects:@"保密", @"男", @"女", nil];

    memberApi = [MemberApi new];
    if (member == nil) {
        member = [Member new];
    }

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"个人资料";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [TPKeyboardAvoidingTableView new];
    myTable.backgroundColor = [UIColor whiteColor];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTable registerClass:[InputTextCell class] forCellReuseIdentifier:kCellIdentifier_InputTextCell];
    [myTable registerClass:[SelectTextCell class] forCellReuseIdentifier:kCellIdentifier_SelectTextCell];
    [myTable registerClass:[SelectImageCell class] forCellReuseIdentifier:kCellIdentifier_SelectImageCell];
    [myTable registerClass:[RedButtonCell class] forCellReuseIdentifier:kCellIdentifier_RedButtonCell];
    myTable.dataSource = self;
    myTable.delegate = self;
    [self.view addSubview:myTable];

    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [memberApi info:^(Member *_member) {
        member = _member;
        [myTable reloadData];
        [ToastUtils hideLoading];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }
    if (indexPath.row < 10) {
        return 44;
    }
    return 100;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        faceCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectImageCell forIndexPath:indexPath];
        faceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [faceCell setTitle:@"头像"];
        [faceCell setImageBorder:[UIColor colorWithHexString:@"#EEEEEE"] circle:YES width:1.0f];
        if(member.face != nil && member.face.length > 0){
            [faceCell setImageURL:member.face];
        }else{
            [faceCell setImage:[UIImage imageNamed:@"my_head_default.png"]];
        }
        return faceCell;
    } else if (indexPath.row == 1) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.enabled = NO;
        cell.textField.clearButtonMode = UITextFieldViewModeNever;
        cell.textField.textColor = [UIColor grayColor];
        [cell setTitle:@"用户名" andPlaceHolder:@""];
        [cell setValue:member.userName];
        return cell;
    } else if (indexPath.row == 2) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"姓名" andPlaceHolder:@""];
        [cell setValue:member.name];
        cell.textValueChangedBlock = ^(NSString *value) {
            member.name = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            member.name = value;
        };
        return cell;
    } else if (indexPath.row == 3) {
        sexCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectTextCell forIndexPath:indexPath];
        sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [sexCell setTitle:@"性别"];

        switch (member.sex) {
            case 0:
                [sexCell setValue:@"保密"];
                break;
            case 1:
                [sexCell setValue:@"男"];
                break;
            case 2:
                [sexCell setValue:@"女"];
                break;
        }

        return sexCell;
    } else if (indexPath.row == 4) {
        birthdayCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectTextCell forIndexPath:indexPath];
        birthdayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [birthdayCell setTitle:@"生日"];
        if (member.birthday != nil) {
            [birthdayCell setValue:[DateUtils dateToString:member.birthday withFormat:@"yyyy-MM-dd"]];
        }
        return birthdayCell;
    } else if (indexPath.row == 5) {
        regionCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectTextCell forIndexPath:indexPath];
        regionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [regionCell setTitle:@"居住地"];
        NSString *addr = @"";
        if (member.province != nil && member.province.length > 0) {
            addr = [addr stringByAppendingFormat:@"%@", member.province];
        }
        if (member.city != nil && member.city.length > 0) {
            addr = [addr stringByAppendingFormat:@" %@", member.city];
        }
        if (member.region != nil && member.region.length > 0) {
            addr = [addr stringByAppendingFormat:@" %@", member.region];
        }
        [regionCell setValue:addr];
        return regionCell;
    } else if (indexPath.row == 6) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"详细地址" andPlaceHolder:@""];
        [cell setValue:member.address];
        cell.textValueChangedBlock = ^(NSString *value) {
            member.address = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            member.address = value;
        };
        return cell;
    } else if (indexPath.row == 7) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"邮编" andPlaceHolder:@""];
        [cell setValue:member.zip];
        cell.textValueChangedBlock = ^(NSString *value) {
            member.zip = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            member.zip = value;
        };
        return cell;
    } else if (indexPath.row == 8) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"手机" andPlaceHolder:@""];
        [cell setValue:member.mobile];
        cell.textValueChangedBlock = ^(NSString *value) {
            member.mobile = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            member.mobile = value;
        };
        return cell;
    } else if (indexPath.row == 9) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"固定电话" andPlaceHolder:@""];
        [cell setValue:member.tel];
        cell.textValueChangedBlock = ^(NSString *value) {
            member.tel = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            member.tel = value;
        };
        return cell;
    } else if (indexPath.row == 10) {
        RedButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setTitle:@"保存资料" forState:UIControlStateNormal];
        cell.button.enabled = YES;
        return cell;
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
    //选择照片
    if(indexPath.row == 0){
        [[ImagePicker sharedInstance] startShowSelectTypeViewWithViewController:self andIsEdit:NO];
        return;
    }

    //选择性别
    if(indexPath.row == 3){
        if(selectSexView == nil){
            selectSexView = [SelectValueView new];
            selectSexView.complete = ^(NSInteger index, NSString *value){
                member.sex = index;
                [sexCell setValue:value];
            };
            selectSexView.valueArray = sexArray;
            [self.view addSubview:selectSexView];
        }
        [selectSexView show];
        return;
    }

    //选择生日
    if(indexPath.row == 4){
        if(selectDateView == nil){
            selectDateView = [SelectDateView new];
            selectDateView.complete = ^(NSDate *date){
                member.birthday = date;
                [birthdayCell setValue:[DateUtils dateToString:date withFormat:@"yyyy-MM-dd"]];
            };
            [self.view addSubview:selectDateView];
        }
        [selectDateView show];
        return;
    }

    //选择地区
    if (indexPath.row == 5) {
        if (selectRegionView == nil) {
            selectRegionView = [SelectRegionView new];
            selectRegionView.complete = ^(Region *province, Region *city, Region *region) {
                member.provinceId = province.id;
                member.province = province.name;

                member.cityId = city.id;
                member.city = city.name;

                member.regionId = region.id;
                member.region = region.name;

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
        return;
    }
}

#pragma ImagePickerDelegate
- (void)imagePickerDidFinishWithImage:(UIImage *)_image {
    member.faceImage = _image;
    [faceCell setImage:member.faceImage];
}

- (void)imagePickerDidCancel {}

- (UIView *)viewControllerView {
    return nil;
}

/**
 * 保存信息
 */
- (IBAction)save:(ESButton *)sender {
    if(member.mobile == nil || member.mobile.length <= 0){
        [ToastUtils show:@"手机号码不能为空!"];
        return;
    }
    if(![member.mobile isMobile]){
        [ToastUtils show:@"手机号码格式不正确!"];
        return;
    }
    [ToastUtils showLoading];
    [memberApi saveInfo:member success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"修改资料成功!"];
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