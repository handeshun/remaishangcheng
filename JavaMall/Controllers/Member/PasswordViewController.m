//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PasswordViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "InputTextCell.h"
#import "RedButtonCell.h"
#import "Masonry.h"
#import "ESRedButton.h"
#import "ToastUtils.h"
#import "MemberApi.h"
#import "ESTextField.h"


@implementation PasswordViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *myTable;

    MemberApi *memberApi;
}

@synthesize oldPass, nPass, rePass;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    memberApi = [MemberApi new];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"修改密码";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [TPKeyboardAvoidingTableView new];
    myTable.backgroundColor = [UIColor whiteColor];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTable registerClass:[InputTextCell class] forCellReuseIdentifier:kCellIdentifier_InputTextCell];
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

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        return 44;
    }
    return 100;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"旧密码" andPlaceHolder:@""];
        cell.textField.secureTextEntry = YES;
        cell.textValueChangedBlock = ^(NSString *value) {
            self.oldPass = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            self.oldPass = value;
        };
        return cell;
    } else if (indexPath.row == 1) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"新密码" andPlaceHolder:@""];
        cell.textField.secureTextEntry = YES;
        cell.textValueChangedBlock = ^(NSString *value) {
            self.nPass = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            self.nPass = value;
        };
        return cell;
    } else if (indexPath.row == 2) {
        InputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"确认密码" andPlaceHolder:@""];
        cell.textField.secureTextEntry = YES;
        cell.textValueChangedBlock = ^(NSString *value) {
            self.rePass = value;
        };
        cell.editDidEndBlock = ^(NSString *value) {
            self.rePass = value;
        };
        return cell;
    } else if (indexPath.row == 3) {
        RedButtonCell *saveCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [saveCell.button addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
        [saveCell.button setTitle:@"修改密码" forState:UIControlStateNormal];

        RAC(saveCell.button, enabled) = [RACSignal combineLatest:@[
                        RACObserve(self, oldPass),
                        RACObserve(self, nPass),
                        RACObserve(self, rePass)
                ]
                                                          reduce:^id(
                                                                  NSString *oPass,
                                                                  NSString *nPass,
                                                                  NSString *rPass) {
                                                              return @(oPass.length > 0 && nPass.length > 0 && rPass.length > 0);
                                                          }];
        return saveCell;
    }
    return nil;
}


/**
 * 保存信息
 */
- (IBAction)changePassword:(UIButton *)sender {
    if(nPass.length < 6 || nPass.length > 20){
        [ToastUtils show:@"新密码的长度为6-20个字符！"];
        return;
    }
    if([rePass isEqualToString:nPass] == NO){
        [ToastUtils show:@"新密码和确认密码输入的不一致！"];
        return;
    }

    [ToastUtils showLoading];
    [memberApi changePassword:oldPass newPass:nPass rePass:rePass success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"修改密码成功!"];
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