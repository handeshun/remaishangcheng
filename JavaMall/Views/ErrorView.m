//
// Created by Dawei on 1/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ErrorView.h"
#import "Masonry.h"


@implementation ErrorView

- (instancetype)initWithTitle:(NSString *)errorText {
    self = [super init];
    if (self) {
        UIImageView *errorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_failure"]];
        [self addSubview:errorImage];
        [errorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.centerX.equalTo(self.mas_centerX);
        }];

        UILabel *errorLabel = [UILabel new];
        [errorLabel setText:errorText];
        [errorLabel setTextColor:[UIColor darkGrayColor]];
        [errorLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:errorLabel];
        [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(errorImage.mas_bottom).with.offset(10);
        }];
    }
    return self;
}

- (void) setGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer{
    [gestureRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:gestureRecognizer];
}

@end