//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Order.h"
#import "ActivityGift.h"
#import "Bonus.h"


@implementation Order {

}
- (NSString *)statusString {
    if(self.is_cancel > 0){
        return @"等待审核";
    }else {
        switch (self.status) {
            case OrderStatus_NOPAY:
                return @"等待付款";
            case OrderStatus_CONFIRM:
                return @"已确认";
            case OrderStatus_PAY:
                return @"已支付";
            case OrderStatus_SHIP:
                return @"已发货";
            case OrderStatus_ROG:
                return @"已收货";
            case OrderStatus_COMPLETE:
                return @"已完成";
            case OrderStatus_CANCELLATION:
                return @"已取消";
            case OrderStatus_MAINTENANCE:
                return @"申请售后";
        }
    }
    return @"状态错误";
}

- (BOOL)isCod {
    return [self.paymentType isEqualToString:@"cod"];
}


@end