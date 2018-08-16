//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MobileRegisterViewController3.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MemberApi.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "HeaderView.h"
#import "ESRedButton.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "ESTextField.h"
#import "NSString+Common.h"
#import "ToastUtils.h"
#import "ESLabel.h"
#import "Constants.h"
#import "Member.h"

@implementation MobileRegisterViewController3 {
    HeaderView *headerView;
    TPKeyboardAvoidingScrollView *contentView;

    ESTextField *passwordTf;
    ESRedButton *finishBtn;
    ESLabel *tipsLbl;

    MemberApi *memberApi;
}

@synthesize mobile, mobileCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    memberApi = [MemberApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"手机注册"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self createUI];

    //监测只有用户名和密码都不为空时才可以点击登录按钮
    RAC(finishBtn, enabled) = [RACSignal combineLatest:@[passwordTf.rac_textSignal]
                                              reduce:^id(NSString *mobile) {
                                                  return @(mobile.length > 0);
                                              }];

}

/**
 * 创建视图
 */
- (void)createUI {
    contentView = [TPKeyboardAvoidingScrollView new];
    contentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    tipsLbl = [[ESLabel alloc] initWithText:@"请设置您的密码" textColor:[UIColor darkGrayColor] fontSize:12];
    [contentView addSubview:tipsLbl];
    [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(contentView).offset(10);
    }];

    passwordTf = [ESTextField new];
    passwordTf.backgroundColor = [UIColor whiteColor];
    passwordTf.font = [UIFont systemFontOfSize:14];
    passwordTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
    passwordTf.secureTextEntry = YES;
    passwordTf.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"请您设置一个6到20位的密码"
                                            attributes:@{
                                                    NSForegroundColorAttributeName : [UIColor grayColor],
                                                    NSFontAttributeName : [UIFont systemFontOfSize:14]
                                            }
            ];
    [contentView addSubview:passwordTf];
    [passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(tipsLbl.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];

    //完成按钮
    finishBtn = [[ESRedButton alloc] initWithTitle:@"完成"];
    finishBtn.enabled = NO;
    [finishBtn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(passwordTf.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];
}

/**
 * 完成
 */
- (IBAction)finish:(ESRedButton *)sender {
    if (passwordTf.text.length < 6 || passwordTf.text.length > 20) {
        [ToastUtils show:@"请您设置一个6到20位的密码!"];
        return;
    }

    [ToastUtils showLoading:@"注册中..."];
    [memberApi mobileRegister:mobile mobileCode:mobileCode password:passwordTf.text success:^(Member *member) {
        [ToastUtils hideLoading];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:member] forKey:kCurrentMemberKey];
        [defaults synchronize];
        [Constants setMember:member];

        [[NSNotificationCenter defaultCenter] postNotificationName:nLogin object:nil];

        //登录环信
        [self loginIM:member.imUser pass:member.imPass];

        [ToastUtils show:@"注册成功！"];

        [self dismissViewControllerAnimated:YES completion:nil];

    }        failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:error.localizedDescription];
    }];
}

/**
 * 后退
 */
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end