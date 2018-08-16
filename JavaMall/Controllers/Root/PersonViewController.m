//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PersonViewController.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "PersonLoginCell.h"
#import "PersonOrderCell.h"
#import "PersonItemCell.h"
#import "RedButtonCell.h"
#import "ESRedButton.h"
#import "Constants.h"
#import "ESButton.h"
#import "ESImageButton.h"
#import "ControllerHelper.h"
#import "MemberApi.h"
#import "ToastUtils.h"
#import "PersonEditViewController.h"
#import "MyFavoriteGoodsViewController.h"
#import "MyPointHistoryViewController.h"
#import "MyOrderListViewController.h"
#import "MyCommentOrderListViewController.h"
#import "ReturnedOrderListViewController.h"
#import "Order.h"
#import "MyReturnedOrderListViewController.h"
#import "SelectAddressViewController.h"
#import "MyAddressViewController.h"
#import "PasswordViewController.h"
#import "EMClient.h"
#import "MyBonusViewController.h"
#import "MyFavoriteViewController.h"
#import "LBSignView.h"
#import "Member.h"
#import "LBMoreSecKillVC.h"
#import "FenxiaoManagerViewController.h"

@implementation PersonViewController {
    HeaderView *headerView;
    UITableView *personTable;

    PersonLoginCell *personLoginCell;

    MemberApi  *memberApi;
    
    UIView     *viewUpBG;
    
    LBSignView *signView;
    
    NSInteger  ishavestore;
    
    NSString *uname;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberInfoChanged:) name:nLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberInfoChanged:) name:nLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberInfoChanged:) name:nFavriteChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberInfoChanged:) name:nPostComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberInfoChanged:) name:nCheckout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberInfoChanged:) name:nReturnedOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberInfoChanged:) name:nOrderStatusChanged object:nil];

    memberApi = [MemberApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"我的"];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    personTable = [UITableView new];
    personTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    personTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    personTable.dataSource = self;
    personTable.delegate = self;
    [personTable registerClass:[PersonLoginCell class] forCellReuseIdentifier:kCellIdentifier_PersonLoginCell];
    [personTable registerClass:[PersonOrderCell class] forCellReuseIdentifier:kCellIdentifier_PersonOrderCell];
    [personTable registerClass:[PersonItemCell class] forCellReuseIdentifier:kCellIdentifier_PersonItemCell];
    [personTable registerClass:[RedButtonCell class] forCellReuseIdentifier:kCellIdentifier_RedButtonCell];
    [self.view addSubview:personTable];
    [personTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    //打卡视图
    signView = [LBSignView new];
    signView.frame = self.view.bounds;
    [signView setCancerAction:@selector(cancerClick:)];
    [signView setSignAction:@selector(signClick:)];
    [signView setHidden:YES];
    [self.view addSubview:signView];
}

/**
 * 获取数据
 */
- (void)loadData {
    if ([Constants currentMember] != nil) {
        [memberApi info:^(Member *member) {
            [Constants setMember:member];
            ishavestore = member.ishavestore;
            uname = member.userName;
            [personTable reloadData];
        }       failure:^(NSError *error) {
            [ToastUtils show:[error localizedDescription]];
        }];
        return;
    }
    [personTable reloadData];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return 140;
            }
            return 50;
        case 1:
            if (indexPath.row == 0) {
                return 45;
            }
            return 60;
        case 2:
            return 45;
        case 3:
            return 60;
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return ishavestore == 0 ? 1 : 2;
        case 1:
            return 2;
        case 2:
            return 4;
        case 3:
            if ([Constants currentMember] != nil) {
                return 1;
            }
            return 0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            personLoginCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonLoginCell forIndexPath:indexPath];
            personLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [personLoginCell configData:[Constants currentMember]];
            [personLoginCell.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
            [personLoginCell.faceBtn addTarget:self action:@selector(toPersonEdit) forControlEvents:UIControlEventTouchUpInside];
            [personLoginCell.favoriteBtn addTarget:self action:@selector(favorite) forControlEvents:UIControlEventTouchUpInside];
            [personLoginCell.favoriteStoreBtn addTarget:self action:@selector(favoriteStore) forControlEvents:UIControlEventTouchUpInside];
            [personLoginCell.pointBtn addTarget:self action:@selector(point) forControlEvents:UIControlEventTouchUpInside];
            [personLoginCell.mpBtn addTarget:self action:@selector(mp) forControlEvents:UIControlEventTouchUpInside];
            [personLoginCell.signBtn addTarget:self action:@selector(singBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return personLoginCell;
        }else {
            PersonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonItemCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"管理我的店铺" icon:[UIImage imageNamed:@"mystore"] remark:@"" headLine:NO footerLine:YES];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            PersonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonItemCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"我的订单" icon:[UIImage imageNamed:@"my_order.png"] remark:@"查看全部订单" headLine:YES footerLine:YES];
            return cell;
        }
        PersonOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonOrderCell forIndexPath:indexPath];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [orderCell configData:[Constants currentMember]];
        [orderCell.paymentBtn addTarget:self action:@selector(paymentOrder) forControlEvents:UIControlEventTouchUpInside];
        [orderCell.shippingBtn addTarget:self action:@selector(shippingOrder) forControlEvents:UIControlEventTouchUpInside];
        [orderCell.commentBtn addTarget:self action:@selector(commentOrder) forControlEvents:UIControlEventTouchUpInside];
        [orderCell.returnedBtn addTarget:self action:@selector(returnedOrder) forControlEvents:UIControlEventTouchUpInside];
        return orderCell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            PersonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonItemCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"地址管理" icon:[UIImage imageNamed:@"my_address.png"] remark:@"管理收货地址" headLine:YES footerLine:YES];
            return cell;
        } else if (indexPath.row == 1) {
            PersonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonItemCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"优惠券" icon:[UIImage imageNamed:@"my_bonus.png"] remark:@"我的优惠券" headLine:YES footerLine:YES];
            return cell;
        }  else if (indexPath.row == 2) {
            PersonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonItemCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"个人资料" icon:[UIImage imageNamed:@"my_info.png"] remark:@"完善个人资料" headLine:YES footerLine:YES];
            return cell;
        } else if (indexPath.row == 3) {
            PersonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PersonItemCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"账户安全" icon:[UIImage imageNamed:@"my_password.png"] remark:@"修改密码" headLine:YES footerLine:YES];
            return cell;
        }
    } else if (indexPath.section == 3) {
        RedButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
        cell.button.enabled = YES;
        [cell.button setTitle:@"退出登录" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return [UITableViewCell new];
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
    if (section < 3) {
        return 10;
    }
    return 0.01f;
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
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![ControllerHelper isLogined]){
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        FenxiaoManagerViewController *fenxiao = [FenxiaoManagerViewController new];
        fenxiao.uname = uname;
        [self.navigationController pushViewController:fenxiao animated:YES];
    }

    if (indexPath.section == 1 && indexPath.row == 0) {
        MyOrderListViewController *myOrderListViewController = [MyOrderListViewController new];
        myOrderListViewController.status = OrderStatus_ALL;
        [self.navigationController pushViewController:myOrderListViewController animated:YES];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            MyAddressViewController *myAddressViewController = [MyAddressViewController new];
            [self.navigationController pushViewController:myAddressViewController animated:YES];
        } else if (indexPath.row == 1) {
            MyBonusViewController *myBonusViewController = [MyBonusViewController new];
            [self.navigationController pushViewController:myBonusViewController animated:YES];
        } else if (indexPath.row == 2) {
            [self toPersonEdit];
        } else if (indexPath.row == 3) {
            PasswordViewController *passwordViewController = [PasswordViewController new];
            [self.navigationController pushViewController:passwordViewController animated:YES];
        }
    }
}

/**
 * 登录
 */
- (IBAction)login {
    [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
}

/**
 * 打开个人资料
 */
- (IBAction)toPersonEdit {
    
    [self.navigationController pushViewController:[PersonEditViewController new] animated:YES];
}

/**
 * 打开收藏
 */
- (IBAction)favorite {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    [self.navigationController pushViewController:[MyFavoriteViewController new] animated:YES];
}

/**
 * 打开关注的店铺
 */
- (IBAction)favoriteStore {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    MyFavoriteViewController *myFavoriteViewController = [MyFavoriteViewController new];
    myFavoriteViewController.tabIndex = 1;
    [self.navigationController pushViewController:myFavoriteViewController animated:YES];
}

/**
 * 打开等级积分
 */
- (IBAction)point {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    MyPointHistoryViewController *myPointHistoryViewController = [MyPointHistoryViewController new];
    myPointHistoryViewController.type = 1;
    [self.navigationController pushViewController:myPointHistoryViewController animated:YES];
}

/**
 * 打开消费积分
 */
- (IBAction)mp {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    MyPointHistoryViewController *myPointHistoryViewController = [MyPointHistoryViewController new];
    myPointHistoryViewController.type = 2;
    [self.navigationController pushViewController:myPointHistoryViewController animated:YES];
}

/**
 * 打卡
 */
- (void)singBtnClick {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    
    [signView setHidden:NO];
    
    
}

/**
 * 取消
 */
- (void)cancerClick:(UIButton *)sender {
    [signView setHidden:YES];
}

/**
 * 打卡事件
 */
- (void)signClick:(UIButton *)sender {
    [signView setHidden:YES];
    
    if ([Constants currentMember] != nil) {
        [memberApi sign:^(Member *member) {
            [Constants setMember:member];
            
            [self loadData];
            
        }       failure:^(NSError *error) {
            [ToastUtils show:[error localizedDescription]];
        }];
        return;
    }
    [personTable reloadData];
    
}

/**
 * 打开待付款订单
 */
- (IBAction)paymentOrder {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    MyOrderListViewController *myOrderListViewController = [MyOrderListViewController new];
    myOrderListViewController.status = OrderStatus_NOPAY;
    [self.navigationController pushViewController:myOrderListViewController animated:YES];
}

/**
 * 打开待收货订单
 */
- (IBAction)shippingOrder {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    MyOrderListViewController *myOrderListViewController = [MyOrderListViewController new];
    myOrderListViewController.status = OrderStatus_SHIP;
    [self.navigationController pushViewController:myOrderListViewController animated:YES];
}

/**
 * 打开待评价订单
 */
- (IBAction)commentOrder {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    [self.navigationController pushViewController:[MyCommentOrderListViewController new] animated:YES];
}

/**
 * 打开退换货订单
 */
- (IBAction)returnedOrder {
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    [self.navigationController pushViewController:[MyReturnedOrderListViewController new] animated:YES];
}

/**
 * 退出登录
 */
- (IBAction)logout {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您确认要退出登录吗？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定"
                                                    otherButtonTitles:nil
    ];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        [ToastUtils showLoading];
        [memberApi logout:^() {
            [ControllerHelper clearLoginInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:nLogout object:nil];
            [ToastUtils hideLoading];
            [ToastUtils show:@"退出登录成功!"];
            ishavestore = 0;
            [personTable reloadData];
            //退出IM软件
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = [[EMClient sharedClient] logout:NO];;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        NSLog(@"退出登录成功！");
                    } else {
                        NSLog(@"退出登录失败!");
                    }
                });
            });


        }         failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:error.localizedDescription];
        }];
    }
}

/**
 * 响应用户信息改变的通知
 */
- (void)memberInfoChanged:(NSNotification *)notification {
    [self loadData];
}

@end
