//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "FindPassViewController2.h"
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
#import "FindPassViewController3.h"


@implementation FindPassViewController2 {
    HeaderView *headerView;
    TPKeyboardAvoidingScrollView *contentView;

    ESTextField *mobileCodeTf;
    ESRedButton *nextBtn;
    ESRedButton *resendBtn;
    ESLabel *tipsLbl;

    MemberApi *memberApi;
}

@synthesize mobile;

- (void)viewDidLoad {
    [super viewDidLoad];
    memberApi = [MemberApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"找回密码"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self createUI];

    //监测只有用户名和密码都不为空时才可以点击登录按钮
    RAC(nextBtn, enabled) = [RACSignal combineLatest:@[mobileCodeTf.rac_textSignal]
                                              reduce:^id(NSString *mobile) {
                                                  return @(mobile.length > 0);
                                              }];

    [self startTimer];
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

    tipsLbl = [[ESLabel alloc] initWithText:[NSString stringWithFormat:@"短信已发送至 %@", mobile] textColor:[UIColor darkGrayColor] fontSize:12];
    [contentView addSubview:tipsLbl];
    [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(contentView).offset(10);
    }];

    resendBtn = [[ESRedButton alloc] initWithTitle:@"60秒后重发"];
    [resendBtn setFont:[UIFont systemFontOfSize:14]];
    [resendBtn addTarget:self action:@selector(resend:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:resendBtn];
    [resendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(tipsLbl.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];

    mobileCodeTf = [ESTextField new];
    mobileCodeTf.backgroundColor = [UIColor whiteColor];
    mobileCodeTf.font = [UIFont systemFontOfSize:14];
    mobileCodeTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
    mobileCodeTf.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"请输入您手机收到的验证码"
                                            attributes:@{
                                                    NSForegroundColorAttributeName : [UIColor grayColor],
                                                    NSFontAttributeName : [UIFont systemFontOfSize:14]
                                            }
            ];
    mobileCodeTf.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:mobileCodeTf];
    [mobileCodeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(resendBtn.mas_left).offset(-10);
        make.top.equalTo(resendBtn);
        make.height.equalTo(@40);
    }];

    //下一步按钮
    nextBtn = [[ESRedButton alloc] initWithTitle:@"下一步"];
    nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(mobileCodeTf.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];
}

//启动按钮倒计时
- (void)startTimer {
    resendBtn.enabled = NO;
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [resendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                resendBtn.enabled = YES;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                resendBtn.titleLabel.text = [NSString stringWithFormat:@"%d秒后重发", timeout];
                [resendBtn setTitle:[NSString stringWithFormat:@"%d秒后重发", timeout] forState:UIControlStateDisabled];
            });
            timeout--;
        }

    });
    dispatch_resume(_timer);
}

/**
 * 重新发送验证码
 */
- (IBAction)resend:(ESRedButton *)sender {
    if(mobile.length == 0 || ![mobile isMobile]){
        [ToastUtils show:@"请输入正确的手机号码!"];
        return;
    }
    [ToastUtils showLoading:@"正在发送手机验证码!"];
    [memberApi sendFindCode:mobile success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"验证码已发送到您的手机!"];
        [self startTimer];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 下一步
 */
- (IBAction)next:(ESRedButton *)sender {
    if (mobileCodeTf.text.length == 0) {
        [ToastUtils show:@"请输入您手机收到的验证码!"];
        return;
    }
    [ToastUtils showLoading];
    [memberApi validMobileCode:mobile mobileCode:mobileCodeTf.text success:^{
        [ToastUtils hideLoading];

        FindPassViewController3 *findPassViewController3 = [FindPassViewController3 new];
        findPassViewController3.mobile = mobile;
        findPassViewController3.mobileCode = mobileCodeTf.text;
        [self.navigationController pushViewController:findPassViewController3 animated:YES];

    }               failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 后退
 */
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end