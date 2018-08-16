//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FindPassViewController1.h"
#import "MemberApi.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "HeaderView.h"
#import "ESRedButton.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "ESTextField.h"
#import "NSString+Common.h"
#import "ToastUtils.h"
#import "FindPassViewController2.h"


@implementation FindPassViewController1 {
    HeaderView *headerView;
    TPKeyboardAvoidingScrollView *contentView;

    ESTextField *mobileTf;
    ESRedButton *nextBtn;

    MemberApi *memberApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    memberApi = [MemberApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"找回密码"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self createUI];

    //监测只有用户名和密码都不为空时才可以点击登录按钮
    RAC(nextBtn, enabled) = [RACSignal combineLatest:@[mobileTf.rac_textSignal]
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

    mobileTf = [ESTextField new];
    mobileTf.backgroundColor = [UIColor whiteColor];
    mobileTf.font = [UIFont systemFontOfSize:14];
    mobileTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
    mobileTf.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                            attributes:@{
                                                    NSForegroundColorAttributeName : [UIColor grayColor],
                                                    NSFontAttributeName : [UIFont systemFontOfSize:14]
                                            }
            ];
    mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    [mobileTf borderWidth:0.5f color:[UIColor colorWithHexString:@"#CCCCCC"] cornerRadius:4];
    [contentView addSubview:mobileTf];
    [mobileTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(contentView).offset(15);
        make.height.equalTo(@40);
    }];

    //注册按钮
    nextBtn = [[ESRedButton alloc] initWithTitle:@"下一步"];
    nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(mobileTf.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];
}

/**
 * 下一步
 */
- (IBAction)next:(ESRedButton *)sender {
    if(mobileTf.text.length == 0 || ![mobileTf.text isMobile]){
        [ToastUtils show:@"请输入正确的手机号码!"];
        return;
    }
    [ToastUtils showLoading:@"正在发送手机验证码!"];
    [memberApi sendFindCode:mobileTf.text success:^{
        [ToastUtils hideLoading];

        FindPassViewController2 *findPassViewController2 = [FindPassViewController2 new];
        findPassViewController2.mobile = mobileTf.text;
        [self.navigationController pushViewController:findPassViewController2 animated:YES];

    } failure:^(NSError *error) {
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