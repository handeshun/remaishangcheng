//
// Created by Dawei on 11/2/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreApi.h"
#import "Store.h"
#import "HttpUtils.h"
#import "NSDictionary+Common.h"
#import "Bonus.h"
#import "DateUtils.h"
#import "Goods.h"
#import "StoreCategory.h"


@implementation StoreApi {

}

- (void)detail:(NSInteger)storeId success:(void (^)(Store *store))success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/detail.do?storeid=%d", storeId] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取店铺信息失败,请您重试!"]);
            return;
        }
        NSDictionary *data = [resultJSON objectForKey:DATA_KEY];
        success([self toStore:data]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)bonusList:(NSInteger)storeId success:(void (^)(NSMutableArray *bonuses))success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/bonus-list.do?storeid=%d", storeId] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取优惠券信息失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];
        NSMutableArray *bonuses = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dic in dataArray) {
            [bonuses addObject:[self toBonus:dic]];
        }
        success(bonuses);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getBonus:(NSInteger)storeId type_id:(NSInteger)type_id success:(void (^)())success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/b2b2c/bonus/receive-bonus.do?store_id=%d&type_id=%d", storeId, type_id] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"领取优惠券失败,请您重试!"]);
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


- (void)indexGoods:(NSInteger)storeId success:(void (^)(NSMutableDictionary *goodsDic))success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/index-goods.do?storeid=%d", storeId] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取商品信息失败,请您重试!"]);
            return;
        }
        NSDictionary *data = [resultJSON objectForKey:DATA_KEY];

        NSMutableDictionary *goodsDic = [NSMutableDictionary dictionaryWithCapacity:3];
        NSArray *marks = @[@"new", @"hot", @"recommend"];
        for (NSString *mark in marks) {
            NSArray *array = [data objectForKey:mark];
            NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:array.count];
            for (NSDictionary *dic in array) {
                [goodsArray addObject:[self toGoods:dic]];
            }
            [goodsDic setObject:goodsArray forKey:mark];
        }
        success(goodsDic);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)tagGoods:(NSInteger)storeId tag:(NSString *)tag page:(NSInteger)page success:(void (^)(NSMutableArray *goodsList))success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/tag-goods.do?storeid=%d&tag=%@&page=%d", storeId, tag, page] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取商品失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];
        NSMutableArray *goodsList = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dic in dataArray) {
            [goodsList addObject:[self toGoods:dic]];
        }
        success(goodsList);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)goodsList:(NSInteger)storeId parameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *goodsList))success failure:(void (^)(NSError *error))failure {
    if (parameters == nil || parameters.count == 0) {
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    if(storeId == 0)
        storeId = 1;
    NSString *paramString = @"";
    for (NSString *key in parameters.allKeys) {
        paramString = [paramString stringByAppendingFormat:@"&%@=%@", key, [parameters objectForKey:key]];
    }
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/goods-list.do?storeid=%d%@", storeId, paramString] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取商品列表失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [goodsArray addObject:[self toGoods:dictionary]];
        }
        success(goodsArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)collect:(NSInteger)storeId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/collect.do?storeid=%d", storeId] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"关注店铺失败,请您重试!"]);
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

- (void)uncollect:(NSInteger)storeId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/uncollect.do?storeid=%d", storeId] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"取消关注店铺失败,请您重试!"]);
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

- (void)category:(NSInteger)storeId success:(void (^)(NSMutableArray *catgories))success failure:(void (^)(NSError *error))failure {
    if(storeId == 0)
        storeId = 1;
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/category.do?storeid=%d", storeId] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取商品分类失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dictionary in dataArray) {
            [categoryArray addObjectsFromArray:[self toStoreCategories:dictionary]];
        }
        success(categoryArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)search:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSMutableArray *storeList))success failure:(void (^)(NSError *error))failure {
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/store/search.do?keyword=%@&page=%d", keyword, page] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"搜索店铺失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *storeList = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [storeList addObject:[self toStore:dictionary]];
        }
        success(storeList);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}


- (Store *)toStore:(NSDictionary *)dic {
    Store *store = [Store new];
    if(![dic isEqual:[NSNull null]])
    {
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
    if ([dic has:@"new_num"]) {
        store.new_num = [dic intForKey:@"new_num"];
    }
    if ([dic has:@"hot_num"]) {
        store.hot_num = [dic intForKey:@"hot_num"];
    }
    if ([dic has:@"recommend_num"]) {
        store.recommend_num = [dic intForKey:@"recommend_num"];
    }
    if ([dic has:@"favorited"]) {
        store.favorited = ([dic intForKey:@"favorited"] == 1);
    }
    store.goodsList = [NSMutableArray arrayWithCapacity:0];
    if([dic has:@"goodsList"]){
        NSArray *list = [dic objectForKey:@"goodsList"];
        for (NSDictionary *goodsDic in list) {
            [store.goodsList addObject:[self toGoods:goodsDic]];
        }
    }
    }
    return store;
}

- (Bonus *)toBonus:(NSDictionary *)dic {
    Bonus *bonus = [Bonus new];
    bonus.id = 0;
    bonus.name = [dic stringForKey:@"type_name"];
    bonus.money = [dic doubleForKey:@"type_money"];
    bonus.minAmount = [dic doubleForKey:@"min_goods_amount"];
    bonus.startDate = [DateUtils timestampToDate:[dic intForKey:@"use_start_date"]];
    bonus.endDate = [DateUtils timestampToDate:[dic intForKey:@"use_end_date"]];
    bonus.type = [dic intForKey:@"type_id"];
    return bonus;
}

- (Goods *)toGoods:(NSDictionary *)dic {
    Goods *goods = [Goods new];
    goods.id = [dic intForKey:@"goods_id"];
    goods.name = [dic stringForKey:@"name"];
    goods.thumbnail = [dic stringForKey:@"thumbnail"];
    goods.price = [dic doubleForKey:@"price"];
    goods.marketPrice = [dic doubleForKey:@"mktprice"];
    return goods;
}

- (NSMutableArray *)toStoreCategories:(NSDictionary *)dic {
    NSMutableArray *categories = [NSMutableArray arrayWithCapacity:0];
    [categories addObject:[self toStoreCategory:dic]];

    if ([dic has:@"children"]) {
        NSArray *array = [dic objectForKey:@"children"];
        if (array != nil && array.count > 0) {
            for(NSDictionary *d in array){
                [categories addObject:[self toStoreCategory:d]];
            }
        }
    }

    return categories;
}

- (StoreCategory *)toStoreCategory:(NSDictionary *)dic {
    StoreCategory *category = [StoreCategory new];
    category.cat_id = [dic intForKey:@"store_cat_id"];
    category.parent_id = [dic intForKey:@"store_cat_pid"];
    category.name = [dic stringForKey:@"store_cat_name"];
    return category;
}

@end
