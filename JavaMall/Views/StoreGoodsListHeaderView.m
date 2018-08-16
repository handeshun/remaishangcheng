//
// Created by Dawei on 3/18/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreGoodsListHeaderView.h"
#import "Masonry.h"
#import "ESTextField.h"
#import "ToastUtils.h"
#import "ESButton.h"
#import "MaskDelegate.h"
#import "SearchDelegate.h"

@implementation StoreGoodsListHeaderView {
    UIButton *backBtn;
    ListStyle listStyle;
    UIView *searchView;
    ESTextField *keywordTf;

    ESButton *cancelBtn;
}

@synthesize maskDelegate, searchDelegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self createUI];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}


- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];

    //后退按钮
    backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(-5);
        make.top.equalTo(self).with.offset(21);
        make.size.mas_equalTo(CGSizeMake(64, 40));
    }];

    cancelBtn = [[ESButton alloc] initWithTitle:@"取消" color:[UIColor darkGrayColor] fontSize:14];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setHidden:YES];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self);
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
        make.top.equalTo(self.mas_top).with.offset(28);
        make.left.equalTo(backBtn.mas_right).offset(-25);
        make.height.equalTo(@26);
        make.right.equalTo(self).offset(-10);
    }];

    //搜索框图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_search"]];
    [searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchView.mas_left).with.offset(8);
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

#pragma textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [keywordTf resignFirstResponder];
    if(searchDelegate != nil){
        [searchDelegate search:textField.text searchType:0];
    }
    return YES;
}

/**
 * 设置后退事件
 */
- (void)setBackAction:(SEL)action {
    [backBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
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
    [searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(28);
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@26);
        make.right.equalTo(cancelBtn.mas_left).offset(-5);
    }];
    if(maskDelegate != nil){
        [maskDelegate showMask];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [cancelBtn setHidden:YES];
    [backBtn setHidden:NO];
    [searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(28);
        make.left.equalTo(backBtn.mas_right).offset(-25);
        make.height.equalTo(@26);
        make.right.equalTo(self).offset(-10);
    }];
    if(maskDelegate != nil){
        [maskDelegate hideMask];
    }
}
@end