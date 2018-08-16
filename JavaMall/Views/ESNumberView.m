//
// Created by Dawei on 3/24/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESNumberView.h"
#import "ESButton.h"
#import "NSString+Common.h"


@implementation ESNumberView {
    NSInteger min;
    NSInteger max;

    ESButton *less;
    ESButton *more;
    UITextField *valueText;

}

@synthesize value;
@synthesize numberChanged;

- (instancetype)initWithMin:(NSInteger)minNumber max:(NSInteger)maxNumber value:(NSInteger)_value{
    self = [super init];
    if (self) {
        min = minNumber;
        max = maxNumber;
        self.value = _value;
        [self createUI];
    }

    return self;
}

- (void) createUI{
    less = [[ESButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
    [less setImage:[UIImage imageNamed:@"number_less_disable"] forState:UIControlStateDisabled];
    [less setImage:[UIImage imageNamed:@"number_less_enable"] forState:UIControlStateNormal];
    [less setImage:[UIImage imageNamed:@"number_less_highLight"] forState:UIControlStateHighlighted];
    [less addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    less.enabled = (value > min);
    [self addSubview:less];

    valueText = [[UITextField alloc] initWithFrame:CGRectMake(25,0,40,25)];
    valueText.background = [UIImage imageNamed:@"number_middle_enable"];
    valueText.font = [UIFont systemFontOfSize:13];
    valueText.textAlignment = NSTextAlignmentCenter;
    valueText.secureTextEntry = NO;
    valueText.userInteractionEnabled = YES;
    valueText.keyboardType = UIKeyboardTypeNumberPad;
    valueText.returnKeyType = UIReturnKeyDone;
    valueText.delegate = self;
    self.value = value;
    [self addSubview:valueText];

    more = [[ESButton alloc] initWithFrame:CGRectMake(65,0,25,25)];
    [more setImage:[UIImage imageNamed:@"number_more_disable"] forState:UIControlStateDisabled];
    [more setImage:[UIImage imageNamed:@"number_more_enable"] forState:UIControlStateNormal];
    [more setImage:[UIImage imageNamed:@"number_more_highLight"] forState:UIControlStateHighlighted];
    [more addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    more.enabled = (value < max);
    [self addSubview:more];

}

- (void) action:(id) sender{
    NSInteger valueInText = [valueText.text intValue];
    if(sender == less) {
        if (valueInText > min) {
            valueText.text = [NSString stringWithFormat:@"%d", (--valueInText)];
        }
    }else{
        if(valueInText < max){
            valueText.text = [NSString stringWithFormat:@"%d", (++valueInText)];
        }
    }
    [self updateButtonState];
}

/**
 * 更新按钮状态
 */
- (void) updateButtonState{
    less.enabled = [valueText.text intValue] > min;
    more.enabled = [valueText.text intValue] < more;
    if(self.numberChanged != NULL){
        self.numberChanged([valueText.text intValue]);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL canEnd = [textField.text isInt] && ![textField.text hasPrefix:@"0"];
    if(canEnd){
        [self updateButtonState];
    }
    return canEnd;
}

- (NSInteger)value {
    return [valueText.text intValue];
}

- (void)setValue:(NSInteger)value1 {
    value = value1;
    valueText.text = [NSString stringWithFormat:@"%d", value];
    [self updateButtonState];
}


@end