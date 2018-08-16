//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PostCommentViewController.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "PostCommentGradeCell.h"
#import "PostCommentContentCell.h"
#import "PostCommentAddImageCell.h"
#import "ESButton.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RedButtonCell.h"
#import "Goods.h"
#import "ESRedButton.h"
#import "GoodsComment.h"
#import "ESTextView.h"
#import "ToastUtils.h"
#import "CommentApi.h"
#import "TZImagePickerController.h"
#import "PostCommentImageCell.h"


@implementation PostCommentViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *commentTable;

    PostCommentGradeCell *gradeCell;
    PostCommentContentCell *contentCell;
    PostCommentAddImageCell *imageCell;

    CommentApi *commentApi;

    NSArray *assets;
    NSArray<UIImage *> *photos;
}

@synthesize goods;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];

    commentApi = [CommentApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"评价晒单"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
}

- (void)setupUI {
    commentTable = [TPKeyboardAvoidingTableView new];
    commentTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTable.dataSource = self;
    commentTable.delegate = self;
    [commentTable registerClass:[PostCommentGradeCell class] forCellReuseIdentifier:kCellIdentifier_PostCommentGradeCell];
    [commentTable registerClass:[PostCommentContentCell class] forCellReuseIdentifier:kCellIdentifier_PostCommentContentCell];
    [commentTable registerClass:[PostCommentAddImageCell class] forCellReuseIdentifier:kCellIdentifier_PostCommentAddImageCell];
    [commentTable registerClass:[PostCommentImageCell class] forCellReuseIdentifier:kCellIdentifier_PostCommentImageCell];
    [commentTable registerClass:[RedButtonCell class] forCellReuseIdentifier:kCellIdentifier_RedButtonCell];
    [self.view addSubview:commentTable];
    [commentTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}


/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 90;
        } else if (indexPath.row == 1) {
            return 110;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == photos.count) {
            return 50;
        }
        return 160;
    }else if (indexPath.section == 2) {
        return 70;
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section){
        case 0:
            return 2;
        case 1:
            return photos.count + 1;
        case 2:
            return 1;
    }
    return 0;
}

/**
 * 有几个区
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
            gradeCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PostCommentGradeCell forIndexPath:indexPath];
            gradeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [gradeCell configData:goods];
            return gradeCell;
        } else if (indexPath.row == 1) {
            contentCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PostCommentContentCell forIndexPath:indexPath];
            contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return contentCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == photos.count) {
            imageCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PostCommentAddImageCell forIndexPath:indexPath];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [imageCell.imageBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
            return imageCell;
        }
        PostCommentImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PostCommentImageCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:[photos objectAtIndex:indexPath.row]];
        return cell;
    }else if (indexPath.section == 2) {
        RedButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
        [cell.button setTitle:@"提交评论" forState:UIControlStateNormal];
        cell.button.enabled = YES;
        [cell.button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
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
    if(section != 2) {
        return 10;
    }
    return 0.01f;
}

/**
 * 每个区的头部视图
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
    if(indexPath.section == 1){
        [self addImage:nil];
    }
}

/**
 * 添加晒单照片
 */
- (IBAction)addImage:(ESButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.selectedAssets = assets;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *_photos, NSArray *_assets, BOOL isSelectOriginalPhoto) {
        assets = _assets;
        photos = _photos;
        [commentTable reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 * 提交评论
 */
- (IBAction)submit:(ESButton *)sender {
    GoodsComment *comment = [GoodsComment new];
    comment.goodsId = goods.id;
    comment.grade = gradeCell.grade;
    comment.content = contentCell.contentTV.text;
    comment.imageFiles = [NSMutableArray arrayWithCapacity:0];
    [comment.imageFiles addObjectsFromArray:photos];
    if(comment.grade <= 0 || comment.grade > 5){
        [ToastUtils show:@"请选择您对此商品的评分!"];
        return;
    }
    if(comment.content == nil || comment.content.length <= 0 ){
        [ToastUtils show:@"请输入您的评论内容!"];
        return;
    }
    if(comment.content.length > 500){
        [ToastUtils show:@"评论内容不能超过500个字!"];
        return;
    }
    [ToastUtils showLoading];
    [commentApi create:comment success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"发表评论成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:nPostComment object:nil];
        [self back];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
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