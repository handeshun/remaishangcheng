//
//  FightgroupsViewController.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/25.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "FightgroupsViewController.h"
#import "ESButton.h"
#import <UShareUI/UShareUI.h>
#import "HeaderView.h"

#import "GoodsIntroViewController.h"
#import "UIImageView+WebCache.h"
#import "GoodsGallery.h"
#import "Goods.h"
#import "GoodsGalleryCell.h"
#import "GroupNameTableViewCell.h"
#import "DiscountTableViewCell.h"
#import "ControllerHelper.h"
#import "GoodsViewController.h"
#import "GroupNumTableViewCell.h"
#import "LeftTimeTableViewCell.h"
#import "GoodsComment.h"
#import "NSString+Common.h"
#import "GoodsOperationView.h"
#import "PintuanRuleTableViewCell.h"
#import "REFrostedViewController.h"
#import "ViewPagerController.h"
#import "GoodsApi.h"
#import "CommentApi.h"
#import "MWPhotoBrowser.h"
#import "ToastUtils.h"
#import "Constants.h"
#import "Setting.h"
#import "GoodsActivityViewController.h"
#import "Store.h"
#import "StoreApi.h"
#import "GoodintroduceTableViewCell.h"
#import "GoodsBonusViewController.h"
#import "Masonry.h"
#import "CheckoutViewController.h"
#import "BaseNavigationController.h"
@interface FightgroupsViewController ()
{
    HeaderView *headerView;
    ImagePlayerView *imagePlayerView;
    UIScrollView *contentView;
    UITableView *goodsTable;
    
    
    
    GoodsGalleryCell *galleryCell;
    GroupNameTableViewCell *nameCell;
    NSMutableArray *photos;
    MWPhotoBrowser *galleryBrowser;
    
    NSMutableArray *comments;
    NSArray *commentPhotos;
    MWPhotoBrowser *commentBrowser;
    
    Goods *goods;
    Activity *activity;
    Store *store;
    NSMutableArray *bonusList;
    
    //API
    GoodsApi *goodsApi;
    CommentApi *commentApi;
    StoreApi *storeApi;
    
    //底部拼团
    UIButton * pintuanPriceBtn;
    UIButton * pintuanNow;
    id <GoodsIntroDelegate> delegate;
    
}
@end

@implementation FightgroupsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    headerView = [[HeaderView alloc] initWithTitle:@"拼团商品详情"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    
//    ESButton *shareBtn = [[ESButton alloc] initWithFrame:CGRectMake(kScreen_Width - 44, 20, 40, 40)];
//    [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//    [shareBtn setContentMode:UIViewContentModeCenter];
//    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:shareBtn];
}

#pragma 事件

/**
 * 点击左上方的后退按钮
 */
- (IBAction)back {
   
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    
}

/**
 * 分享
 */
- (IBAction)share {
    //显示分享面板
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        NSString *urlString = goods.thumbnail;
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
//        UIImage *image = [UIImage imageWithData:data];
//        //创建分享消息对象
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//        //创建网页内容对象
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:goods.name descr:goods.name thumImage:image];
//        NSLog(goods.thumbnail);
//        //设置网页地址
//        shareObject.webpageUrl = [kBaseUrl stringByAppendingFormat:@"/goods-%d.html", goods.id];
//
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//
//        //调用分享接口
//        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//            if (error) {
//                UMSocialLogInfo(@"************Share fail with error %@*********",error);
//                [ToastUtils show:@"取消分享！"];
//            }else{
//                [ToastUtils show:@"分享成功！"];
//            }
//        }];
//
//    }];
}

- (instancetype)initWithGoods:(Goods *)_goods delegate:(id <GoodsIntroDelegate>)_delegate {
    self = [super init];
    if (self) {
        goods = _goods;
        goods.buyCount = 1;
        delegate = _delegate;
        
        photos = [NSMutableArray arrayWithCapacity:1];
        GoodsGallery *defaultGallery = [GoodsGallery new];
        defaultGallery.big = goods.thumbnail;
        defaultGallery.imageId = 1;
        [photos addObject:defaultGallery];
    }
    return self;
}

- (void)setGoods:(Goods *)_goods {
    goods = _goods;
    [goodsTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    goodsApi = [GoodsApi new];
    commentApi = [CommentApi new];
    storeApi = [StoreApi new];
    bonusList = [NSMutableArray arrayWithCapacity:0];
    
    [self createTableView];
    [self loadGoods];
   
  
}

/**
 * 载入商品
 */
- (void)loadGoods {

    [goodsApi pintuan:goods.id productid:goods.productId success:^(Goods *_goods) {
        goods = _goods;
                activity = goods.activity;
                goods.buyCount = 1;
        [pintuanPriceBtn setTitle:[NSString stringWithFormat:@"拼团：¥ %0.2f",goods.deposit] forState:UIControlStateNormal];
        NSMutableArray *picArr= [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *picdic in goods.goodsGalleryList)
        {
            [picArr addObject:picdic[@"big"]];
        }
        
        [photos addObjectsFromArray:picArr];
        [galleryCell reloadData];
                [delegate setGoods:goods];
               
    } failure:^(NSError *error) {
        [ToastUtils show:@"载入商品失败!"];
    }];

}

/**
 * 初始化表格
 */
- (void)createTableView {
    contentView = [UIScrollView new];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    goodsTable = [UITableView new];
    goodsTable.dataSource = self;
    goodsTable.delegate = self;
    goodsTable.backgroundColor = [UIColor colorWithHexString:@"#f1f0f5"];
    goodsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [goodsTable registerClass:[GoodsGalleryCell class] forCellReuseIdentifier:kCellIdentifier_GoodsGalleryCell];
   
    [goodsTable registerClass:[GroupNameTableViewCell class] forCellReuseIdentifier:kCellIdentifier_GroupNameCell];
    [goodsTable registerClass:[DiscountTableViewCell class] forCellReuseIdentifier:kCellIdentifier_DiscountCell];
    [goodsTable registerClass:[GroupNumTableViewCell class] forCellReuseIdentifier:kCellIdentifier_GroupSpecCell];
    [goodsTable registerClass:[PintuanRuleTableViewCell class] forCellReuseIdentifier:kCellIdentifier_pintuanRuleCell];
    [goodsTable registerClass:[LeftTimeTableViewCell class] forCellReuseIdentifier:kCellIdentifier_LeftTimeCell];
    [goodsTable registerClass:[GoodintroduceTableViewCell class] forCellReuseIdentifier:kCellIdentifier_GoodsintroduceCell];
    [contentView addSubview:goodsTable];
    [goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(60);
        make.bottom.equalTo(self.view.mas_bottom).offset(45);
    }];
    
    UIView *underLineView = [[UIView alloc]init];
    [contentView addSubview:underLineView];
    underLineView.backgroundColor = LBColor(221, 221, 221);
    
    pintuanPriceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pintuanPriceBtn.backgroundColor = [UIColor whiteColor];
    [pintuanPriceBtn setTitleColor:LBColor(254, 52, 90 ) forState:UIControlStateNormal];
    [pintuanPriceBtn setTitleColor:LBColor(254, 52, 90) forState:UIControlStateHighlighted];
    [contentView addSubview:pintuanPriceBtn];
    
    pintuanNow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pintuanNow.backgroundColor = LBColor(254, 52, 90);
    [pintuanNow setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [pintuanNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pintuanNow setTitle:@"立即拼团 >>" forState:UIControlStateNormal];
    [pintuanNow addTarget:self action:@selector(pintuanPayBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:pintuanNow];
    
    [underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.height.equalTo(@0.5);
    }];
    
    [pintuanPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.top.equalTo(underLineView.mas_bottom);
        make.width.equalTo(@(kScreen_Width/2));
    }];
    
    [pintuanNow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.top.equalTo(underLineView.mas_bottom);
        make.width.equalTo(@(kScreen_Width/2));
    }];
}
#pragma mark  去拼团
-(void)pintuanPayBtnDown
{
    [goodsApi addcar:1 product:goods.productId num:1 success:^(NSDictionary *resultDict) {
        NSLog(@"%@",resultDict);
        CheckoutViewController *checkoutViewController = [CheckoutViewController new];
        UINavigationController *vc = [[BaseNavigationController alloc] initWithRootViewController:checkoutViewController];
        [self presentViewController:vc animated:YES completion:nil];
    } failure:^(NSError *error) {
        [ToastUtils show:@"加入购物车失败!"];
    }];
}
/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return [GoodsGalleryCell cellHeightWithObj:goods];
            case 1:
                return [GroupNameTableViewCell cellHeightWithObj:goods];
            case 2:
                return [GroupNumTableViewCell cellHeightWithObj:goods];
            case 3:
                return [DiscountTableViewCell cellHeightWithObj:goods];
            case 4:
                return [LeftTimeTableViewCell cellHeightWithObj:activity];
            case 5:
                return [GoodintroduceTableViewCell cellHeightWithObj:bonusList];
            default:
                return 35;
        }
    }  else if (indexPath.section == 1) {
        return 400;
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 6;
        case 1:
            return 1;
        default:
            return 0;
    }
}

/**
 * 几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            galleryCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsGalleryCell forIndexPath:indexPath];
            [galleryCell setDelegate:self];
            return galleryCell;
        } else if (indexPath.row == 1) {
            //商品名称
            GroupNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GroupNameCell forIndexPath:indexPath];
            [cell configData:goods];
            return cell;
        }  else if (indexPath.row == 2) {
            //规格
            GroupNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GroupSpecCell forIndexPath:indexPath];
            [cell configData:goods];
            return cell;
        } else if (indexPath.row == 3) {
            //属性
            DiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DiscountCell forIndexPath:indexPath];
            [cell configData:goods];
            return cell;
        }else if (indexPath.row == 4) {
            //促销
            LeftTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LeftTimeCell forIndexPath:indexPath];
            [cell configData:goods];
         
            return cell;
        }else if (indexPath.row == 5) {
            //优惠券
            GoodintroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsintroduceCell forIndexPath:indexPath];
           
            
            return cell;
        }
    }  else if (indexPath.section == 1) {   //店铺信息
        PintuanRuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_pintuanRuleCell forIndexPath:indexPath];
        
        return cell;
    }
    return [UITableViewCell new];
}

/**
 * 表尾高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 8;
        case 1:
            return 50;
       
        default:
            return 0;
    }
}

/**
 * 表头高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 15;
    }
    return 0;
}

/**
 * 表头视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    return nil;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        
        //点击规格,显示规格选择菜单
        if (indexPath.row == 2) {
            [self.frostedViewController presentMenuViewController];
            return;
        }
      
        
        //跳转商品详情页面
        if (indexPath.row == 5) {
            if(goods)
            {
            goods.goodCommentPercent= @"";
            UIViewController *goodsViewController = [ControllerHelper createGoodsViewController:goods];
            [self.navigationController pushViewController:goodsViewController animated:YES];
            }
            return;
        }
    }
}

#pragma mark - ImagePlayerViewDelegate

- (NSInteger)numberOfItems {
    return photos.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index {
    GoodsGallery *gallery = [photos objectAtIndex:index];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:gallery.big]
                 placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
}


- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index {
    GoodsGallery *gallery = [photos objectAtIndex:index];
    
    galleryBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    galleryBrowser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    galleryBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    galleryBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    galleryBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    galleryBrowser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    galleryBrowser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    galleryBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    galleryBrowser.autoPlayOnAppear = NO; // Auto-play first video
    [galleryBrowser setCurrentPhotoIndex:index];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:galleryBrowser];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (photoBrowser == galleryBrowser) {
        return photos.count;
    } else if (photoBrowser == commentBrowser) {
        if (commentPhotos != nil) {
            return commentPhotos.count;
        }
    }
    return 0;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (photoBrowser == galleryBrowser) {
        if (index < photos.count) {
            GoodsGallery *gallery = [photos objectAtIndex:index];
            return [MWPhoto photoWithURL:[NSURL URLWithString:gallery.big]];
        }
    } else if (photoBrowser == commentBrowser) {
        if (commentPhotos != nil && index < commentPhotos.count) {
            return [MWPhoto photoWithURL:[NSURL URLWithString:[commentPhotos objectAtIndex:index]]];
        }
    }
    return nil;
}

#pragma 评论图片

- (void)didTapImageAtIndex:(NSInteger)index comment:(GoodsComment *)comment {
    commentPhotos = comment.images;
    
    commentBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    commentBrowser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    commentBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    commentBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    commentBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    commentBrowser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    commentBrowser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    commentBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    commentBrowser.autoPlayOnAppear = NO; // Auto-play first video
    [commentBrowser setCurrentPhotoIndex:index];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:commentBrowser];
    [self presentViewController:nc animated:YES completion:nil];
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
