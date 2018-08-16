//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PaymentShippingViewController.h"
#import "PaymentShippingApi.h"
#import "HeaderView.h"
#import "ESRedButton.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "CheckoutSelectCell.h"
#import "ESCheckButton.h"
#import "Payment.h"
#import "Shipping.h"
#import "Cart.h"
#import "ESLabel.h"
#import "Store.h"
#import "ShipType.h"
#import "OrderApi.h"
#import "StoremessageTableViewCell.h"

@implementation PaymentShippingViewController {

    HeaderView *headerView;
    UITableView *psTable;
    ESRedButton *createBtn;

    CheckoutSelectCell *paymentCell;
    StoremessageTableViewCell *shippingCell;
    CheckoutSelectCell *shippingTimeCell;

    OrderApi *orderApi;
    NSInteger paymentType;
    NSInteger shipType;
}

@synthesize paymentArray, cart, shippingTimeArray;
@synthesize payment, shippingTime;
@synthesize regionId;

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];

    orderApi = [OrderApi new];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"选择支付配送方式";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
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

    psTable = [UITableView new];
    psTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    psTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    psTable.dataSource = self;
    psTable.delegate = self;
    [psTable registerClass:[CheckoutSelectCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutSelectCell];
     [psTable registerClass:[StoremessageTableViewCell class] forCellReuseIdentifier:kkCellIdentifier_CheckoutSelectCell];
    [self.view addSubview:psTable];
    [psTable mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        return [CheckoutSelectCell cellHeightWithObj:[self paymentNameArray]];
    } else if (indexPath.section == 1) {
        Store *store = [cart.storeList objectAtIndex:indexPath.row];
        NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:store.shipList.count];
        for(ShipType *shipType in store.shipList){
            [nameArray addObject:shipType.name];
        }
        return [StoremessageTableViewCell cellHeightWithObj:nameArray address:store.storeAddr];
    } else if (indexPath.section == 2) {
        return [CheckoutSelectCell cellHeightWithObj:shippingTimeArray];
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0 || section == 2) {
        return 1;
    }
    return cart.storeList.count;
}

/**
 * 有几个区
 * @param tableView
 * @return
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        paymentCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutSelectCell forIndexPath:indexPath];
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [paymentCell setTitle:@"支付方式"];
        [paymentCell configData:[self paymentNameArray]];
        for (int i = 0; i < paymentCell.buttons.count; i++) {
            ESCheckButton *button = [paymentCell.buttons objectAtIndex:i];
            Payment *p = [paymentArray objectAtIndex:button.tag];
            if (payment.id == p.id) {
                [button setSelected:YES];
            }
            [button addTarget:self action:@selector(selectPayment:) forControlEvents:UIControlEventTouchUpInside];
        }
        return paymentCell;
    } else if (indexPath.section == 1) {
        Store *store = [cart.storeList objectAtIndex:indexPath.row];

        shippingCell = [tableView dequeueReusableCellWithIdentifier:kkCellIdentifier_CheckoutSelectCell forIndexPath:indexPath];
        shippingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [shippingCell.titleLbl setFont:[UIFont systemFontOfSize:12]];
        [shippingCell showLine:NO footer:YES];
        [shippingCell setTitle:store.name];
        [shippingCell setAddress:store.storeAddr];
        NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:store.shipList.count];
        NSMutableArray *typeArray = [NSMutableArray arrayWithCapacity:store.shipList.count];
        for(ShipType *shipType in store.shipList){
            [nameArray addObject:shipType.name];
            [typeArray addObject:[NSString stringWithFormat:@"%zd",shipType.type_id]];
        }

        [shippingCell configData:nameArray typeArr:typeArray];
        for (int i = 0; i < shippingCell.buttons.count; i++) {
            ESCheckButton *button = [shippingCell.buttons objectAtIndex:i];
            button.value = [NSString stringWithFormat:@"%d", indexPath.row];
            if(store.shipType == nil){
                if(i == 0){
                    [button setSelected:YES];
                }
            }else{
                ShipType *s = [store.shipList objectAtIndex:button.tag];
                if(store.shipType.type_id == s.type_id){
                    
                    [button setSelected:YES];
                }
            }
            [button addTarget:self action:@selector(selectShipping:) forControlEvents:UIControlEventTouchUpInside];
        }
        return shippingCell;
    } else if (indexPath.section == 2) {
        shippingTimeCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutSelectCell forIndexPath:indexPath];
        shippingTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [shippingTimeCell setTitle:@"送货时间"];
        [shippingTimeCell configData:shippingTimeArray];
        for (int i = 0; i < shippingTimeCell.buttons.count; i++) {
            ESCheckButton *button = [shippingTimeCell.buttons objectAtIndex:i];
            if (shippingTime == button.tag) {
                [button setSelected:YES];
            }
            [button addTarget:self action:@selector(selectShippingTime:) forControlEvents:UIControlEventTouchUpInside];
        }
        return shippingTimeCell;
    }
    return [UITableViewCell new];
}


/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section != 1) {
        return 0.01f;
    }
    return 40;
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
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    header.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    return header;
}

/**
 * 每个区的头部视图
 * @param tableView
 * @param section
 * @return
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section != 1){
        return [UIView new];
    }
    //配送方式
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];

    ESLabel *titleLbl = [[ESLabel alloc] initWithText:@"配送方式" textColor:[UIColor darkGrayColor] fontSize:14];
    [view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
    }];

    UIView *footerLine = [UIView new];
    footerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [view addSubview:footerLine];
    [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@0.5f);
    }];

    UIView *headerLine = [UIView new];
    headerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [view addSubview:headerLine];
    [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.equalTo(footerLine);
    }];

    return view;
}

/**
 * 将支付名称组合成一个数组并返回
 */
- (NSMutableArray *)paymentNameArray {
    NSMutableArray *paymentNameArray = [NSMutableArray arrayWithCapacity:paymentArray.count];
    for (Payment *p in paymentArray) {
        [paymentNameArray addObject:p.name];
    }
    return paymentNameArray;
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
 * 选择支付方式
 */
- (IBAction)selectPayment:(ESButton *)sender {
    payment = [paymentArray objectAtIndex:sender.tag];
    if(shipType==1000 && payment.id ==3)
    {
        [ToastUtils show:@"选择门店自提时不能同时选择货到付款"];
        paymentType = 3;
        return;
    }
    for (ESCheckButton *button in paymentCell.buttons) {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
}

/**
 * 选择配送方式
 */
- (IBAction)selectShipping:(ESCheckButton *)sender {
    NSInteger row = [sender.value intValue];
    Store *store = [cart.storeList objectAtIndex:row];
    if(payment.id==3 && sender.typeids ==1000)
    {
        [ToastUtils show:@"选择货到付款时不能同时选择门店自提"];
        
        return;
    }
    shipType = sender.typeids;
    store.shipType = [store.shipList objectAtIndex:sender.tag];

    [psTable reloadData];

}

/**
 * 选择送货时间
 */
- (IBAction)selectShippingTime:(ESButton *)sender {
    shippingTime = sender.tag;
    for (ESCheckButton *button in shippingTimeCell.buttons) {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
}

/**
 * 确定
 */
- (IBAction)ok {
    [ToastUtils showLoading];
    [orderApi changeShipBonus:regionId Cart:cart success:^(OrderPrice *orderPrice) {
        [ToastUtils hideLoading];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:payment, @"payment", [NSString stringWithFormat:@"%d",shippingTime], @"shippingTime", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:nSelectPaymentDelivery object:nil userInfo:userInfo];
        [self back];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

@end
