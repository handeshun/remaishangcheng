//
// Created by Dawei on 2/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsCommentCellFull.h"
#import "GoodsComment.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "UIImageView+WebCache.h"
#import "GoodsCommentImageDelegate.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "DateUtils.h"
#import "CommentImageCell.h"
@implementation GoodsCommentCellFull {
    UIView *header;
    UIImageView *face;
    UILabel *name;
    UILabel *date;
    UIImageView *star1;
    UIImageView *star2;
    UIImageView *star3;
    UIImageView *star4;
    UIImageView *star5;
    UICollectionViewFlowLayout *gridLayout;
    UICollectionView *commentImageView;
    UILabel *content;
    UIImage *normalImage;
    UIImage *selectedImage;

    id <GoodsCommentImageDelegate> delegate;

    GoodsComment *comment;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        normalImage = [UIImage imageNamed:@"ico_star2.png"];
        selectedImage = [UIImage imageNamed:@"ico_star1.png"];

        header = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreen_Width, 8)];
        header.backgroundColor = [UIColor colorWithHexString:@"#f1f0f5"];
        [self addSubview:header];

        //线
        UIView *headerBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 8, kScreen_Width, 0.5)];
        headerBottomLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:headerBottomLine];

        UIImage *defaultFace = [UIImage imageNamed:@"userheader"];
        face = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 30, 30)];
        face.image = defaultFace;
        [face borderWidth:0.0f color:[UIColor whiteColor] cornerRadius:15.0f];
        [self addSubview:face];

        name = [UILabel new];
        name.font = [UIFont systemFontOfSize:12];
        name.textColor = [UIColor darkGrayColor];
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(face.mas_right).offset(10);
            make.top.equalTo(self).offset(23);
        }];

        date = [UILabel new];
        date.font = [UIFont systemFontOfSize:12];
        date.textColor = [UIColor darkGrayColor];
        [self addSubview:date];
        [date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(23);
        }];

        //线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 48, kScreen_Width-10, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:line];

        star1 = [[UIImageView alloc] initWithImage:normalImage];
        star2 = [[UIImageView alloc] initWithImage:normalImage];
        star3 = [[UIImageView alloc] initWithImage:normalImage];
        star4 = [[UIImageView alloc] initWithImage:normalImage];
        star5 = [[UIImageView alloc] initWithImage:normalImage];
        [self addSubview:star1];
        [self addSubview:star2];
        [self addSubview:star3];
        [self addSubview:star4];
        [self addSubview:star5];

        content = [UILabel new];
        content.lineBreakMode = NSLineBreakByWordWrapping;
        content.font = [UIFont systemFontOfSize:12];
        content.numberOfLines = 0;

        [self addSubview:content];

        [star1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(55);
        }];
        [star2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(star1.mas_right).offset(3);
            make.top.equalTo(star1);
        }];
        [star3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(star2.mas_right).offset(3);
            make.top.equalTo(star1);
        }];
        [star4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(star3.mas_right).offset(3);
            make.top.equalTo(star1);
        }];
        [star5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(star4.mas_right).offset(3);
            make.top.equalTo(star1);
        }];

        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(@75);
        }];
        gridLayout = [[UICollectionViewFlowLayout alloc] init];
        gridLayout.itemSize = CGSizeMake(80, 80);
        gridLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        gridLayout.minimumLineSpacing = 5;
        gridLayout.minimumInteritemSpacing = 5;
        gridLayout.sectionInset = (UIEdgeInsets) {0, 5, 0, 5};
        commentImageView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 10,kScreen_Width, 600) collectionViewLayout:gridLayout];
        commentImageView.showsHorizontalScrollIndicator = NO;
        commentImageView.backgroundColor=[UIColor whiteColor];
        commentImageView.collectionViewLayout = gridLayout;
        commentImageView.delegate = self;
        commentImageView.dataSource = self;
        [commentImageView registerClass:[CommentImageCell class] forCellWithReuseIdentifier:@"grid"];
        [self addSubview:commentImageView];
        [commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content.mas_bottom).offset(10);
            make.left.right.equalTo(self).offset(5);
            make.width.equalTo(self);
            make.height.equalTo(@85);
        }];
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.and.right.and.bottom.equalTo(self);
        }];
    }
    return self;
}

/**
 *  获取item总和
 *
 *  @param collectionView <#collectionView description#>
 *  @param section        <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return comment.images.count;
}


/**
 *  绘制CollectionViewItem
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CommentImageCell *cell = [commentImageView dequeueReusableCellWithReuseIdentifier:@"grid" forIndexPath:indexPath];
    [cell config:[comment.images objectAtIndex:[indexPath row]]];
    return cell;
}

/**
 *  图片CollectionView点击事件
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 */
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (delegate != nil) {
        [delegate didTapImageAtIndex:[indexPath row] comment:comment];
    }
}


- (void)tapImage:(UITapGestureRecognizer *)gesture {
    UIImageView *photo = (UIImageView *) gesture.view;
    if (delegate != nil) {
        [delegate didTapImageAtIndex:photo.tag comment:comment];
    }
}

- (void)setDelegate:(id <GoodsCommentImageDelegate>)_delegate {
    delegate = _delegate;
}

+ (CGFloat)cellHeightWithObj:(id)obj {
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[GoodsComment class]]) {
        GoodsComment *comment = (GoodsComment *) obj;
        cellHeight = [comment.content getSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 20, 2000)].height;
        cellHeight += 85;
        if (comment.images != nil || comment.images.count > 0) {
            cellHeight += 90;
        }
    }
    return cellHeight;
}

- (void)configData:(GoodsComment *)_comment {
    [star1 setImage:_comment.grade > 0 ? selectedImage : normalImage];
    [star2 setImage:_comment.grade > 1 ? selectedImage : normalImage];
    [star3 setImage:_comment.grade > 1 ? selectedImage : normalImage];
    [star4 setImage:_comment.grade > 2 ? selectedImage : normalImage];
    [star5 setImage:_comment.grade > 2 ? selectedImage : normalImage];

    name.text = _comment.memberName;
    content.text = _comment.content;
    //头像
    if([_comment.memberFace isKindOfClass:[NSString class]] && _comment.memberFace.length > 0){
        [face sd_setImageWithURL:[NSURL URLWithString:_comment.memberFace]
                 placeholderImage:[UIImage imageNamed:@"userheader"]];
    }else{
        face.image = [UIImage imageNamed:@"userheader"];
    }

    //日期
    date.text = [DateUtils dateToString:_comment.date];

    comment = _comment;
    if (_comment.images==nil||_comment.images.count==0) {
        commentImageView.removeFromSuperview;
    }else{
        [self addSubview:commentImageView];
        [commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content.mas_bottom).offset(10);
            make.left.right.equalTo(self).offset(5);
            make.width.equalTo(self);
            make.height.equalTo(@85);
        }];
        commentImageView.reloadData;
    }
}


@end