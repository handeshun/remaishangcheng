//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Masonry.h"
#import "StoreHeaderView.h"
#import "ESButton.h"
#import "MaskDelegate.h"
#import "SearchDelegate.h"
#import "ESTextField.h"


@implementation StoreHeaderView {
    ESButton *backBtn;
    UIView *searchView;
    ESButton *categoryBtn;

    ESTextField *keywordTf;
    ESButton *cancelBtn;
}

@synthesize maskDelegate, searchDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kScreen_Width, 60)];
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

/**
 * 创建界面
 */
- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];

    //后退
    backBtn = [[ESButton alloc] initWithFrame:CGRectMake(2, 18, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [self addSubview:backBtn];

    //分类按钮
    categoryBtn = [ESButton new];
    [categoryBtn setImage:[UIImage imageNamed:@"store_category.png"] forState:UIControlStateNormal];
    [self addSubview:categoryBtn];
    [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-3);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 33));
    }];

    cancelBtn = [[ESButton alloc] initWithTitle:@"取消" color:[UIColor darkGrayColor] fontSize:14];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setHidden:YES];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@40);
    }];

    //搜索框
    searchView = [UIView new];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.borderColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    searchView.layer.borderWidth = 0.5;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 3.0;
    [self addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(25);
        make.left.equalTo(backBtn.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.right.equalTo(categoryBtn.mas_left).with.offset(-10);
    }];


    //搜索框图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_search"]];
    [searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchView.mas_left).offset(8);
        make.width.height.equalTo(@15);
    }];

    keywordTf = [ESTextField new];
    keywordTf.font = [UIFont systemFontOfSize:12];
    keywordTf.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"搜索店铺内商品"
                                            attributes:@{
                                                    NSForegroundColorAttributeName: [UIColor grayColor],
                                                    NSFontAttributeName: [UIFont systemFontOfSize:12]
                                            }
            ];
    keywordTf.delegate = self;
    keywordTf.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:keywordTf];
    [keywordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(searchView);
        make.left.equalTo(searchIcon.mas_right).offset(5);
    }];
}

/**
 * 设置后退事件
 */
- (void)setBackAction:(SEL)action {
    [backBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

/**
 * 设置分类事件
 */
- (void)setCategoryAction:(SEL)action {
    [categoryBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [keywordTf resignFirstResponder];
    if (searchDelegate != nil) {
        [searchDelegate search:textField.text searchType:0];
    }
    return YES;
}

/**
 * 取消
 */
- (IBAction)cancel {
    [keywordTf setText:@""];
    [keywordTf resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [cancelBtn setHidden:NO];
    [backBtn setHidden:YES];
    [categoryBtn setHidden:YES];
    [searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(28);
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@26);
        make.right.equalTo(cancelBtn.mas_left).offset(-5);
    }];
    if (maskDelegate != nil) {
        [maskDelegate showMask];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [cancelBtn setHidden:YES];
    [backBtn setHidden:NO];
    [categoryBtn setHidden:NO];
    [searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(25);
        make.left.equalTo(backBtn.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.right.equalTo(categoryBtn.mas_left).with.offset(-10);
    }];
    if (maskDelegate != nil) {
        [maskDelegate hideMask];
    }
}


@end