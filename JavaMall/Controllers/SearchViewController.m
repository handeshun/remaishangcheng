//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SearchViewController.h"
#import "ESTextField.h"
#import "ESButton.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "SearchHistoryCell.h"
#import "SearchClearCell.h"
#import "SearchDelegate.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ToastUtils.h"
#import "SystemApi.h"

@implementation SearchViewController {
    UIView *headerView;
    UIView *searchView;
    ESTextField *keywordTf;
    ESButton *cancelBtn;

    ESButton *searchTypeBtn;

    UIScrollView *hotSearchView;

    TPKeyboardAvoidingTableView *historyTable;

    NSMutableArray *historyArray;
    SystemApi *systemApi;

    NSArray *menuArray;
    DropMenuView *dropMenuView;

    NSInteger searchType;
}

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fefefe"];
    historyArray = [NSMutableArray arrayWithCapacity:0];
    systemApi = [SystemApi new];
    searchType = 0;

    menuArray = @[@{@"imageName": @"search_menu_goods", @"title": @"商品"}, @{@"imageName": @"search_menu_store", @"title": @"店铺"}];
    dropMenuView = [[DropMenuView alloc] initWithFrame:CGRectMake(10, 45, 100, 44*2+12)];
    dropMenuView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self setupHeader];
    [self setupHotSearch];
    [self setupHistory];
    [self loadData];

}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 * 创建搜索栏
 */
- (void)setupHeader {
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self.view addSubview:headerView];

    cancelBtn = [[ESButton alloc] initWithTitle:@"取消" color:[UIColor darkGrayColor] fontSize:14];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-5);
        make.bottom.equalTo(headerView).offset(-5);
        make.width.equalTo(@40);
    }];

    //搜索框
    searchView = [UIView new];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.borderColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    searchView.layer.borderWidth = 0.5;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 3.0;
    [headerView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).with.offset(25);
        make.left.equalTo(headerView).with.offset(5);
        make.bottom.equalTo(headerView).with.offset(-5);
        make.right.equalTo(cancelBtn.mas_left).with.offset(-5);
    }];

    //搜索类型
    searchTypeBtn = [[ESButton alloc] initWithTitle:@"商品" color:[UIColor colorWithHexString:@"#666666"] fontSize:14];
    [searchTypeBtn setImage:[UIImage imageNamed:@"down_arrow.png"] forState:UIControlStateNormal];
    [searchTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
    [searchTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 33, 0, -33)];
    [searchTypeBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchTypeBtn];
    [searchTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchView).with.offset(5);
        make.width.equalTo(@40);
    }];

    keywordTf = [ESTextField new];
    NSMutableParagraphStyle *style = [keywordTf.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = keywordTf.font.lineHeight - (keywordTf.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    keywordTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入您要搜索的商品/店铺名称"
                                                                      attributes:@{
                                                                              NSForegroundColorAttributeName: [UIColor grayColor],
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                                                              NSParagraphStyleAttributeName: style

                                                                      }
    ];
    keywordTf.delegate = self;
    keywordTf.returnKeyType = UIReturnKeySearch;

    [searchView addSubview:keywordTf];
    [keywordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(searchView);
        make.left.equalTo(searchTypeBtn.mas_right).offset(5);
        make.right.equalTo(searchView);
    }];

    //添加下划线
    float lineHeight = 0.5f;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, headerView.frame.size.height - lineHeight, headerView.frame.size.width, lineHeight);
    layer.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"].CGColor;
    [headerView.layer addSublayer:layer];

}

/**
 * 创建热搜视图
 */
- (void)setupHotSearch {
    hotSearchView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, kScreen_Width, 55)];
    hotSearchView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [hotSearchView bottomBorder:[UIColor colorWithHexString:@"#cdcdcd"]];
    [self.view addSubview:hotSearchView];

    ESLabel *hotSearchTitleLbl = [[ESLabel alloc] initWithText:@"热搜" textColor:[UIColor darkGrayColor] fontSize:14];
    [hotSearchView addSubview:hotSearchTitleLbl];
    [hotSearchTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotSearchView).offset(10);
        make.centerY.equalTo(hotSearchView);
    }];

}

/**
 * 创建搜索历史视图
 */
- (void)setupHistory {
    historyTable = [TPKeyboardAvoidingTableView new];
    historyTable.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    historyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [historyTable registerClass:[SearchHistoryCell class] forCellReuseIdentifier:kCellIdentifier_SearchHistoryCell];
    [historyTable registerClass:[SearchClearCell class] forCellReuseIdentifier:kCellIdentifier_SearchClearCell];
    historyTable.dataSource = self;
    historyTable.delegate = self;
    [self.view addSubview:historyTable];

    [historyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotSearchView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

/*
 * 载入历史记录
 */
- (void)loadData {
    [historyArray removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *historySize = [defaults objectForKey:@"history_size"];
    if (historySize == nil) {
        return;
    }
    for (int i = 0; i < [historySize intValue]; i++) {
        if ([defaults objectForKey:[NSString stringWithFormat:@"history_%d", i]] != nil) {
            [historyArray addObject:[defaults objectForKey:[NSString stringWithFormat:@"history_%d", i]]];
        }
    }
    [historyTable reloadData];

    [systemApi hotKeyword:^(NSMutableArray *keywordArray) {
        float offset = 45;

        for (int i = 0; i < keywordArray.count; i++) {
            ESButton *keywordBtn = [[ESButton alloc] initWithTitle:[keywordArray objectAtIndex:i] color:[UIColor darkGrayColor] fontSize:12];
            float buttonWidth = [keywordBtn.titleLabel.text getSizeWithFont:[UIFont systemFontOfSize:12]].width;
            keywordBtn.backgroundColor = [UIColor whiteColor];
            [keywordBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#d8d8d8"] cornerRadius:10];
            [keywordBtn addTarget:self action:@selector(searchHot:) forControlEvents:UIControlEventTouchUpInside];
            [hotSearchView addSubview:keywordBtn];
            [keywordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(hotSearchView).offset(offset);
                make.centerY.equalTo(hotSearchView);
                make.width.equalTo(@(buttonWidth + 10));
            }];
            offset += buttonWidth + 20;
        }

        hotSearchView.contentSize = CGSizeMake(offset, 55);
    }             failure:^(NSError *error) {

    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    }
    return 70;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return historyArray.count;
    }
    return 1;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchHistoryCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:[historyArray objectAtIndex:indexPath.row]];
        return cell;
    }
    SearchClearCell *clearCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchClearCell forIndexPath:indexPath];
    clearCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [clearCell.clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    return clearCell;
}

/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 35;
    }
    return 0.01f;
}

/**
 * 每个区的尾部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

/**
 * 每个区的头部视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [UIView new];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 35)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];

    UIView *headerLine = [UIView new];
    headerLine.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [view addSubview:headerLine];
    [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.equalTo(@0.5f);
    }];

    UIView *footerLine = [UIView new];
    footerLine.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [view addSubview:footerLine];
    [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(headerLine);
    }];

    ESLabel *titleLbl = [[ESLabel alloc] initWithText:@"历史搜索" textColor:[UIColor blackColor] fontSize:12];
    titleLbl.font = [UIFont boldSystemFontOfSize:12];
    [view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
    }];

    return view;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *historyKeyword = [historyArray objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:NO completion:^{
        [delegate search:historyKeyword searchType:searchType];
    }];
}

#pragma textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        [ToastUtils show:@"请输入您要搜索的商品名称!"];
        return NO;
    }
    [self search];
    return YES;
}

/**
 * 点击空白处隐藏键盘
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [keywordTf resignFirstResponder];
}

/**
 * 清空历史搜索
 */
- (IBAction)clear:(ESButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *historySize = [defaults objectForKey:@"history_size"];
    if (historySize == nil) {
        return;
    }
    for (int i = 0; i < [historySize intValue]; i++) {
        [defaults removeObjectForKey:[NSString stringWithFormat:@"history_%d", i]];
    }
    [defaults setObject:@"0" forKey:@"history_size"];
    [defaults synchronize];
    [self loadData];
}

/**
 * 搜索
 */
- (IBAction)search {
    //保存历史
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *historySize = [defaults objectForKey:@"history_size"];
    if (historySize == nil) {
        historySize = @"0";
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[historySize intValue]];
    for (int i = 0; i < [historySize intValue]; i++) {
        if ([defaults objectForKey:[NSString stringWithFormat:@"history_%d", i]] != nil) {
            if (tempArray.count < 9) {
                [tempArray addObject:[defaults objectForKey:[NSString stringWithFormat:@"history_%d", i]]];
            }
            [defaults removeObjectForKey:[NSString stringWithFormat:@"history_%d", i]];
        }
    }
    [tempArray insertObject:keywordTf.text atIndex:0];
    for (int i = 0; i < tempArray.count; i++) {
        [defaults setObject:[tempArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"history_%d", i]];
    }
    [defaults setObject:[NSString stringWithFormat:@"%d", (int) tempArray.count] forKey:@"history_size"];
    [defaults synchronize];

    [self dismissViewControllerAnimated:NO completion:^{
        [delegate search:keywordTf.text searchType:searchType];
    }];
}

- (IBAction)searchHot:(ESButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [delegate search:sender.titleLabel.text searchType:searchType];
    }];
}

- (IBAction)cancel {
    [keywordTf resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;

    [historyTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotSearchView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top).offset(keyboardTop);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [historyTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotSearchView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

/**
 * 显示菜单
 */
- (IBAction)showMenu {
    [dropMenuView showViewInView:self.view];
}

#pragma mark - JSDropmenuViewDelegate

- (NSArray *)dropmenuDataSource {
    return menuArray;
}

- (void)dropmenuView:(DropMenuView *)dropmenuView didSelectedRow:(NSInteger)index {
    if (index >= menuArray.count) {
        return;
    }
    NSDictionary *itemDic = [menuArray objectAtIndex:index];
    [searchTypeBtn setTitle:[itemDic objectForKey:@"title"]];
    searchType = index;
}

@end