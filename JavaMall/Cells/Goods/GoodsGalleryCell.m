//
// Created by Dawei on 2/2/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsGalleryCell.h"
#import "UIView+Common.h"

@implementation GoodsGalleryCell {
    ImagePlayerView *imagePlayerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 300)];
        imagePlayerView.scrollInterval = 2.0f;
        imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
        imagePlayerView.hidePageControl = NO;
        [imagePlayerView bottomBorder:[UIColor colorWithHexString:kBorderLineColor]];
        [self addSubview:imagePlayerView];
    }
    return self;
}

- (void)setDelegate:(id <ImagePlayerViewDelegate>)delegate {
    imagePlayerView.imagePlayerViewDelegate = delegate;
    [imagePlayerView reloadData];
}

- (void)reloadData {
    if (imagePlayerView != nil)
        [imagePlayerView reloadData];
}

+ (CGFloat)cellHeightWithObj:(id)obj {
    return 300;
}

@end