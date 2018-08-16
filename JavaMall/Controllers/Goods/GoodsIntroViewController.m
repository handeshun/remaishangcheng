//
// Created by Dawei on 1/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Masonry.h"
#import "GoodsIntroViewController.h"
#import "UIImageView+WebCache.h"
#import "GoodsGallery.h"
#import "Goods.h"
#import "GoodsGalleryCell.h"
#import "GoodsNameCell.h"
#import "GoodsPropCell.h"
#import "GoodsCommentHeaderView.h"
#import "GoodsCommentCell.h"
#import "GoodsSpecCell.h"
#import "GoodsActivityCell.h"
#import "GoodsComment.h"
#import "NSString+Common.h"
#import "GoodsOperationView.h"
#import "GoodsStoreCell.h"
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
#import "GoodsBonusCell.h"
#import "GoodsBonusViewController.h"
#import "LBoprationView.h"

@implementation GoodsIntroViewController {
    ImagePlayerView *imagePlayerView;
    UIScrollView *contentView;
    UITableView *goodsTable;

    GoodsCommentHeaderView *commentHeaderView;

    GoodsGalleryCell *galleryCell;
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

    id <GoodsIntroDelegate> delegate;
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
    [self loadGllery];
    [self loadComment];
}

/**
 * 载入商品
 */
- (void)loadGoods {
    [goodsApi detail:goods.id success:^(Goods *_goods) {
        goods = _goods;
        activity = goods.activity;
        goods.buyCount = 1;
        [commentHeaderView configData:goods];
        [delegate setGoods:goods];
        
        if (self.backOprationView) {
            
            NSString *seckillStatus = [self backSeckillStatus:_goods.start_time end:_goods.end_time];
            
            self.backOprationView(_goods.is_seckill,seckillStatus);
        }

        [self loadStore];
    }        failure:^(NSError *error) {
        [ToastUtils show:@"载入商品失败!"];
    }];
    
}

/**
 * 返回秒杀的进行状态
 */
- (NSString *)backSeckillStatus:(long long)start end:(long long)end {
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSDate *beginDate=[NSDate dateWithTimeIntervalSince1970:start];
    NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:end];

    
    NSString *beginDateStr=[dateFor stringFromDate:beginDate];
    NSString *endDateStr=[dateFor stringFromDate:endDate];
    NSString *currentDateStr = [self getCurrentTimeStr:dateFor];
    
    //    NSString *currentDateStr = @"2017-11-26 18:12:00";
    //    NSString *beginDateStr=@"2017-11-26 18:00:00";
    //    NSString *endDateStr=@"2017-11-26 20:00:00";
    
    NSDate *currentDate = [dateFor dateFromString:currentDateStr];
    NSComparisonResult beginResult = [currentDate compare:beginDate];
    NSComparisonResult endResult = [currentDate compare:endDate];
    
    NSDate *fromDate =[[NSDate alloc] init];
    NSDate *toDate =[[NSDate alloc] init];
    if (beginResult==NSOrderedAscending) {
        return @"未开始";
    }else{
        if (endResult==NSOrderedAscending) {
            return @"立即秒杀";
        } else {
            return @"已结束";
        }
    }
}

- (NSString *)getCurrentTimeStr:(NSDateFormatter *)formatter {
    NSDate *dateNow = [NSDate date];
    return [formatter stringFromDate:dateNow];
}

/**
 * 载入相册
 */
- (void)loadGllery {
    [goodsApi gallery:goods.id success:^(NSMutableArray *galleryArray) {
        photos = galleryArray;
        [galleryCell reloadData];
    }         failure:^(NSError *error) {
        [ToastUtils show:@"载入相册失败!"];
    }];
}

/**
 * 载入评论
 */
- (void)loadComment {
    [commentApi hot:goods.id success:^(NSMutableArray *commentArray) {
        comments = commentArray;
        [goodsTable reloadData];
    }       failure:^(NSError *error) {
        [ToastUtils show:@"载入商品评论失败!"];
    }];
}

/**
 * 载入店铺信息
 */
- (void)loadStore {
    [storeApi detail:goods.store_id success:^(Store *_store) {
        store = _store;
        [delegate setStore:store];
        [self loadBonus];
    }        failure:^(NSError *error) {
        [ToastUtils show:@"载入店铺信息失败!"];
    }];
}

/**
 * 载入店铺优惠券
 */
-(void)loadBonus{
    [storeApi bonusList:store.id success:^(NSMutableArray *bonuses) {
        [bonusList addObjectsFromArray:bonuses];
        [goodsTable reloadData];
    } failure:^(NSError *error) {

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
    [goodsTable registerClass:[GoodsCommentCell class] forCellReuseIdentifier:kCellIdentifier_GoodsCommentCell];
    [goodsTable registerClass:[GoodsNameCell class] forCellReuseIdentifier:kCellIdentifier_GoodsNameCell];
    [goodsTable registerClass:[GoodsPropCell class] forCellReuseIdentifier:kCellIdentifier_GoodsPropCell];
    [goodsTable registerClass:[GoodsSpecCell class] forCellReuseIdentifier:kCellIdentifier_GoodsSpecCell];
    [goodsTable registerClass:[GoodsStoreCell class] forCellReuseIdentifier:kCellIdentifier_GoodsStoreCell];
    [goodsTable registerClass:[GoodsActivityCell class] forCellReuseIdentifier:kCellIdentifier_GoodsActivityCell];
    [goodsTable registerClass:[GoodsBonusCell class] forCellReuseIdentifier:kCellIdentifier_GoodsBonusCell];
    [contentView addSubview:goodsTable];
    [goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
                return [GoodsNameCell cellHeightWithObj:goods];
            case 2:
                return [GoodsSpecCell cellHeightWithObj:goods];
            case 3:
                return [GoodsPropCell cellHeightWithObj:goods];
            case 4:
                return [GoodsActivityCell cellHeightWithObj:activity];
            case 5:
                return [GoodsBonusCell cellHeightWithObj:bonusList];
            default:
                return 35;
        }
    } else if (indexPath.section == 1) {
        return [GoodsCommentCell cellHeightWithObj:[comments objectAtIndex:indexPath.row]];
    } else if (indexPath.section == 2) {
        return 220;
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
            return comments.count;
        case 2:
            return 1;
        default:
            return 0;
    }
}

/**
 * 几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
            GoodsNameCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsNameCell forIndexPath:indexPath];
            [cell configData:goods];
            return cell;
        }  else if (indexPath.row == 2) {
            if (goods.is_seckill == 1) {
                return [UITableViewCell new];
            }
            //规格
            GoodsSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsSpecCell forIndexPath:indexPath];
            [cell configData:goods];
            return cell;
        } else if (indexPath.row == 3) {
            //属性
            GoodsPropCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsPropCell forIndexPath:indexPath];
            [cell configData:goods];
            return cell;
        }else if (indexPath.row == 4) {
            //促销
            GoodsActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsActivityCell forIndexPath:indexPath];
            [cell configData:activity];
            if (activity == nil) {
                cell.hidden = YES;
            }
            return cell;
        }else if (indexPath.row == 5) {
            //优惠券
            GoodsBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsBonusCell forIndexPath:indexPath];
            [cell configData:bonusList];
            if (bonusList == nil || bonusList.count == 0) {
                cell.hidden = YES;
            }
            return cell;
        }
    } else if (indexPath.section == 1) {  //评论
        GoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsCommentCell forIndexPath:indexPath];
        [cell setDelegate:self];
        [cell configData:[comments objectAtIndex:indexPath.row]];
        return cell;
    } else if (indexPath.section == 2) {   //店铺信息
        GoodsStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsStoreCell forIndexPath:indexPath];
        [cell configData:store];
        [cell.gotoStoreBtn addTarget:self action:@selector(gotoStore) forControlEvents:UIControlEventTouchUpInside];
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
            return 8;
        case 2:
            return 45;
        default:
            return 0;
    }
}

/**
 * 表头高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }
    return 0;
}

/**
 * 表头视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        commentHeaderView = [[GoodsCommentHeaderView alloc] initWithGoods:goods];
        UITapGestureRecognizer *commentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showComment:)];
        [commentTapGesture setNumberOfTapsRequired:1];
        [commentHeaderView addGestureRecognizer:commentTapGesture];
        return commentHeaderView;
    }
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
        //点击商品标题,显示详情
        if (indexPath.row == 1) {
            [delegate showDetail];
            return;
        }
        //点击规格,显示规格选择菜单
        if (indexPath.row == 2) {
            [self.frostedViewController presentMenuViewController];
            return;
        }
        //显示促销活动信息
        if (indexPath.row == 4) {
            if (activity == nil)
                return;
            GoodsActivityViewController *goodsActivityViewController = [GoodsActivityViewController new];
            goodsActivityViewController.activity_id = activity.id;
            [self.frostedViewController.navigationController pushViewController:goodsActivityViewController animated:YES];
            return;
        }

        //领取优惠券
        if (indexPath.row == 5) {
            if (bonusList == nil || bonusList.count == 0)
                return;
            GoodsBonusViewController *goodsBonusViewController = [GoodsBonusViewController new];
            goodsBonusViewController.bonusArray = bonusList;
            goodsBonusViewController.storeid = store.id;
            [self.frostedViewController.navigationController pushViewController:goodsBonusViewController animated:YES];
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

/**
 * 点击商品评价,显示评论列表
 */
- (IBAction)showComment:(UITapGestureRecognizer *)gesture {
    [delegate showComment];
}

/**
 * 点击最下方的联系客服
 */
- (IBAction)connectService {
    [delegate connectService];
}

/**
 * 进入店铺
 */
- (IBAction)gotoStore {
    [delegate gotoStore];
}

@end

