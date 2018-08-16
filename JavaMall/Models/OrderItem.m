//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "OrderItem.h"
#import "ActivityGift.h"


@implementation OrderItem {

}

- (NSString *)stateString {
    switch (_state){
        case OrderItemState_NORMAL:
            return @"正常";
        case OrderItemState_APPLY_RETURN:
            return @"申请退货中";
        case OrderItemState_APPLY_CHANGE:
            return @"申请换货中";
        case OrderItemState_REFUSE_RETURN:
            return @"退货已拒绝";
        case OrderItemState_REFUSE_CHANGE:
            return @"换货已拒绝";
        case OrderItemState_RETURN_PASSED:
            return @"退货审核已通过";
        case OrderItemState_CHANGE_PASSED:
            return @"换货审核已通过";
        case OrderItemState_RETURN_REC:
            return @"退货已收到";
        case OrderItemState_CHANGE_REC:
            return @"换货已收到";
        case OrderItemState_RETURN_END:
            return @"退货完成";
        case OrderItemState_CHANGE_END:
            return @"换货完成";
    }
    return @"";
}

@end