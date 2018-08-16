//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "InputTextCell.h"
#import "ESTextField.h"
#import "ESLabel.h"
#import "Masonry.h"


@implementation InputTextCell {
    UIView *headerLine;
    UIView *footerLine;
}

@synthesize textField, titleLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#676767"] fontSize:14];
        [self addSubview:titleLbl];

        textField = [ESTextField new];
        [textField setFont:[UIFont systemFontOfSize:14]];
        [textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        [self addSubview:textField];

        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];

        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.height.equalTo(self);
            make.left.equalTo(titleLbl.mas_right).offset(10);
        }];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(headerLine);
        }];
    }
    return self;
}

- (IBAction)editDidEnd:(id)sender {
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.textField.text);
    }
}

- (IBAction)textValueChanged:(id)sender {
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}

- (void)setTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder {
    titleLbl.text = [NSString stringWithFormat:@"%@:", title];
    textField.placeholder = placeHolder;
}

- (void)setValue:(NSString *)value {
    textField.text = value;
}

- (void)showLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine {
    [headerLine setHidden:!showHeaderLine];
    [footerLine setHidden:!showFooterLine];
}


@end