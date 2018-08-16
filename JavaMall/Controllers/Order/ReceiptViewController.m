//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReceiptViewController.h"
#import "HeaderView.h"
#import "ESRedButton.h"
#import "Masonry.h"
#import "ReceiptTitleCell.h"
#import "ReceiptContentCell.h"
#import "Receipt.h"
#import "ReceiptModel.h"
#import "ESRadioButton.h"
#import "OrderApi.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ToastUtils.h"
#import "ReceiptCellCollectionViewCell.h"

@implementation ReceiptViewController {
    HeaderView *headerView;
    NSMutableArray   *receiptList;
    TPKeyboardAvoidingTableView *myTable;
    ESRedButton *createBtn;
    NSInteger   selectType;
    ReceiptTitleCell *titleCell;
    ReceiptContentCell *contentCell;
    OrderApi *api;
    UICollectionView *receiptListView;
    UICollectionViewFlowLayout *listLayout;
    NSMutableArray *contentArray;
    NSMutableArray *singgleArray;
    BOOL showContentCell;
    UIControl *back;
    ReceiptModel *selectReceipt;
}

@synthesize receipt;

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    
    api = [OrderApi new];
    
    contentArray = [NSMutableArray arrayWithObjects:@"明细",nil];
    singgleArray = [NSMutableArray arrayWithObjects:@"明细",nil];
    showContentCell = (receipt.type > 0);

    headerView = [[HeaderView alloc] initWithTitle:@""];
    
    headerView.titleLbl.text = @"发票信息";
    
    [headerView setBackAction:@selector(back)];
    
    [self.view addSubview:headerView];

    selectType = receipt.type;
    [api getReceiptList:^(NSMutableArray *receiptlist1) {
        receiptList = receiptlist1;
        for (ReceiptModel *rece in receiptlist1) {
            if (rece.id=receipt.id) {
                selectReceipt = rece;
            }
        }
        [self initdata];
    } failure:^(NSError *error) {
        [self initdata];
    }];
}

-(void) initdata{
    [api getReceiptContent:^(NSMutableArray *receiptList) {
        if (receiptList!=nil&&receiptList.count!=0) {
            contentArray = receiptList;
        }
        [self setupUI];
    } failure:^(NSError *error) {
        
    }];

}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    createBtn = [[ESRedButton alloc] initWithTitle:@"确定"];
    [createBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view).offset(-10);
    }];

    myTable = [TPKeyboardAvoidingTableView new];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[ReceiptTitleCell class] forCellReuseIdentifier:kCellIdentifier_ReceiptTitleCell];
    [myTable registerClass:[ReceiptContentCell class] forCellReuseIdentifier:kCellIdentifier_ReceiptContentCell];
    [self.view addSubview:myTable];
    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else if (indexPath.section == 1) {
        
        return [ReceiptContentCell cellHeightWithObj:contentArray];
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (showContentCell)
        return 2;
    return 1;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        titleCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReceiptTitleCell forIndexPath:indexPath];
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [titleCell configData:receipt :selectType];
        for (int i = 0; i < titleCell.buttons.count; i++) {
            ESRadioButton *button = [titleCell.buttons objectAtIndex:i];
            [button addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        }
        titleCell.companyNameTf.delegate = self;
        return titleCell;
    } else if (indexPath.section == 1) {
        contentCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReceiptContentCell forIndexPath:indexPath];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [contentCell configData:contentArray receipt:receipt selectType:selectType];
        for (int i = 0; i < contentCell.buttons.count; i++) {
            ESRadioButton *button = [contentCell.buttons objectAtIndex:i];
            [button addTarget:self action:@selector(selectContent:) forControlEvents:UIControlEventTouchUpInside];
        }
        return contentCell;
    }
    return [UITableViewCell new];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    [self showReceiptList];
}
/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

/**
 * 每个区的尾部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

/**
 * 每个区的尾部视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    return headerView;
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
 * 选择发票内容
 */
- (IBAction)selectContent:(ESRadioButton *)sender {
    receipt.content = sender.titleLabel.text;
    for (ESRadioButton *button in contentCell.buttons) {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
}

/**
 * 选择发票抬头
 */
- (IBAction)selectTitle:(ESRadioButton *)sender {
    selectType = sender.tag;
    for (ESRadioButton *button in titleCell.buttons) {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
    [titleCell.companyNameTf setHidden:!(sender.tag == 2)];
    showContentCell = (sender.tag > 0);
    [myTable reloadData];
}

-(void) showReceiptList{
    if (back==nil) {
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[titleCell.companyNameTf convertRect: titleCell.companyNameTf.bounds toView:window];
        back = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        [back addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        listLayout = [[UICollectionViewFlowLayout alloc] init];
        listLayout.minimumLineSpacing = 0;
        listLayout.minimumInteritemSpacing = 0;
        listLayout.itemSize = CGSizeMake(rect.size.width, kScreen_Height*0.05);
        receiptListView = [[UICollectionView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, rect.size.height*4) collectionViewLayout:listLayout];
        receiptListView.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];
        receiptListView.delegate = self;
        receiptListView.dataSource = self;
        [receiptListView registerClass:[ReceiptCellCollectionViewCell class] forCellWithReuseIdentifier:@"List"];
        [back addSubview:receiptListView];
    }
    if (receiptList!=nil&&receiptList.count>0) {
       [self.view addSubview:back];   
    }
}

-(void) dissmiss{
    [titleCell.companyNameTf resignFirstResponder];
    [back removeFromSuperview];
}


/**
 * 确定
 */
- (IBAction)ok {
    if(selectType == 2 && [titleCell.companyNameTf.text length] == 0){
        [ToastUtils show:@"请输入您的公司名称!"];
        return;
    }
    if(selectType == 2 && [titleCell.numberTf.text length] == 0){
        [ToastUtils show:@"请输入您的公司税号!"];
        return;
    }
    switch (selectType){
        case 0:
            receipt.title = @"";
            receipt.content = @"";
            receipt.id=0;
            receipt.duby=@"";
            break;
        case 1:
            receipt.title = @"";
            receipt.id=0;
            receipt.duby=@"";
            for (ESRadioButton *button in contentCell.buttons) {
                if([button isSelected]){
                    receipt.content = button.titleLabel.text;
                    break;
                }
            }
            break;
        case 2:
            receipt.title = titleCell.companyNameTf.text;
            for (ESRadioButton *button in contentCell.buttons) {
                if([button isSelected]){
                    receipt.content = button.titleLabel.text;
                    break;
                }
            }
            receipt.id=selectReceipt.id;
            receipt.duby=titleCell.numberTf.text;
            break;
    }
    receipt.type=selectType;
    
    if (selectType==2) {
        if (selectReceipt==nil||![receipt.title isEqualToString:selectReceipt.title]||![receipt.content isEqualToString:selectReceipt.content]||![receipt.duby isEqualToString:selectReceipt.duty]||receipt.type!=selectReceipt.type) {
            [api addReceipt:receipt success:^(ReceiptModel *receiptList) {
                receipt.id=receiptList.id;
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:receipt, @"receipt", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:nSelectReceipt object:nil userInfo:userInfo];
                [self back];
            } failure:^(NSError *error) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:receipt, @"receipt", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:nSelectReceipt object:nil userInfo:userInfo];
                [self back];
            }];
        }else{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:receipt, @"receipt", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:nSelectReceipt object:nil userInfo:userInfo];
            [self back];

        }
    }else{
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:receipt, @"receipt", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:nSelectReceipt object:nil userInfo:userInfo];
        [self back];
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return receiptList.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReceiptCellCollectionViewCell *cell = [receiptListView dequeueReusableCellWithReuseIdentifier:@"List" forIndexPath:indexPath];
    ReceiptModel *receipt = [receiptList objectAtIndex:[indexPath row]];
    [cell initData:receipt.title];
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ReceiptModel *re = [receiptList objectAtIndex:[indexPath row]];
    selectReceipt = re;
    selectType = selectReceipt.type;
    titleCell.companyNameTf.text=selectReceipt.title;
    titleCell.numberTf.text= selectReceipt.duty;
    for (ESRadioButton *button in contentCell.buttons) {
        if ([button.titleLabel.text isEqualToString:selectReceipt.content]) {
         [button setSelected:YES];
         }else{
          [button setSelected:NO];
        }
    }
    [self dissmiss];
}


@end