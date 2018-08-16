//
// Created by Dawei on 5/14/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Masonry.h"
#import "UIView+Common.h"
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
#import "MagicDialog.h"
#import "ConnectLoginBindController.h"
#import "ConnectRegisterBindController.h"
@implementation LoginViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingScrollView *contentView;
    UIImageView *headerImageView;
    UIView *loginView;
    UITextField *accountTf;
    UITextField *passwordTf;
    UIImageView *imageView;
    UITextField *verTf;
    ESRedButton *loginBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    headerView = [[HeaderView alloc] initWithTitle:@"登录"];
    [headerView setCancelAction:@selector(cancel)];
    [self.view addSubview:headerView];

    [self createUI];

    //监测只有用户名和密码都不为空时才可以点击登录按钮
    RAC(loginBtn, enabled) = [RACSignal combineLatest:@[accountTf.rac_textSignal, passwordTf.rac_textSignal] reduce:^id(NSString *account, NSString *password) {
        return @(account.length > 0 && password.length > 0);
    }];
}
- (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
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

    //Banner图

    
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 110)];
    [headerImageView setImage:[UIImage imageNamed:@"login_head.jpg"]];
    headerImageView.backgroundColor = [UIColor greenColor];
    [contentView addSubview:headerImageView];
    
    BOOL isipad = [self getIsIpad];
    
    if(isipad==YES){
        headerImageView.frame = CGRectMake(0, 0, kScreen_Width, 0);
    }
    //登录框
    [self createLoginView];

    //登录按钮
    loginBtn = [[ESRedButton alloc] initWithTitle:@"登录"];
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

    //注册
    ESButton *registerBtn = [[ESButton alloc] initWithTitle:@"快速注册" color:[UIColor darkGrayColor] fontSize:13];
    [registerBtn addTarget:self action:@selector(register) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(15);
        make.left.equalTo(loginBtn);
    }];

    //找回密码
    ESButton *forgetBtn = [[ESButton alloc] initWithTitle:@"找回密码" color:[UIColor darkGrayColor] fontSize:13];
    [forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerBtn);
        make.right.equalTo(loginBtn);
    }];
    
//    UIView *otherloginHint = [UIView new];
//    [contentView addSubview:otherloginHint];
//    [otherloginHint mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScreen_Height/20));
//        make.top.equalTo(forgetBtn.mas_bottom).offset(kScreen_Height/20);
//    }];
//    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor grayColor];
//    [otherloginHint addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(otherloginHint).offset(-kScreen_Width*0.2);
//        make.height.equalTo(@1);
//        make.center.equalTo(otherloginHint);
//    }];
//    ESLabel *otherLoginTextView = [[ESLabel alloc] initWithText:@"   其他方式登录   " textColor:[UIColor darkGrayColor] fontSize:14];
//    otherLoginTextView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    [otherloginHint addSubview:otherLoginTextView];
//    [otherLoginTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.center.equalTo(otherloginHint);
//    }];
//    
//    UIView *otherLoginView = [self createConnectView];
//    [contentView addSubview:otherLoginView];
//    [otherLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(otherloginHint).offset(kScreen_Height/20);
//        make.centerX.equalTo(contentView);
//        make.size.mas_equalTo(CGSizeMake(kScreen_Width/2,kScreen_Height/50*5));
//    }];
    //第三方登录框
//    UIView *otherLoginView = [UIView new];
//    otherLoginView.backgroundColor = [UIColor whiteColor];
//    [contentView addSubview:otherLoginView];
//    [otherLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(@45);
//        make.bottom.equalTo(self.view);
//    }];

    //QQ登录

    //微信登录


    [self.view layoutIfNeeded];
    [loginView topBorder:[UIColor colorWithHexString:kBorderLineColor]];
    [loginView bottomBorder:[UIColor colorWithHexString:kBorderLineColor]];
}

-(UIView *) createConnectView{
    UIView *connectView = [UIView new];
    UIView      *qqPraent =        [UIControl new];
    UIView      *wechatPraent =    [UIControl new];
    UIView      *weiboPraent =     [UIControl new];
    UIImageView *qqImageview=      [UIImageView new];
    UIImageView *wechatImageview=  [UIImageView new];
    UIImageView *weiboImageview=   [UIImageView new];
    ESLabel *qqlable = [[ESLabel alloc] initWithText:@"QQ" textColor:[UIColor darkGrayColor] fontSize:14];
    qqlable.textAlignment = NSTextAlignmentCenter;
    ESLabel *wechatlable = [[ESLabel alloc] initWithText:@"微信" textColor:[UIColor darkGrayColor] fontSize:14];
    wechatlable.textAlignment = NSTextAlignmentCenter;
    ESLabel *weibolable = [[ESLabel alloc] initWithText:@"微博" textColor:[UIColor darkGrayColor] fontSize:14];
    weibolable.textAlignment = NSTextAlignmentCenter;
    UIImage     *qqImage = [UIImage imageNamed:@"qq.png"];
    UIImage     *wechatImage = [UIImage imageNamed:@"wechatlogin.png"];
    UIImage     *weiboImage = [UIImage imageNamed:@"weibo.png"];
    [qqImageview setImage:qqImage];
    [wechatImageview setImage:wechatImage];
    [weiboImageview setImage:weiboImage];
    [(UIControl *)qqPraent addTarget:self action:@selector(getAuthWithUserInfoFromQQ) forControlEvents:UIControlEventTouchUpInside ];
    [connectView addSubview:qqPraent];
    [qqPraent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(connectView.mas_height);
        make.width.mas_equalTo(kScreen_Width/2/3);
        make.left.top.bottom.equalTo(connectView);
    }];
    [(UIControl *)wechatPraent addTarget:self action:@selector(getAuthWithUserInfoFromWechat) forControlEvents:UIControlEventTouchUpInside ];
    [connectView addSubview:wechatPraent];
    [wechatPraent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(connectView.mas_height);
        make.width.mas_equalTo(kScreen_Width/2/3);
        make.top.bottom.equalTo(connectView);
        make.left.equalTo(qqPraent.mas_right);
    }];
    [(UIControl *)weiboPraent addTarget:self action:@selector(getAuthWithUserInfoFromSina) forControlEvents:UIControlEventTouchUpInside ];
    [connectView addSubview:weiboPraent];
    [weiboPraent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(connectView.mas_height);
       make.width.mas_equalTo(kScreen_Width/2/3);
        make.top.bottom.equalTo(connectView);
        make.left.equalTo(wechatPraent.mas_right);
    }];
    
    [qqPraent addSubview:qqlable];
    [qqlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(qqPraent);
        make.height.mas_equalTo(kScreen_Height/10/5);
    }];
    [qqPraent addSubview:qqImageview];
    [qqImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqPraent).offset(kScreen_Height/10/5/2.5);
        make.left.equalTo(qqPraent).offset(kScreen_Height/10/5/2);
        make.right.equalTo(qqPraent).offset(-kScreen_Height/10/5/2);
        make.bottom.equalTo(qqlable.mas_top);
    }];
    [wechatPraent addSubview:wechatlable];
    [wechatlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(wechatPraent);
         make.height.mas_equalTo(kScreen_Height/10/5);
    }];
    [wechatPraent addSubview:wechatImageview];
    [wechatImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wechatPraent).offset(kScreen_Height/10/5/2.5);
        make.left.equalTo(wechatPraent).offset(kScreen_Height/10/5/2);
        make.right.equalTo(wechatPraent).offset(-kScreen_Height/10/5/2);
        make.bottom.equalTo(wechatlable.mas_top);
    }];
    
    [weiboPraent addSubview:weibolable];
    [weibolable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weiboPraent);
         make.height.mas_equalTo(kScreen_Height/10/5);
    }];
    [weiboPraent addSubview:weiboImageview];
    [weiboImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weiboPraent).offset(kScreen_Height/10/5/2.5);
        make.left.equalTo(weiboPraent).offset(kScreen_Height/10/5/2);
        make.right.equalTo(weiboPraent).offset(-kScreen_Height/10/5/2);
        make.bottom.equalTo(weibolable.mas_top);
    }];
    
    return connectView;
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
        make.top.equalTo(headerImageView.mas_bottom).offset(10);
        make.height.equalTo(@150);
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
    imageView = [UIImageView new];
    ESLabel *verCodeTitle = [[ESLabel alloc] initWithText:@"验证码" textColor:[UIColor darkGrayColor] fontSize:14];
    [loginView addSubview:verCodeTitle];
    [verCodeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView).offset(20);
        make.top.equalTo(passwordLbl.mas_bottom).offset(21);
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
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(accountTf);
        make.top.equalTo(accountLbl.mas_bottom).offset(2);
        make.height.equalTo(@0.5f);
    }];
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(passwordTf);
        make.top.equalTo(passwordTf.mas_bottom).offset(2);
        make.height.equalTo(@1);
    }];
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
        make.left.equalTo(accountTf).offset(10);
        make.centerY.equalTo(verCodeTitle);
    }];
    
    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [loginView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(passwordTf);
        make.top.equalTo(imageView.mas_bottom).offset(2);
        make.height.equalTo(@1);
    }];
    [[MemberApi new]loadLoginImage:imageView];
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
    if (verTf.text.length==0) {
        [ToastUtils show:@"验证码不能为空！"];
    }
    [ToastUtils showLoading:@"登录中..."];
    MemberApi *memberApi = [MemberApi new];
    [memberApi login:accountTf.text password:passwordTf.text vcode:verTf.text success:^(Member *member) {
        [ToastUtils hideLoading];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:member] forKey:kCurrentMemberKey];
        [defaults synchronize];
        [Constants setMember:member];

        [[NSNotificationCenter defaultCenter] postNotificationName:nLogin object:nil];

        [ToastUtils show:@"登录成功！"];

        //登录环信
        [self loginIM:member.imUser pass:member.imPass];

        [self dismissViewControllerAnimated:YES completion:nil];

    }        failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:error.localizedDescription];
    }];
}

/**
 * 注册
 */
- (IBAction)register {
    if (MOBILE_VALIDATION) {
        MobileRegisterViewController1 *mobileRegisterViewController1 = [MobileRegisterViewController1 new];
        [self.navigationController pushViewController:mobileRegisterViewController1 animated:YES];
        return;
    }
    RegisterViewController *registerViewController = [RegisterViewController new];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

/**
 * 忘记密码
 */
- (IBAction)forgetPassword {
    FindPassViewController1 *findPassViewController1 = [FindPassViewController1 new];
    [self.navigationController pushViewController:findPassViewController1 animated:YES];
}


- (void)getAuthWithUserInfoFromSina
{
    [self connectLoginMethod:SINA_LOGIN_TYPE umType:UMSocialPlatformType_Sina];
}
- (void)getAuthWithUserInfoFromQQ
{
    [self connectLoginMethod:QQ_LOGIN_TYPE umType:UMSocialPlatformType_QQ];
}
- (void)getAuthWithUserInfoFromWechat
{
    [self connectLoginMethod:WECHAT_LOGIN_TYPE umType:UMSocialPlatformType_WechatSession];
}

-(void) connectLoginMethod: (NSInteger)loginType umType:(UMSocialPlatformType)umType{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:umType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [ToastUtils show:@"第三方取消！"];
        } else {
            UMSocialUserInfoResponse *resp = result;
            [self connectUtils:loginType data:resp];
        }
    }];
}

-(void) connectUtils: (NSInteger)type data:(UMSocialUserInfoResponse*)data{
    [ToastUtils showLoading:@"登录中..."];
    MemberApi *memberApi = [MemberApi new];
    [memberApi mLogin:[Utils intToString:type] openid:data.uid success:^(Member *member) {
        [ToastUtils hideLoading];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:member] forKey:kCurrentMemberKey];
        [defaults synchronize];
        [Constants setMember:member];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:nLogin object:nil];
        
        [ToastUtils show:@"登录成功！"];
        
        //登录环信
        [self loginIM:member.imUser pass:member.imPass];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
         [ToastUtils hideLoading];
        if ([error.localizedDescription isEqualToString:@"NetError"]) {
            [ToastUtils show:@"服务器连接失败！"];
            return;
        }
        MagicDialog *dialog = [MagicDialog initWithOrdinary:self title:@"尚未绑定平台账号！" yesHint:@"绑定账号" noHint:@"注册账号" success:^{
            ConnectLoginBindController *connectLoginBindCtr = [ConnectLoginBindController new];
            connectLoginBindCtr.connectType=type;
            connectLoginBindCtr.nikename=data.name;
            connectLoginBindCtr.face=data.iconurl;
            connectLoginBindCtr.openid =data.uid;
            [self.navigationController pushViewController:connectLoginBindCtr animated:YES];
        } failure:^{
            ConnectRegisterBindController *connectRegisterBindCtr = [ConnectRegisterBindController new];
            connectRegisterBindCtr.connectType=type;
            connectRegisterBindCtr.nikename=data.name;
            connectRegisterBindCtr.face=data.iconurl;
            connectRegisterBindCtr.openid =data.uid;
            [self.navigationController pushViewController:connectRegisterBindCtr animated:YES];
        }];
        dialog.showDialog;
    }];
}



/**
 *更新登录验证码
 */
-(IBAction)updataImageView{
    [[MemberApi new]loadLoginImage:imageView];
}
@end
