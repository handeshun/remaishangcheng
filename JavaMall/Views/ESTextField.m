//
// Created by Dawei on 5/27/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESTextField.h"


@implementation ESTextField {

}

//控制 placeHolder 的位置，左右缩 5
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 0 );
}

// 控制文本的位置，左右缩 5
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 0 );
}

@end