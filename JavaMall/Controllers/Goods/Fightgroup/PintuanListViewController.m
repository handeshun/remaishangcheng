//
//  PintuanListViewController.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/27.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "PintuanListViewController.h"
#import "PintuanlistTableViewCell.h"
#import "HeaderView.h"
#import "AdaptationKit.h"
#import "HttpUtils.h"
#import "MemberApi.h"
#import "Constants.h"
#import "ToastUtils.h"
#import "MJRefresh.h"
#import "Goods.h"
#import "ControllerHelper.h"
#import "FightgroupsViewController.h"
@interface PintuanListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *news;
@property(nonatomic,strong)NSDictionary  *dataDic;

@end
static NSString *  LBHomeSecKillCellIdentifier =@"LBHomeSecKillCellIdentifier";
@implementation PintuanListViewController{
    HeaderView *headerView;
    MemberApi  *memberApi;
    NSInteger page;
    NSMutableArray *storeArray;
}
@synthesize keyword;
- (NSMutableArray *)news {
    
    if (!_news) {
        _news = [NSMutableArray arrayWithCapacity:20];
    }
    return _news;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[PintuanlistTableViewCell class] forCellReuseIdentifier:LBHomeSecKillCellIdentifier];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page++;
            [self getNetData];
        }];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = LBColor(245, 245, 245);
    
    memberApi = [MemberApi new];
    page = 1;
    if(keyword == nil || ![keyword isKindOfClass:[NSString class]] || keyword.length == 0){
        keyword = @"";
    }
    storeArray = [NSMutableArray arrayWithCapacity:0];
    
    [self setNav];
    
    [self.view addSubview:self.tableView];
    
    [self getNetData];
    // Do any additional setup after loading the view.
}
- (void)setNav {
    headerView = [[HeaderView alloc] initWithTitle:@"拼团"];
    [headerView setBackAction:@selector(backClick)];
    [self.view addSubview:headerView];
    
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getNetData {
    [ToastUtils showLoading];
    [memberApi pintuan:keyword page:page success:^(NSMutableArray *_storeList) {
        [ToastUtils hideLoading];
        if(page == 1){
            [storeArray removeAllObjects];
        }
        if (_storeList == nil || _storeList.count == 0) {
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        //没有更多数据时隐藏'加载更多'
        self.tableView.mj_footer.hidden = _storeList.count < 20;
        [self.tableView.mj_footer endRefreshing];
        [storeArray addObjectsFromArray:_storeList];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return storeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (storeArray.count > 0) {
        PintuanlistTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:LBHomeSecKillCellIdentifier forIndexPath:indexPath];
        [cell configData:[storeArray objectAtIndex:indexPath.row]];
        return cell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Goods *goods = storeArray[indexPath.row];
    FightgroupsViewController *pintuan = [[FightgroupsViewController alloc]initWithGoods:goods delegate:nil];;
    
    [self.navigationController pushViewController:pintuan animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AdaptationKit getVerticalSpace:600];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
