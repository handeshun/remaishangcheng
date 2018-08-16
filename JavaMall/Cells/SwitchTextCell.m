//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SwitchTextCell.h"
#import "ESLabel.h"
#import "Masonry.h"


@implementation SwitchTextCell {
    ESLabel *titleLbl;
    UISwitch *switchBtn;
    UIView *footerView;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#676767"] fontSize:14];
        [self addSubview:titleLbl];

        switchBtn = [UISwitch new];
        switchBtn.onTintColor = [UIColor colorWithHexString:@"#f16264"];
        [switchBtn addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:switchBtn];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerView];

        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}

- (IBAction)switchValueChanged {
    if (self.switchChangedBlock) {
        self.switchChangedBlock(switchBtn.on);
    }
}

- (void)setSwitchOn:(BOOL)on {
    [switchBtn setOn:on animated:YES];
}

- (void)setTitle:(NSString *)title {
    titleLbl.text = title;
}

@end