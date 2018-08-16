//
// Created by Dawei on 10/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsActivityViewController.h"
#import "HeaderView.h"
#import "GoodsApi.h"
#import "Masonry.h"
#import "ActivityContentCell.h"
#import "ActivityContentDescCell.h"
#import "ToastUtils.h"
#import "Activity.h"
#import "DateUtils.h"
#import "ActivityGift.h"
#import "NSString+Common.h"


@implementation GoodsActivityViewController {
    HeaderView *headerView;
    UITableView *myTable;

    GoodsApi *goodsApi;
    Activity *activity;
}

@synthesize activity_id;

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];

    goodsApi = [GoodsApi new];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"活动详情";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[ActivityContentCell class] forCellReuseIdentifier:kCellIdentifier_ActivityContentCell];
    [myTable registerClass:[ActivityContentDescCell class] forCellReuseIdentifier:kCellIdentifier_ActivityContentDescCell];
    [self.view addSubview:myTable];
    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [goodsApi activity:activity_id success:^(Activity *_activity) {
        [ToastUtils hideLoading];
        activity = _activity;
        [myTable reloadData];
    }          failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 55;
    }else if(indexPath.row == 1){
        return 55;
    }else if(indexPath.row == 2){
        return 55;
    }else if(indexPath.row == 3){
        NSString *condtion = [self condtion];
        float height = [condtion getSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width-20, 100)].height;
        return height + 40;
    } else if (indexPath.row == 4) {
        float height = kScreen_Height - 60;  //减去头部高度
        height = height - 55 * 3;   //减去其它三行高度
        height = height - [[self condtion] getSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width-20, 100)].height - 40;   //减去活动优惠条件的高度
        return height;
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 3) {
        ActivityContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ActivityContentCell forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                [cell configData:@"活动名称" content:activity.name icon:[UIImage imageNamed:@"activity_name.png"]];
                break;
            case 1:
                [cell configData:@"活动日期"
                         content:[NSString stringWithFormat:@"%@ - %@", [DateUtils dateToString:activity.startTime withFormat:@"yyyy-MM-dd HH:mm:ss"], [DateUtils dateToString:activity.endTime withFormat:@"yyyy-MM-dd HH:mm:ss"]]
                            icon:[UIImage imageNamed:@"activity_date.png"]];
                break;
            case 2:
                [cell configData:@"基础订单金额" content:[NSString stringWithFormat:@"￥%.2f（单笔订单购满此金额即可享受优惠）", activity.full_money] icon:[UIImage imageNamed:@"activity_money.png"]];
                break;
            case 3:
                [cell configData:@"活动优惠条件" content:[self condtion] icon:[UIImage imageNamed:@"activity_condtion.png"]];
                break;
        }
        return cell;
    } else if (indexPath.row == 4) {
        ActivityContentDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ActivityContentDescCell forIndexPath:indexPath];
        [cell configData:@"活动描述" content:activity.desc icon:[UIImage imageNamed:@"activity_description.png"]];
        return cell;
    }
    return nil;
}

/**
 * 获取优惠条件
 * @return
 */
- (NSString *)condtion {
    NSMutableArray *condtionArray = [NSMutableArray arrayWithCapacity:0];
    if(activity.full_minus){
        [condtionArray addObject:@"满减现金"];
    }
    if(activity.free_ship){
        [condtionArray addObject:@"满免邮费"];
    }
    if(activity.send_point){
        [condtionArray addObject:@"满送积分"];
    }
    if(activity.send_bonus){
        [condtionArray addObject:@"满送优惠券"];
    }
    if(activity.send_gift && activity.gift != nil){
        NSString *giftString = @"满送赠品";
        if(activity.gift.enableStore <= 0){
            giftString = [giftString stringByAppendingString:@"(已赠完)"];
        }else{
            giftString = [giftString stringByAppendingFormat:@"(剩余%d份)", activity.gift.enableStore];
        }
        [condtionArray addObject:giftString];
    }
    return [condtionArray componentsJoinedByString:@" "];
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
    return 0.01f;
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
@end