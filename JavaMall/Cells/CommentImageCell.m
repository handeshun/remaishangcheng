//
//  CommentImageCell.m
//  JavaMall
//
//  Created by LDD on 17/7/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "CommentImageCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@implementation CommentImageCell{
    UIImageView *imageview;
}

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imageview = [UIImageView new];
        [self addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self);
        }];
        imageview.layer.cornerRadius=5;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
    }
    return self;
}

-(void) config: (NSString *) imageUrl{
    [imageview sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"image_empty"]];
}

@end
