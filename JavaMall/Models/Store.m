//
// Created by Dawei on 11/1/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Store.h"
#import "StorePrice.h"
#import "CartGoods.h"
#import "ShipType.h"
#import "Bonus.h"
#import "Activity.h"


@implementation Store {

}

- (BOOL)checked {
    if(self.goodsList == nil || self.goodsList.count == 0)
        return NO;
    BOOL c = YES;
    for(CartGoods *cartGoods in self.goodsList){
        if(!cartGoods.checked){
            c = NO;
            break;
        }
    }
    return c;
}

- (BOOL)selected {
    if(self.goodsList == nil || self.goodsList.count == 0)
        return NO;
    BOOL s = YES;
    for(CartGoods *cartGoods in self.goodsList){
        if(!cartGoods.selected){
            s = NO;
            break;
        }
    }
    return s;
}

@end