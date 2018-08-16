//
// Created by Dawei on 5/15/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "FavoriteApi.h"
#import "HttpUtils.h"
#import "Favorite.h"
#import "Goods.h"
#import "NSDictionary+Common.h"
#import "Store.h"


@implementation FavoriteApi {

}

- (void)favorite:(NSInteger)goodsId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    if (goodsId <= 0) {
        failure([self createError:ESParameterError message:@"请选择您要收藏的商品!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/favorite/add.do?goodsid=%d", goodsId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"收藏商品失败,请您重试!"]);
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

- (void)batchFavorite:(NSMutableArray *)goodsIdArray success:(void (^)())success failure:(void (^)(NSError *error))failure {
    if (goodsIdArray == nil || goodsIdArray.count <= 0) {
        failure([self createError:ESParameterError message:@"请选择您要收藏的商品!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/favorite/batch-add.do?client=ios"];
    for (NSString *goodsid in goodsIdArray) {
        url = [url stringByAppendingFormat:@"&goodsids=%@", goodsid];
    }
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"收藏商品失败,请您重试!"]);
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


- (void)unfavorite:(NSInteger)goodsId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    if (goodsId <= 0) {
        failure([self createError:ESParameterError message:@"请选择您要取消收藏的商品!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/favorite/unfavorite.do?goodsid=%d", goodsId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"收藏商品失败,请您重试!"]);
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

- (void)list:(NSInteger)page success:(void (^)(NSMutableArray *favoriteArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/favorite/list.do?page=%d", page];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取收藏商品失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *favoriteArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [favoriteArray addObject:[self toFavorite:dictionary]];
        }
        success(favoriteArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)storeList:(NSInteger)page success:(void (^)(NSMutableArray *storeArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/favorite/store-list.do?page=%d", page];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取收藏店铺失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [storeArray addObject:[self toStore:dictionary]];
        }
        success(storeArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (Favorite *)toFavorite:(NSDictionary *)dic {
    Favorite *favorite = [Favorite new];
    favorite.id = [[dic objectForKey:@"favorite_id"] intValue];

    Goods *goods = [Goods new];
    goods.id = [[dic objectForKey:@"goods_id"] intValue];
    goods.name = [dic objectForKey:@"name"];
    goods.price = [[dic objectForKey:@"price"] doubleValue];
    if ([dic has:@"thumbnail"]) {
        goods.thumbnail = [dic objectForKey:@"thumbnail"];
    }
    if ([dic has:@"mktprice"]) {
        goods.marketPrice = [[dic objectForKey:@"mktprice"] doubleValue];
    }

    if ([dic has:@"comment_count"]) {
        goods.commentCount = [[dic objectForKey:@"comment_count"] intValue];
    }

    if ([dic has:@"buy_count"]) {
        goods.buyCount = [[dic objectForKey:@"buy_count"] intValue];
    }

    if ([dic has:@"product_id"]) {
        goods.productId = [[dic objectForKey:@"product_id"] intValue];
    }

    if ([dic has:@"enable_store"]) {
        goods.store = [[dic objectForKey:@"enable_store"] intValue];
    } else {
        if ([dic has:@"store"]) {
            goods.store = [[dic objectForKey:@"store"] intValue];
        }
    }

    if ([dic has:@"sn"]) {
        goods.sn = [dic objectForKey:@"sn"];
    }

    favorite.goods = goods;
    return favorite;
}

- (Store *)toStore:(NSDictionary *)dic {
    Store *store = [Store new];
    store.id = [dic intForKey:@"store_id"];
    store.name = [dic stringForKey:@"store_name"];
    store.store_level = [dic intForKey:@"store_level"];
    store.store_logo = [dic stringForKey:@"store_logo"];
    store.store_banner = [dic stringForKey:@"store_banner"];
    store.desc = [dic stringForKey:@"description"];
    store.store_recommend = [dic intForKey:@"store_recommend"];
    store.store_credit = [dic intForKey:@"store_credit"];
    store.praise_rate = [dic doubleForKey:@"praise_rate"];
    store.store_desccredit = [dic doubleForKey:@"store_desccredit"] > 0 ? [dic doubleForKey:@"store_desccredit"] : 5;
    store.store_servicecredit = [dic doubleForKey:@"store_servicecredit"] > 0 ? [dic doubleForKey:@"store_servicecredit"] : 5;
    store.store_deliverycredit = [dic doubleForKey:@"store_deliverycredit"] > 0 ? [dic doubleForKey:@"store_deliverycredit"] : 5;
    store.store_collect = [dic intForKey:@"store_collect"];
    store.goods_num = [dic intForKey:@"goods_num"];
    store.goodsList = [NSMutableArray arrayWithCapacity:0];
    if ([dic has:@"goodslist"]) {
        NSArray *list = [dic objectForKey:@"goodslist"];
        for (NSDictionary *goodsDic in list) {
            [store.goodsList addObject:[self toGoods:goodsDic]];
        }
    }
    return store;
}

- (Goods *)toGoods:(NSDictionary *)dic {
    Goods *goods = [Goods new];
    goods.id = [[dic objectForKey:@"goods_id"] intValue];
    goods.name = [dic objectForKey:@"name"];
    goods.marketPrice = [[dic objectForKey:@"mktprice"] doubleValue];
    goods.price = [[dic objectForKey:@"price"] doubleValue];
    goods.buyCount = [[dic objectForKey:@"num"] intValue];
    goods.thumbnail = [dic objectForKey:@"thumbnail"];
    goods.sn = [dic objectForKey:@"sn"];
    return goods;
}

@end