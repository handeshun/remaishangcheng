//
//  ConnectLoginBindController.m
//  JavaMall
//
//  Created by LDD on 17/7/19.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewController.h"
#import "HeaderView.h"
#import "UIImageView+WebCache.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "UIButton+WebCache.h"
#import "ESLabel.h"
#import "ESRedButton.h"
#import "ToastUtils.h"
#import "ESButton.h"
#import "MemberApi.h"
#import "Constants.h"
#import "RegisterViewController.h"
#import "FindPassViewController1.h"
#import "BaseNavigationController.h"
#import "MobileRegisterViewController1.h"
#import "EMClient.h"
#import <UMSocialCore/UMSocialCore.h>
#import "Member.h"
#import "Utils.h"
#import "ConnectLoginBindController.h"

@implementation ConnectLoginBindController
{
    HeaderView *headerView;
    TPKeyboardAvoidingScrollView *contentView;
    
    UIView *loginView;
    UIView *connectUserView;
    UITextField *accountTf;
    UITextField *passwordTf;
    ESRedButton *loginBtn;
}
@synthesize connectType,face,nikename,openid;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    connectUserView = [self createConnectUserView:face userType:connectType];
    headerView = [[HeaderView alloc] initWithTitle:@"绑定"];
    [headerView setCancelAction:@selector(cancel)];
    [self.view addSubview:headerView];
    
    [self createUI];
    
    //监测只有用户名和密码都不为空时才可以点击登录按钮
    RAC(loginBtn, enabled) = [RACSignal combineLatest:@[accountTf.rac_textSignal, passwordTf.rac_textSignal] reduce:^id(NSString *account, NSString *password) {
        return @(account.length > 0 && password.length > 0);
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
    [contentView addSubview:connectUserView];
    [connectUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.width.equalTo(contentView);
        make.height.mas_equalTo(kScreen_Height/15);
        make.top.equalTo(contentView);
    }];
    /**
     *  todo
     */
    //登录框
    [self createLoginView];
    
    //登录按钮
   
    switch (connectType) {
        case QQ_LOGIN_TYPE:
             loginBtn = [[ESRedButton alloc] initWithTitle:@"绑 定 QQ"];
            break;
        case WECHAT_LOGIN_TYPE:
             loginBtn = [[ESRedButton alloc] initWithTitle:@"绑 定 微 信"];
            break;
        case SINA_LOGIN_TYPE:
             loginBtn = [[ESRedButton alloc] initWithTitle:@"绑 定 微 博"];
            break;
    }
    loginBtn.enabled = NO;
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(connectUserView.mas_bottom).offset(10);
        make.height.equalTo(@100);
    }];
    
    //账号
    ESLabel *accountLbl = [[ESLabel alloc] initWithText:@"账号" textColor:[UIColor darkGrayColor] fontSize:14];
    [loginView addSubview:accountLbl];
    [accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView).offset(20);
        make.top.equalTo(loginView).offset(22);
    }];
    
    accountTf = [UITextField new];
    accountTf.font = [UIFont systemFontOfSize:14];
    accountTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
    accountTf.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"用户名/邮箱/手机号"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                                 NSFontAttributeName: [UIFont systemFontOfSize:13]
                                                 }
     ];
    [accountTf addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [loginView addSubview:accountTf];
    [accountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view);
        make.centerY.equalTo(accountLbl);
        make.height.equalTo(@20);
    }];
    
    //密码
    ESLabel *passwordLbl = [[ESLabel alloc] initWithText:@"密码" textColor:[UIColor darkGrayColor] fontSize:14];
    [loginView addSubview:passwordLbl];
    [passwordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLbl);
        make.top.equalTo(accountLbl.mas_bottom).offset(27);
    }];
    
    passwordTf = [UITextField new];
    passwordTf.font = [UIFont systemFontOfSize:14];
    passwordTf.secureTextEntry = YES;
    passwordTf.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"请输入密码"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                                 NSFontAttributeName: [UIFont systemFontOfSize:13]
                                                 }
     ];
    [passwordTf addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [loginView addSubview:passwordTf];
    [passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(accountTf);
        make.centerY.equalTo(passwordLbl);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(accountTf);
        make.centerY.equalTo(loginView);
        make.height.equalTo(@0.5f);
    }];
}

//点击键盘上的Return按钮响应的方法
- (IBAction)returnOnKeyboard:(UITextField *)sender {
    if (sender == accountTf) {
        [passwordTf becomeFirstResponder];
    } else if (sender == passwordTf) {
        [self hidenKeyboard];
        [self login];
    }
}

//隐藏键盘的方法
- (void)hidenKeyboard {
    [accountTf resignFirstResponder];
    [passwordTf resignFirstResponder];
}

/**
 * 取消
 */
- (IBAction)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 登录
 */
- (IBAction)login {
    if (accountTf.text.length == 0) {
        [ToastUtils show:@"用户名不能为空！"];
        return;
    }
    if (passwordTf.text.length == 0) {
        [ToastUtils show:@"密码不能为空！"];
        return;
    }
    
    [ToastUtils showLoading:@"绑定中..."];
    MemberApi *memberApi = [MemberApi new];
    [memberApi mLoginBind:[Utils intToString:connectType] openid:openid username:accountTf.text password:passwordTf.text success:^(Member *member) {
            [ToastUtils hideLoading];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:member] forKey:kCurrentMemberKey];
            [defaults synchronize];
            [Constants setMember:member];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:nLogin object:nil];
            
            [ToastUtils show:@"绑定成功！"];
            
            //登录环信
            [self loginIM:member.imUser pass:member.imPass];
            
            [self dismissViewControllerAnimated:YES completion:nil];

    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:error.localizedDescription];

    }];
    
    
}

-(UIView *) createConnectUserView:(NSString *)userFace userType:(NSInteger)userType {
    UIView *connectUserBack = [UIView new];
    connectUserBack.backgroundColor = [UIColor whiteColor];
    ESButton *userFaceView = [ESButton new];
    [userFaceView borderWidth:1 color:[UIColor blackColor] cornerRadius:kScreen_Height/30-5];
    [connectUserBack addSubview:userFaceView];
    [userFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(connectUserBack.mas_height).mas_offset(-10);
        make.centerY.equalTo(connectUserBack);
        make.left.equalTo(connectUserBack).mas_offset(kScreen_Width/15);
    }];
    [userFaceView sd_setImageWithURL:userFace forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_empty"]];
    UIButton *backBtn =[UIButton new];
    [connectUserBack addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(connectUserBack.mas_height);
                make.centerY.equalTo(connectUserBack);
                make.right.equalTo(connectUserBack).mas_offset(-kScreen_Width/15);
    }];
    ESLabel *nikenamelb;
    switch (userType) {
        case QQ_LOGIN_TYPE:
            [backBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
            nikenamelb = [[ESLabel alloc] initWithText:[NSString stringWithFormat:@"QQ账户：%@",nikename] textColor:[UIColor darkGrayColor] fontSize:14];
            break;
        case WECHAT_LOGIN_TYPE:
            [backBtn setImage:[UIImage imageNamed:@"wechatlogin"] forState:UIControlStateNormal];
            nikenamelb = [[ESLabel alloc] initWithText:[NSString stringWithFormat:@"微信账户：%@",nikename] textColor:[UIColor darkGrayColor] fontSize:14];
            break;
        case SINA_LOGIN_TYPE:
            [backBtn setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
            nikenamelb = [[ESLabel alloc] initWithText:[NSString stringWithFormat:@"微博账户：%@",nikename] textColor:[UIColor darkGrayColor] fontSize:14];
            break;
    }
    [connectUserBack addSubview:nikenamelb];
    [nikenamelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(connectUserBack);
        make.left.equalTo(userFaceView.mas_right).mas_offset(10);
        make.right.equalTo(backBtn.mas_left);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [connectUserBack addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(connectUserBack);
        make.bottom.equalTo(connectUserBack);
        make.height.equalTo(@0.5f);
    }];
    return connectUserBack;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
