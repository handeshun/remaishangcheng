//
// Created by Dawei on 5/15/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartApi.h"
#import "HttpUtils.h"
#import "Cart.h"
#import "Goods.h"
#import "CartGoods.h"
#import "NSDictionary+Common.h"
#import "StorePrice.h"
#import "Store.h"
#import "ShipType.h"
#import "Bonus.h"
#import "DateUtils.h"
#import "Activity.h"
#import "ActivityGift.h"


@implementation CartApi

- (void)addSeckill:(NSInteger)productId count:(NSInteger)count activity_id:(NSInteger)activity_id success:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure {
    if (productId <= 0) {
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/add.do?productid=%zd&num=%zd", productId, count];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"添加商品到购物车商品失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([[resultJSON objectForKey:@"count"] intValue]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)add:(NSInteger)productId count:(NSInteger)count success:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure {
    if (productId <= 0) {
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/add.do?productid=%zd&num=%zd", productId, count];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"添加商品到购物车商品失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([[resultJSON objectForKey:@"count"] intValue]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)count:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/cart/count.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取购物车数据失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESDataError message:@"获取购物车数据失败,请您重试!"]);
            return;
        }
        success([[[resultJSON objectForKey:@"data"] objectForKey:@"count"] integerValue]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)list:(void (^)(Cart *cart))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/cart/list.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        NSDictionary *dataDic = [resultDic objectForKey:DATA_KEY];
        if (dataDic == nil) {
            failure([self createError:ESDataError message:@"载入购物车商品失败,请您重试!"]);
            return;
        }

        NSArray *storeArray = [dataDic objectForKey:@"storelist"];
        if (storeArray == nil) {
            failure([self createError:ESDataError message:@"载入购物车商品失败,请您重试!"]);
            return;
        }

        Cart *cart = [Cart new];
        NSMutableArray *storeList = [NSMutableArray arrayWithCapacity:storeArray.count];
        for (NSDictionary *dic in storeArray) {
            [storeList addObject:[self toStore:dic]];
        }
        cart.storeList = storeList;
        cart.total = [[dataDic objectForKey:@"total"] doubleValue];
        cart.count = [[dataDic objectForKey:@"count"] intValue];
        success(cart);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)listSelected:(void (^)(Cart *cart))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/cart/list-selected.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        NSDictionary *storeArray = [resultDic objectForKey:DATA_KEY];
        if (storeArray == nil) {
            failure([self createError:ESDataError message:@"载入购物车商品失败,请您重试!"]);
            return;
        }
        Cart *cart = [Cart new];
        NSMutableArray *storeList = [NSMutableArray arrayWithCapacity:storeArray.count];
        for (NSDictionary *dic in storeArray) {
            [storeList addObject:[self toStore:dic]];
        }
        cart.storeList = storeList;
        success(cart);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)updateNumber:(NSInteger)cartId number:(NSInteger)number productId:(NSInteger)productId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    if (productId <= 0 || cartId <= 0) {
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    if (number <= 0) {
        failure([self createError:ESParameterError message:@"购物车商品数据不能为0!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/update.do?cartid=%d&num=%d&productid=%d", cartId, number, productId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"更新购物车商品数量失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)delete:(NSMutableArray *)cartIds success:(void (^)(NSInteger cartItemCount))success failure:(void (^)(NSError *error))failure {
    if (cartIds == nil || cartIds.count <= 0) {
        failure([self createError:ESParameterError message:@"请选择您要删除的购物车商品!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/delete.do?client=ios"];
    for (NSString *cartid in cartIds) {
        url = [url stringByAppendingFormat:@"&cartids=%@", cartid];
    }
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"从购物中商品商品失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([[resultJSON objectForKey:@"count"] intValue]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)check:(NSInteger)productId checked:(BOOL)checked success:(void (^)(BOOL result))success failure:(void (^)(NSError *error))failure {
    if (productId <= 0) {
        failure([self createError:ESParameterError message:@"请选择商品后再进行此项操作!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/check-product.do?product_id=%d&checked=%@", productId, (checked ? @"true" : @"false")];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"选择商品失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success(YES);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)checkAll:(BOOL)checked success:(void (^)(BOOL result))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/check-all.do?checked=%@", (checked ? @"true" : @"false")];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"选择商品失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success(YES);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)checkStore:(NSInteger)storeId checked:(BOOL)checked success:(void (^)(BOOL result))success failure:(void (^)(NSError *error))failure {
    if (storeId <= 0) {
        failure([self createError:ESParameterError message:@"请选择店铺后再进行此项操作!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/check-store.do?store_id=%d&checked=%@", storeId, (checked ? @"true" : @"false")];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"选择店铺失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success(YES);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}


- (CartGoods *)toCartGoods:(NSDictionary *)dic {
    CartGoods *goods = [CartGoods new];
    goods.cartId = [[dic objectForKey:@"id"] intValue];
    goods.id = [[dic objectForKey:@"goods_id"] intValue];
    goods.productId = [[dic objectForKey:@"product_id"] intValue];
    goods.name = [dic objectForKey:@"name"];
    goods.marketPrice = [[dic objectForKey:@"mktprice"] doubleValue];
    goods.price = [[dic objectForKey:@"price"] doubleValue];
    goods.buyCount = [[dic objectForKey:@"num"] intValue];
    goods.thumbnail = [dic objectForKey:@"image_default"];
    goods.sn = [dic objectForKey:@"sn"];
    goods.subTotal = [[dic objectForKey:@"subtotal"] doubleValue];
    if ([dic has:@"specs"] && [[dic objectForKey:@"specs"] isKindOfClass:[NSString class]]) {
        goods.specs = [dic objectForKey:@"specs"];
    }
    if ([dic has:@"is_check"]) {
        goods.checked = ([[dic objectForKey:@"is_check"] intValue] == 1);
    }
    if([dic has:@"activity_id"]){
        goods.activity_id = [dic intForKey:@"activity_id"];
    }
    
    if([dic has:@"is_seckill"]){
        goods.is_seckill = [dic intForKey:@"is_seckill"];
    }
    return goods;
}

- (StorePrice *)toStorePrice:(NSDictionary *)dic {
    StorePrice *storePrice = [StorePrice new];
    storePrice.goodsPrice = [dic doubleForKey:@"goodsPrice"];
    storePrice.orderPrice = [dic doubleForKey:@"orderPrice"];
    storePrice.shippingPrice = [dic doubleForKey:@"shippingPrice"];
    storePrice.needPayMoney = [dic doubleForKey:@"needPayMoney"];
    storePrice.discountPrice = [dic doubleForKey:@"discountPrice"];
    storePrice.weight = [dic doubleForKey:@"weight"];
    storePrice.point = [dic intForKey:@"point"];
    storePrice.actDiscount = [dic doubleForKey:@"actDiscount"];
    storePrice.gift_id = [dic intForKey:@"gift_id"];
    storePrice.bonus_id = [dic intForKey:@"bonus_id"];
    storePrice.is_free_ship = [dic intForKey:@"is_free_ship"];
    storePrice.act_free_ship = [dic intForKey:@"act_free_ship"];
    storePrice.exchange_point = [dic intForKey:@"exchange_point"];
    storePrice.activity_point = [dic intForKey:@"activity_point"];
    return storePrice;
}

- (ShipType *)toShipType:(NSDictionary *)dic {
    ShipType *shipType = [ShipType new];
    shipType.name = [dic stringForKey:@"name"];
    shipType.shipPrice = [dic doubleForKey:@"shipPrice"];
    shipType.type_id = [dic intForKey:@"type_id"];
    return shipType;
}

-(Activity *)toActivity:(NSDictionary *)dic{
    Activity *activity = [Activity new];
    activity.id = [dic intForKey:@"activity_id"];
    activity.name = [dic stringForKey:@"activity_name"];
    activity.startTime = [DateUtils timestampToDate:[dic intForKey:@"start_time"]];
    activity.endTime = [DateUtils timestampToDate:[dic intForKey:@"end_time"]];
    activity.desc = [dic stringForKey:@"description"];
    if([dic has:@"full_money"]){
        activity.full_money = [dic doubleForKey:@"full_money"];
    }
    if([dic has:@"minus_value"]){
        activity.minus_value = [dic doubleForKey:@"minus_value"];
    }
    if([dic has:@"point_value"]){
        activity.point_value = [dic intForKey:@"point_value"];
    }
    if([dic has:@"is_full_minus"]){
        activity.full_minus = ([dic intForKey:@"is_full_minus"] == 1);
    }
    if([dic has:@"is_free_ship"]){
        activity.free_ship = ([dic intForKey:@"is_free_ship"] == 1);
    }
    if([dic has:@"is_send_point"]){
        activity.send_point = ([dic intForKey:@"is_send_point"] == 1);
    }
    if([dic has:@"is_send_gift"]){
        activity.send_gift = ([dic intForKey:@"is_send_gift"] == 1);
    }
    if([dic has:@"is_send_bonus"]){
        activity.send_bonus = ([dic intForKey:@"is_send_bonus"] == 1);
    }
    if([dic has:@"gift_id"]){
        activity.gift_id = [dic intForKey:@"gift_id"];
    }
    if([dic has:@"bonus_id"]){
        activity.bonus_id = [dic intForKey:@"bonus_id"];
    }
    if([dic has:@"gift"]){
        activity.gift = [self toActivityGift:[dic objectForKey:@"gift"]];
    }

    return activity;
}

-(ActivityGift *)toActivityGift:(NSDictionary *)dic{
    ActivityGift *gift = [ActivityGift new];
    gift.id = [dic intForKey:@"gift_id"];
    gift.name = [dic stringForKey:@"gift_name"];
    gift.price = [dic doubleForKey:@"gift_price"];
    gift.img = [dic stringForKey:@"gift_img"];
    gift.enableStore = [dic intForKey:@"enable_store"];
    return gift;
}

- (Bonus *)toBonus:(NSDictionary *)dic {
    Bonus *bonus = [Bonus new];
    bonus.id = [dic intForKey:@"bonus_id"];
    bonus.money = [dic doubleForKey:@"type_money"];
    bonus.minAmount = [dic doubleForKey:@"min_goods_amount"];
    bonus.startDate = [DateUtils timestampToDate:[dic intForKey:@"use_start_date"]];
    bonus.endDate = [DateUtils timestampToDate:[dic intForKey:@"use_end_date"]];
    bonus.type = [dic intForKey:@"bonus_type"];
    bonus.sn = [dic stringForKey:@"bonus_sn"];
    bonus.store_id = [dic intForKey:@"store_id"];
    return bonus;
}

- (Store *)toStore:(NSDictionary *)dic {
    Store *store = [Store new];
    store.id = [dic intForKey:@"store_id"];
    store.name = [dic stringForKey:@"store_name"];
    store.goodsList = [NSMutableArray arrayWithCapacity:0];
    if ([dic has:@"storeprice"]) {
        store.storePrice = [self toStorePrice:[dic objectForKey:@"storeprice"]];
    }
    if ([dic has:@"goodslist"]) {
        NSArray *list = [dic objectForKey:@"goodslist"];
        for (NSDictionary *goodsDic in list) {
            [store.goodsList addObject:[self toCartGoods:goodsDic]];
        }
    }
    if ([dic has:@"shiplist"]) {
        NSArray *list = [dic objectForKey:@"shiplist"];
        store.shipList = [NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary *shipDic in list) {
            [store.shipList addObject:[self toShipType:shipDic]];
        }
    }
    if([dic has:@"bonuslist"]){
        NSArray *list = [dic objectForKey:@"bonuslist"];
        store.bonusList = [NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary *bonusDic in list) {
            Bonus *bonus = [self toBonus:bonusDic];
            bonus.store_name = store.name;
            [store.bonusList addObject:bonus];
        }
    }
    if([dic has:@"activity_id"]){
        store.activity_id = [dic intForKey:@"activity_id"];
    }
    if([dic has:@"activity_name"]){
        store.activity_name = [dic stringForKey:@"activity_name"];
    }
    if([dic has:@"activity"]){
        store.activity = [self toActivity:[dic objectForKey:@"activity"]];
    }
    if([dic has:@"storeAddr"])
    {
        store.storeAddr = [dic stringForKey:@"storeAddr"];
    }
    return store;
}

@end
