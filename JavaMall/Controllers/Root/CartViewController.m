//
// Created by Dawei on 1/4/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartViewController.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "GoodsApi.h"
#import "RDVTabBarController.h"
#import "ControllerHelper.h"
#import "Constants.h"
#import "ToastUtils.h"
#import "CartApi.h"
#import "CartCell.h"
#import "Cart.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CartLoginCell.h"
#import "CartEmptyCell.h"
#import "CartMoreGoodsCell.h"
#import "ESButton.h"
#import "CartGoods.h"
#import "NSString+Common.h"
#import "ESTextField.h"
#import "CartEditView.h"
#import "CartCheckoutView.h"
#import "RDVTabBarController.h"
#import "UIView+Layout.h"
#import "FavoriteApi.h"
#import "CheckoutViewController.h"
#import "BaseNavigationController.h"
#import "Store.h"
#import "CartStoreHeader.h"
#import "StoreViewController.h"
#import "GoodsActivityViewController.h"
#import "CartStoreFooter.h"

@implementation CartViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *cartTableView;
    CartEditView *cartEditView;
    CartCheckoutView *cartCheckoutView;
    ESButton *editBtn;

    GoodsApi *goodsApi;
    CartApi *cartApi;
    FavoriteApi *favoriteApi;

    Cart *cart;
    NSMutableArray *hotGoodsArray;

    BOOL isEditing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    goodsApi = [GoodsApi new];
    cartApi = [CartApi new];
    favoriteApi = [FavoriteApi new];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nAddCart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChangedCompletion:) name:nCheckout object:nil];

    headerView = [[HeaderView alloc] initWithTitle:@"购物车"];
    [self.view addSubview:headerView];

    [self setupUI];
    [cartTableView.header beginRefreshing];

    //添加后退按钮
    if (self.rdv_tabBarController == nil) {
        [headerView setBackAction:@selector(back)];
    }

}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    //增加编辑按钮
    isEditing = false;
    editBtn = [ESButton new];
    [editBtn setHidden:YES];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [editBtn setFontSize:14];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView).offset(-5);
        make.right.equalTo(headerView).offset(-5);
    }];

    //增加编辑视图
    cartEditView = [CartEditView new];
    [cartEditView setCheckAction:@selector(selectAll:)];
    [cartEditView setFavoriteAction:@selector(favorite:)];
    [cartEditView setDeleteAction:@selector(delete:)];
    [cartEditView setHidden:YES];
    [self.view addSubview:cartEditView];
    [cartEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];

    cartTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    cartTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f0f5"];
    cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cartTableView registerClass:[CartCell class] forCellReuseIdentifier:kCellIdentifier_CartCell];
    [cartTableView registerClass:[CartLoginCell class] forCellReuseIdentifier:kCellIdentifier_CartLoginCell];
    [cartTableView registerClass:[CartEmptyCell class] forCellReuseIdentifier:kCellIdentifier_CartEmptyCell];
    [cartTableView registerClass:[CartMoreGoodsCell class] forCellReuseIdentifier:kCellIdentifier_CartMoreGoodsCell];
    cartTableView.dataSource = self;
    cartTableView.delegate = self;
    cartTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadCart];
    }];
    [self.view addSubview:cartTableView];
    [self reLayout];

    //创建结算视图
    cartCheckoutView = [CartCheckoutView new];
    [cartCheckoutView setCheckoutAction:@selector(checkout)];
    [cartCheckoutView setCheckAction:@selector(checkAll)];

    [self.view addSubview:cartCheckoutView];
    [cartCheckoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

/**
 * 载入购物车数据
 */
- (void)loadCart {
    //改为非编辑模式
    [editBtn setHidden:YES];
    isEditing = NO;
    if (editBtn.isSelected) {
        [self edit:editBtn];
    }

    //载入购物车数据
    [cartApi list:^(Cart *_cart) {
        cart = _cart;
        [cartTableView reloadData];
        if (cart == nil || cart.storeList.count == 0) {
            [self loadHotGoods];
            [self hideCheckoutView:YES];
            [cartCheckoutView setTotalPrice:0];
        } else {
            [self hideCheckoutView:NO];
            [editBtn setHidden:NO];
            [cartCheckoutView setTotalPrice:cart.total];

            BOOL checkAll = YES;
            for (Store *store in cart.storeList) {
                for (CartGoods *goods in store.goodsList) {
                    if (!goods.checked) {
                        checkAll = NO;
                        break;
                    }
                }
            }
            [cartCheckoutView setChecked:checkAll];
        }
        [cartTableView.header endRefreshing];

    }     failure:^(NSError *error) {
        [cartTableView reloadData];
        if (cart == nil || cart.count == 0) {
            [self loadHotGoods];
            [self hideCheckoutView:YES];
        }
        [cartTableView.header endRefreshing];
    }];
}

/**
 * 显示或隐藏结算视图
 */
- (void)hideCheckoutView:(BOOL)hidden {
    [cartCheckoutView setHidden:hidden];
    if (cartCheckoutView.isHidden) {
        cartTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        cartTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
}

/**
 * 重新布局视图
 */
- (void)reLayout {
    [cartTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        if (!cartEditView.isHidden) {
            make.bottom.equalTo(cartEditView.mas_top);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

/**
 * 后退
 */
- (IBAction)back {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * 载入推荐商品
 */
- (void)loadHotGoods {
    [goodsApi hotlist:1 success:^(NSMutableArray *goodsArr) {
        hotGoodsArray = goodsArr;
        [cartTableView reloadData];

    }         failure:^(NSError *error) {
    }];
}


#pragma HotGoodsDelegate

- (void)selectHotGoods:(Goods *)goods {
    if (self.rdv_tabBarController != nil) {
        [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsViewController:goods] animated:YES];
        return;
    }
    if (self.navigationController != nil) {
        [self.navigationController pushViewController:[ControllerHelper createGoodsViewController:goods] animated:YES];
        return;
    }
}

#pragma CartTableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    } else if (indexPath.section == 1) {
        return 80;
    } else if (indexPath.section > 1 && indexPath.section < (cart.storeList.count + 2)) {
        Store *store = [self getStoreBySection:indexPath.section];
        return [CartCell cellHeightWithObj:[store.goodsList objectAtIndex:indexPath.row]];
    } else {
        return [CartMoreGoodsCell cellHeightWithObj:hotGoodsArray];
    }

}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {             //未登录提示
        if ([Constants isLogin]) {
            return 0;
        }
        return 1;
    } else if (section == 1) {      //购物车为空提示
        if (cart != nil && cart.storeList.count > 0) {
            return 0;
        }
        return 1;
    } else if (section > 1 && section < (cart.storeList.count + 2)) {   //商品项
        Store *store = [self getStoreBySection:section];
        return store.goodsList.count;
    } else {
        if (hotGoodsArray == nil || hotGoodsArray.count == 0) {         //推荐商品
            return 0;
        }
        return 1;
    }
}

/**
 * 几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + cart.storeList.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CartLoginCell *cartLoginCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CartLoginCell forIndexPath:indexPath];
        [cartLoginCell.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        cartLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cartLoginCell;
    } else if (indexPath.section == 1) {
        CartEmptyCell *cartEmptyCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CartEmptyCell forIndexPath:indexPath];
        cartEmptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cartEmptyCell.indexBtn addTarget:self action:@selector(toIndex) forControlEvents:UIControlEventTouchUpInside];
        return cartEmptyCell;
    } else if (indexPath.section > 1 && indexPath.section < (cart.storeList.count + 2)) {
        Store *store = [self getStoreBySection:indexPath.section];
        CartCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CartCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isEditing = isEditing;
        [cell configData:[store.goodsList objectAtIndex:indexPath.row]];
        [cell.numberAddBtn addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
        [cell.numberLessBtn addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
        cell.numberTf.delegate = self;
        [cell.selectBtn addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        CartMoreGoodsCell *moreGoodsCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CartMoreGoodsCell forIndexPath:indexPath];
        moreGoodsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [moreGoodsCell configData:hotGoodsArray];
        moreGoodsCell.delegate = self;
        return moreGoodsCell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1 && indexPath.section < (cart.storeList.count + 2)) {
        return YES;
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 1 && section < (cart.storeList.count + 2)) {
        return 50;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section > 1 && section < (cart.storeList.count + 2)) {
        return [CartStoreFooter heightWithObject:[self getStoreBySection:section]];
    }
    return 0.01f;
}

/**
 * 头
 * @param tableView
 * @param section
 * @return
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 1 && section < (cart.storeList.count + 2)) {
        CartStoreHeader *headerView = [CartStoreHeader new];
        headerView.tag = section;
        headerView.isEditing = isEditing;
        [headerView configData:[self getStoreBySection:section] section:section];
        [headerView.selectBtn addTarget:self action:@selector(selectStore:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.activityBtn addTarget:self action:@selector(showActivity:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addTarget:self action:@selector(toStore:) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
    }
    return nil;
}

/**
 * 尾
 * @param tableView
 * @param section
 * @return
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section > 1 && section < (cart.storeList.count + 2)) {
        CartStoreFooter *footerView = [CartStoreFooter new];
        footerView.tag = section;
        [footerView configData:[self getStoreBySection:section]];
        return footerView;
    }
    return nil;
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *favoriteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [ToastUtils showLoading];
        CartGoods *cartGoods = [self getGoodsByIndexPath:indexPath];
        [favoriteApi favorite:cartGoods.id success:^{
            [ToastUtils hideLoading];
            [ToastUtils show:@"收藏商品成功!"];
        }             failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:error.localizedDescription];
        }];
        tableView.editing = NO;
    }];

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [ToastUtils showLoading];
        CartGoods *cartGoods = [self getGoodsByIndexPath:indexPath];
        NSMutableArray *cartIds = [NSMutableArray arrayWithCapacity:1];
        [cartIds addObject:[NSString stringWithFormat:@"%d", cartGoods.cartId]];
        [cartApi delete:cartIds success:^(NSInteger cartItemCount) {
            [ToastUtils hideLoading];

            Store *store = [self getStoreBySection:indexPath.section];
            [store.goodsList removeObject:cartGoods];
            [cartTableView reloadData];
        }       failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:error.localizedDescription];
        }];
        tableView.editing = NO;
    }];

    return @[deleteAction, favoriteAction];
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2 || indexPath.section >= (cart.storeList.count + 2))
        return;
    CartGoods *goods = [self getGoodsByIndexPath:indexPath];
    UIViewController *goodsViewController = [ControllerHelper createGoodsViewController:goods];
    [self.navigationController pushViewController:goodsViewController animated:YES];
}

/**
 * 根据indexPath获取商品
 */
- (CartGoods *)getGoodsByIndexPath:(NSIndexPath *)indexPath {
    if (cart == nil || cart.storeList.count == 0)
        return nil;
    if (indexPath.section < 2 || indexPath.section >= (cart.storeList.count + 2))
        return nil;
    Store *store = [self getStoreBySection:indexPath.section];
    return [store.goodsList objectAtIndex:indexPath.row];
}

/**
 * 根据区索引获取Store对象
 * @param section
 * @return
 */
- (Store *)getStoreBySection:(NSInteger)section {
    return [cart.storeList objectAtIndex:(section - 2)];
}

/**
 * 修改购物车商品数量
 */
- (IBAction) changeNumber:(UIButton *)sender {
    CartCell *cell = (CartCell *) [sender superview];
    NSInteger valueInText = [cell.numberTf.text intValue];
    cell.numberTf.oldText = cell.numberTf.text;
    if (sender == cell.numberLessBtn) {
        cell.numberTf.text = [NSString stringWithFormat:@"%d", (--valueInText)];
    } else {
        cell.numberTf.text = [NSString stringWithFormat:@"%d", (++valueInText)];
    }

    NSInteger newNumber = [cell.numberTf.text intValue];
    NSIndexPath *indexPath = [cartTableView indexPathForCell:cell];
    CartGoods *cartGoods = [self getGoodsByIndexPath:indexPath];
    if (newNumber > 0) {
        [cartApi updateNumber:cartGoods.cartId number:newNumber productId:cartGoods.productId success:^{
            //重新载入结算金额
            [self loadCart];

        }             failure:^(NSError *error) {
            [ToastUtils show:error.localizedDescription];
            cell.numberTf.text = cell.numberTf.oldText;
        }];
    } else {
        NSMutableArray *cartIds = [NSMutableArray arrayWithCapacity:1];
        [cartIds addObject:[NSString stringWithFormat:@"%d", cartIds]];
        [cartApi delete:cartIds success:^(NSInteger cartItemCount) {
            [self loadCart];
        }       failure:^(NSError *error) {
            [ToastUtils show:error.localizedDescription];
            cell.numberTf.text = cell.numberTf.oldText;
        }];
    }

}

/**
 * 保存旧值
 */
- (BOOL)textFieldShouldBeginEditing:(ESTextField *)textField {
    textField.oldText = textField.text;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(ESTextField *)textField {
    BOOL canEnd = [textField.text isInt] && ![textField.text hasPrefix:@"0"];
    if (canEnd) {
        NSLog(@"数量:%d", [textField.text intValue]);
    }
    return canEnd;
}

/**
 * 选中商品
 */
- (IBAction) selectCell:(UIButton *)sender {
    CartCell *cell = (CartCell *) [sender superview];
    NSIndexPath *indexPath = [cartTableView indexPathForCell:cell];
    CartGoods *cartGoods = [self getGoodsByIndexPath:indexPath];
    if (isEditing) {
        [sender setSelected:!sender.isSelected];
        cartGoods.selected = sender.isSelected;

        //判断是否选中店铺
        Store *store = [self getStoreBySection:indexPath.section];
        BOOL selectStore = YES;
        for(CartGoods *goods in store.goodsList){
            if(!goods.selected){
                selectStore = NO;
                break;
            }
        }
        store.selected = selectStore;
        [cartTableView reloadData];

        //是否选中全选
        BOOL selectAll = YES;
        for(Store *s in cart.storeList){
            if(!s.selected){
                selectAll = NO;
                break;
            }
        }
        [cartEditView setChecked:selectAll];


    } else {
        [cartApi check:cartGoods.productId checked:!sender.isSelected success:^(BOOL result) {
            [self loadCart];
        }      failure:^(NSError *error) {
            [ToastUtils show:[error localizedDescription]];
        }];
    }
}

/**
 * 选中店铺
 * @param sender
 */
- (IBAction)selectStore:(UIButton *)sender {
    NSInteger section = sender.tag;
    Store *store = [self getStoreBySection:section];

    if(isEditing){
        [sender setSelected:!sender.isSelected];
        store.selected = sender.isSelected;
        for(CartGoods *cartGoods in store.goodsList){
            cartGoods.selected = sender.isSelected;
        }
        [cartTableView reloadData];

        //是否选中全选
        BOOL selectAll = YES;
        for(Store *s in cart.storeList){
            if(!s.selected){
                selectAll = NO;
                break;
            }
        }
        [cartEditView setChecked:selectAll];
    }else{
        [cartApi checkStore:store.id checked:!sender.isSelected success:^(BOOL result) {
            [self loadCart];
        } failure:^(NSError *error) {
            [ToastUtils show:[error localizedDescription]];
        }];
    }
}

/**
 * 进入店铺
 * @param view
 */
-(IBAction)toStore:(UIView *)view{
    NSInteger section = view.tag;
    Store *store = [self getStoreBySection:section];
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = store.id;
    [[self navigationController] pushViewController:storeViewController animated:YES];
}

/**
 * 显示促销活动
 * @param view
 */
-(IBAction)showActivity:(UIView *)view{
    NSInteger section = view.tag;
    Store *store = [self getStoreBySection:section];
    GoodsActivityViewController *goodsActivityViewController = [GoodsActivityViewController new];
    goodsActivityViewController.activity_id = store.activity_id;
    [[self navigationController] pushViewController:goodsActivityViewController animated:YES];
}

/**
 * 编辑
 */
- (IBAction) edit:(UIButton *)sender {
    for (Store *store in cart.storeList) {
        for (CartGoods *cartGoods in store.goodsList) {
            cartGoods.selected = NO;
            [cartEditView setChecked:NO];
        }
    }
    [sender setSelected:!sender.isSelected];
    [self hideCheckoutView:sender.isSelected];
    [cartEditView setHidden:!sender.isSelected];

    isEditing = sender.isSelected;
    [self reLayout];
    [cartTableView reloadData];
}

/**
 * 全选
 */
- (void)selectAll:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    if (cart == nil || cart.storeList.count == 0)
        return;
    for (Store *store in cart.storeList) {
        for (CartGoods *cartGoods in store.goodsList) {
            cartGoods.selected = sender.isSelected;
        }
    }
    [cartTableView reloadData];
}

/**
 * 收藏选中
 */
- (void)favorite:(UIButton *)sender {
    NSMutableArray *goodsIdArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (Store *store in cart.storeList) {
        for (CartGoods *cartGoods in store.goodsList) {
            if (cartGoods.selected) {
                [goodsIdArray addObject:[NSString stringWithFormat:@"%d", cartGoods.id]];
            }
        }
    }
    if (goodsIdArray.count == 0) {
        [ToastUtils show:@"请选择您要收藏的商品!"];
        return;
    }
    [ToastUtils showLoading];
    [favoriteApi batchFavorite:goodsIdArray success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"收藏商品成功!"];
    }                  failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:error.localizedDescription];
    }];

}

/**
 * 删除选中
 */
- (void)delete:(UIButton *)sender {
    NSMutableArray *goodsIdArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (Store *store in cart.storeList) {
        for (CartGoods *cartGoods in store.goodsList) {
            if (cartGoods.selected) {
                [goodsIdArray addObject:[NSString stringWithFormat:@"%d", cartGoods.cartId]];
            }
        }
    }
    if (goodsIdArray.count == 0) {
        [ToastUtils show:@"请选择您要删除的商品!"];
        return;
    }
    [ToastUtils showLoading];
    [cartApi delete:goodsIdArray success:^(NSInteger cartItemCount) {
        [ToastUtils hideLoading];
        [[NSNotificationCenter defaultCenter] postNotificationName:nDeleteCart object:nil];
        [self loadCart];
    }       failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:error.localizedDescription];
    }];
}

/**
 * 选中所有商品进行结算
 */
- (IBAction)checkAll {
    [cartCheckoutView setChecked:![cartCheckoutView isChecked]];
    [cartApi checkAll:[cartCheckoutView isChecked] success:^(BOOL result) {
        [self loadCart];
    }         failure:^(NSError *error) {
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 去结算
 */
- (IBAction) checkout {
    if (cart == nil || cart.storeList.count == 0) {
        [ToastUtils show:@"请先将商品加入购物车后再进行结算!"];
        return;
    }
    NSInteger checkoutGoodsCount = 0;
    for (Store *store in cart.storeList) {
        for (CartGoods *goods in store.goodsList) {
            if (goods.checked) {
                checkoutGoodsCount++;
            }
        }
    }
    if (checkoutGoodsCount <= 0) {
        [ToastUtils show:@"请选择您要进行结算的商品!"];
        return;
    }

    if (![Constants isLogin]) {
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }

    CheckoutViewController *checkoutViewController = [CheckoutViewController new];
    UINavigationController *vc = [[BaseNavigationController alloc] initWithRootViewController:checkoutViewController];
    [self presentViewController:vc animated:YES completion:nil];
}


/**
 * 购物车变化的通知
 */
- (void)cartChangedCompletion:(NSNotification *)notification {
    [self loadCart];
}

/**
 * 登录
 */
- (IBAction)login:(ESButton *)sender {
    [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
}

/**
 * 跳转到首页
 */
- (IBAction)toIndex {
    if (self.rdv_tabBarController == nil) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"index", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:nToRoot object:nil userInfo:userInfo];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    self.rdv_tabBarController.selectedIndex = 0;
}

@end
