//
// Created by Dawei on 7/16/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RegisterViewController.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ESRedButton.h"
#import "UIView+Common.h"
#import "ESLabel.h"
#import "ToastUtils.h"
#import "MemberApi.h"
#import "Constants.h"
#import "Member.h"

@implementation RegisterViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingScrollView *contentView;

    UIView *loginView;
    UIImageView *imageView;
    UITextField *verTf;
    UITextField *accountTf;
    UITextField *passwordTf;
    UITextField *rePasswordTf;
    ESRedButton *registerBtn;

    MemberApi *memberApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    memberApi = [MemberApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"注册"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self createUI];

    //监测只有用户名和密码都不为空时才可以点击登录按钮
    RAC(registerBtn, enabled) = [RACSignal combineLatest:@[accountTf.rac_textSignal, passwordTf.rac_textSignal, rePasswordTf.rac_textSignal]
                                               reduce:^id(NSString *account, NSString *password, NSString *repass) {
        return @(account.length > 0 && password.length > 0 && repass.length > 0);
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

    //登录框
    [self createLoginView];

    //注册按钮
    registerBtn = [[ESRedButton alloc] initWithTitle:@"注册"];
    registerBtn.enabled = NO;
    [registerBtn addTarget:self action:@selector(register) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(loginView.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];

    [self.view layoutIfNeeded];
    [loginView topBorder:[UIColor colorWithHexString:kBorderLineColor]];
    [loginView bottomBorder:[UIColor colorWithHexString:kBorderLineColor]];
}

/**
 * 创建登录框
 */
- (void)createLoginView {
    loginView = [UIView new];
    loginView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headerView.mas_bottom).offset(10);
        make.height.equalTo(@190);
    }];

    //账号
    ESLabel *accountLbl = [[ESLabel alloc] initWithText:@"账号" textColor:[UIColor darkGrayColor] fontSize:14];
    accountLbl.textAlignment = NSTextAlignmentRight;
    [loginView addSubview:accountLbl];
    [accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView).offset(10);
        make.top.equalTo(loginView).offset(22);
        make.width.equalTo(@60);
    }];

    accountTf = [UITextField new];
    accountTf.font = [UIFont systemFontOfSize:14];
    accountTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
    accountTf.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"请输入要注册的用户名"
                                            attributes:@{
                                                    NSForegroundColorAttributeName : [UIColor grayColor],
                                                    NSFontAttributeName : [UIFont systemFontOfSize:13]
                                            }
            ];
    [accountTf addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [loginView addSubview:accountTf];
    [accountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLbl.mas_right).offset(10);
        make.right.equalTo(self.view);
        make.centerY.equalTo(accountLbl);
        make.height.equalTo(@20);
    }];

    UIView *accountLine = [UIView new];
    accountLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:accountLine];
    [accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(accountTf);
        make.top.equalTo(accountTf.mas_bottom).offset(10);
        make.height.equalTo(@0.5f);
    }];

    //密码
    ESLabel *passwordLbl = [[ESLabel alloc] initWithText:@"密码" textColor:[UIColor darkGrayColor] fontSize:14];
    passwordLbl.textAlignment = NSTextAlignmentRight;
    [loginView addSubview:passwordLbl];
    [passwordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLbl);
        make.top.equalTo(accountLbl.mas_bottom).offset(27);
        make.width.equalTo(accountLbl);
    }];

    passwordTf = [UITextField new];
    passwordTf.font = [UIFont systemFontOfSize:14];
    passwordTf.secureTextEntry = YES;
    passwordTf.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"请输入密码"
                                            attributes:@{
                                                    NSForegroundColorAttributeName : [UIColor grayColor],
                                                    NSFontAttributeName : [UIFont systemFontOfSize:13]
                                            }
            ];
    [passwordTf addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [loginView addSubview:passwordTf];
    [passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(accountTf);
        make.centerY.equalTo(passwordLbl);
    }];

    UIView *passwordLine = [UIView new];
    passwordLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:passwordLine];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(passwordTf);
        make.top.equalTo(passwordTf.mas_bottom).offset(10);
        make.height.equalTo(@0.5f);
    }];

    //重复密码
    ESLabel *rePasswordLbl = [[ESLabel alloc] initWithText:@"重复密码" textColor:[UIColor darkGrayColor] fontSize:14];
    rePasswordLbl.textAlignment = NSTextAlignmentRight;
    [loginView addSubview:rePasswordLbl];
    [rePasswordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLbl);
        make.top.equalTo(passwordLbl.mas_bottom).offset(27);
        make.width.equalTo(accountLbl);
    }];

    rePasswordTf = [UITextField new];
    rePasswordTf.font = [UIFont systemFontOfSize:14];
    rePasswordTf.secureTextEntry = YES;
    rePasswordTf.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"请再输入一次密码"
                                            attributes:@{
                                                    NSForegroundColorAttributeName : [UIColor grayColor],
                                                    NSFontAttributeName : [UIFont systemFontOfSize:13]
                                            }
            ];
    [rePasswordTf addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [loginView addSubview:rePasswordTf];
    [rePasswordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(accountTf);
        make.centerY.equalTo(rePasswordLbl);
    }];
    UIView *reline = [UIView new];
    reline.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:reline];
    [reline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(rePasswordTf);
        make.top.equalTo(rePasswordTf.mas_bottom).offset(10);
        make.height.equalTo(@0.5f);
    }];
    
    
    imageView = [UIImageView new];
    ESLabel *verCodeTitle = [[ESLabel alloc] initWithText:@"验证码" textColor:[UIColor darkGrayColor] fontSize:14];
    [loginView addSubview:verCodeTitle];
    [verCodeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView).offset(27);
        make.top.equalTo(rePasswordTf.mas_bottom).offset(21);
    }];
    verTf = [UITextField new];
    verTf.font=[UIFont systemFontOfSize:14];
    verTf.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                                                   attributes:@{
                                                                                NSForegroundColorAttributeName: [UIColor grayColor],
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:13]
                                                                                }
                                    ];
    [verTf addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [loginView addSubview:verTf];
   
    UIView *imageParent =  [UIControl new];
    imageParent.backgroundColor = [UIColor clearColor];
    [imageParent addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@35);
        make.center.equalTo(imageParent);
    }];
    [(UIControl *)imageParent addTarget:self action:@selector(updataImageView) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:imageParent];
    [imageParent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verCodeTitle);
        make.right.equalTo(loginView).offset(-5);
        make.width.equalTo(@60);
        make.height.equalTo(@35);
    }];
    [verTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(accountTf);
        make.right.equalTo(imageParent.mas_left).offset(-3);
        make.left.equalTo(accountTf);
        make.centerY.equalTo(verCodeTitle);
    }];
    
    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(passwordTf);
        make.top.equalTo(imageView.mas_bottom).offset(2);
        make.height.equalTo(@0.5);
    }];
    [[MemberApi new]loadRegisterImage:imageView];
}

//点击键盘上的Return按钮响应的方法
- (IBAction)returnOnKeyboard:(UITextField *)sender {
    if (sender == accountTf) {
        [passwordTf becomeFirstResponder];
    } else if (sender == passwordTf) {
        [rePasswordTf becomeFirstResponder];
    }else if(sender == rePasswordTf){
        [self hidenKeyboard];
        [self register];
    }
}

//隐藏键盘的方法
- (void)hidenKeyboard {
    [accountTf resignFirstResponder];
    [passwordTf resignFirstResponder];
    [rePasswordTf resignFirstResponder];
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

/**
 * 注册
 */
- (IBAction)register {
    if (accountTf.text.length == 0) {
        [ToastUtils show:@"用户名不能为空！"];
        return;
    }
    if (passwordTf.text.length == 0) {
        [ToastUtils show:@"密码不能为空！"];
        return;
    }
    if(![passwordTf.text isEqualToString:rePasswordTf.text]){
        [ToastUtils show:@"两次密码输入不一致!"];
        return;
    }
    if(verTf.text.length==0 ){
        [ToastUtils show:@"请输入验证码！"];
        return;
    }

    [ToastUtils showLoading:@"注册中..."];
    [memberApi register:accountTf.text password:passwordTf.text vcode:verTf.text success:^(Member *member) {
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
 *更新登录验证码
 */
-(IBAction)updataImageView{
    [[MemberApi new]loadRegisterImage:imageView];
}
@end