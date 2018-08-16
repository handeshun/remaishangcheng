//
// Created by Dawei on 1/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsCommentViewController.h"
#import "GoodsCommentCellFull.h"
#import "Masonry.h"
#import "GoodsComment.h"
#import "CommentHeaderView.h"
#import "MWPhotoBrowser.h"
#import "CommentApi.h"
#import "ToastUtils.h"
#import "MJRefresh.h"

@implementation GoodsCommentViewController {
    UITableView *commentTable;
    CommentHeaderView *headerView;
    NSMutableArray *comments;
    UIView *noDataView;

    NSArray *commentPhotos;
    MWPhotoBrowser *commentBrowser;

    CommentApi *commentApi;
    int page;
    int type;
}

@synthesize goodsId;

- (void)viewDidLoad {
    [super viewDidLoad];

    commentApi = [CommentApi new];
    page = 1;
    type = 0;

    [self createHeader];
    [self createTable];

    [self loadCount];
    [self loadComment];

}

/**
 * 创建顶部的评论类型切换视图
 */
- (void)createHeader {
    headerView = [[CommentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    [self.view addSubview:headerView];
    headerView.touchAtIndex = ^(NSInteger index) {
        page = 1;
        [comments removeAllObjects];
        type = index - 1;
        [self loadComment];
    };
    headerView.allNumber = 0;
    headerView.goodNumber = 0;
    headerView.generalNumber = 0;
    headerView.poorNumber = 0;
    headerView.imageNumber = 0;
}

/**
 * 创建评论列表
 */
- (void)createTable {
    commentTable = [UITableView new];
    commentTable.dataSource = self;
    commentTable.delegate = self;
    commentTable.backgroundColor = [UIColor colorWithHexString:@"#f1f0f5"];
    commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [commentTable registerClass:[GoodsCommentCellFull class] forCellReuseIdentifier:kCellIdentifier_GoodsCommentCellFull];
    commentTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadComment];
    }];
    [self.view addSubview:commentTable];
    [commentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
}

- (void)loadCount {
    [commentApi count:goodsId success:^(NSMutableArray *commentCountArray) {
        headerView.allNumber = [[commentCountArray objectAtIndex:0] intValue];
        headerView.goodNumber = [[commentCountArray objectAtIndex:1] intValue];
        headerView.generalNumber = [[commentCountArray objectAtIndex:2] intValue];
        headerView.poorNumber = [[commentCountArray objectAtIndex:3] intValue];
        headerView.imageNumber = [[commentCountArray objectAtIndex:4] intValue];
    }         failure:^(NSError *error) {
        [ToastUtils show:@"载入商品评论数量失败!"];
    }];
}

- (void)loadComment {
    if (noDataView != nil) {
        [noDataView removeFromSuperview];
    }
    [ToastUtils showLoading];
    [commentApi list:goodsId type:type page:page
             success:^(NSMutableArray *commentArray) {
                 if (comments == nil) {
                     comments = [NSMutableArray arrayWithCapacity:commentArray.count];
                 }
                 [ToastUtils hideLoading];
                 if (page == 1) {
                     [comments removeAllObjects];
                 }
                 commentTable.mj_footer.hidden = commentArray.count < 20;   //没有更多数据时隐藏'加载更多'
                 [commentTable.mj_footer endRefreshing];
                 [comments addObjectsFromArray:commentArray];
                 [commentTable reloadData];
             }
             failure:^(NSError *error) {
                DebugLog(@"%@", [error description]);
                [ToastUtils hideLoading];
            }];
}

/**
 * 显示没有数据
 */
- (void)showNoData {
    if (noDataView == nil) {
        noDataView = [UIView new];
        UILabel *nodataLabel = [UILabel new];
        [nodataLabel setText:@"抱歉，没有符合条件的评论"];
        [nodataLabel setTextColor:[UIColor darkGrayColor]];
        [nodataLabel setFont:[UIFont systemFontOfSize:14]];
        [noDataView addSubview:nodataLabel];
        [nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(noDataView);
        }];
    }
    [self.view addSubview:noDataView];
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerY.width.equalTo(self.view);
        make.height.equalTo(@25);
    }];
}

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GoodsCommentCellFull cellHeightWithObj:[comments objectAtIndex:indexPath.row]];
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
        return 1;
    return comments.count;
}

/**
 * 几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f1f0f5"];
        return cell;
    }
    GoodsCommentCellFull *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GoodsCommentCellFull forIndexPath:indexPath];
    [cell setDelegate:self];
    [cell configData:[comments objectAtIndex:indexPath.row]];
    return cell;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (commentPhotos != nil) {
        return commentPhotos.count;
    }
    return 0;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (commentPhotos != nil && index < commentPhotos.count) {
        return [MWPhoto photoWithURL:[NSURL URLWithString:[commentPhotos objectAtIndex:index]]];
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

@end