//
// Created by Dawei on 1/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsApi.h"
#import "HttpUtils.h"
#import "Goods.h"
#import "GoodsFilter.h"
#import "GoodsFilterValue.h"
#import "GoodsGallery.h"
#import "GoodsSpec.h"
#import "GoodsSpecValue.h"
#import "NSDictionary+Common.h"
#import "Activity.h"
#import "DateUtils.h"
#import "ActivityGift.h"


@implementation GoodsApi {

}

/**
 * 载入分类下商品列表
 */
- (void) list:(NSMutableDictionary *) parameters success:(void (^) (NSMutableArray *goodsArray))success failure:(void (^) (NSError *error)) failure{
    if(parameters == nil || parameters.count == 0){
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    NSString *paramString = @"";
    for(NSString *key in parameters.allKeys){
        paramString = [paramString stringByAppendingFormat:@"&%@=%@", key, [parameters objectForKey:key]];
    }
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/list.do?client=ios%@", paramString] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取商品列表失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [goodsArray addObject:[self toGoods:dictionary]];
        }
        success(goodsArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

/**
 * 载入商品筛选器
 */
- (void) filters:(NSInteger) categoryId keyword:(NSString *)keyword success:(void (^) (NSMutableArray *filterArray))success failure:(void (^) (NSError *error)) failure{
    if(categoryId <= 0 && [keyword length] == 0){
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/goods/filter.do?client=ios"];
    if(categoryId > 0){
        url = [url stringByAppendingFormat:@"&cat=%d", categoryId];
    }
    if([keyword length] > 0){
        url = [url stringByAppendingFormat:@"&keyword=%@", keyword];
    }
    [HttpUtils get:url success:^(NSString *responseString){
        NSLog(responseString);
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取商品筛选器失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *filterArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [filterArray addObject:[self toGoodsFilter:dictionary]];
        }
        success(filterArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

/**
 * 载入商品相册
 */
- (void) gallery:(NSInteger)goodsId success:(void (^) (NSMutableArray *galleryArray))success failure:(void (^) (NSError *error)) failure{
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/gallery.do?goodsid=%d", goodsId] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取商品相册失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *galleryArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [galleryArray addObject:[self toGoodsGallery:dictionary]];
        }
        success(galleryArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

/**
 * 载入商品详情
 */
- (void) detail:(NSInteger)goodsId success:(void (^) (Goods *goods))success failure:(void (^) (NSError *error)) failure{
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/detail.do?goodsid=%zd", goodsId] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取商品信息失败,请您重试!"]);
            return;
        }
        NSDictionary *data = [resultJSON objectForKey:DATA_KEY];
        success([self toGoods:data]);
    } failure:^(NSError *error){
        failure(error);
    }];
}

/**
 * 载入拼团详情
 */
- (void) pintuan:(NSInteger)goodsId productid:(NSInteger)productid success:(void (^)(Goods *))success failure:(void (^)(NSError *))failure {
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/get-pintuan-goods-detail.do?goods_id=%zd&&product_id=%zd", goodsId,productid] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取拼团信息失败,请您重试!"]);
            return;
        }
        NSDictionary *data = [resultJSON objectForKey:DATA_KEY];
        success([self toGoods:data]);
    } failure:^(NSError *error){
        failure(error);
    }];
}

/**
 * 获取一个商品的规格
 */
- (void) spec:(NSInteger)goodsId success:(void (^) (NSMutableArray *specs, NSMutableDictionary *productDic))success failure:(void (^) (NSError *error)) failure{
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/spec.do?goodsid=%d", goodsId] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取商品规格失败,请您重试!"]);
            return;
        }

        NSDictionary *data = [resultJSON objectForKey:DATA_KEY];
        if([data objectForKey:@"have_spec"] == nil ||
                [[data objectForKey:@"have_spec"] intValue] == 0){
            success(nil, nil);
            return;
        }

        NSArray *specArray = [data objectForKey:@"specList"];
        NSMutableArray *specs = [NSMutableArray arrayWithCapacity:specArray.count];
        for(NSDictionary *specDic in specArray){
            [specs addObject:[self toGoodsSpec:specDic]];
        }

        NSArray *productArray = [data objectForKey:@"productList"];
        NSMutableDictionary *productDic = [NSMutableDictionary dictionaryWithCapacity:productArray.count];
        for(NSDictionary *product in productArray){
            Goods *goods = [self toGoods:product];
            [productDic setValue:goods forKey:goods.specKey];
        }

        success(specs, productDic);

    } failure:^(NSError *error){
        failure(error);
    }];
}



/**
 * 载入热卖商品列表
 */
- (void) hotlist:(NSInteger)page success:(void (^) (NSMutableArray *goodsArray))success failure:(void (^) (NSError *error)) failure{
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/listbytag.do?client=ios&tagid=1&page=%d", page] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取热卖商品失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [goodsArray addObject:[self toGoods:dictionary]];
        }
        success(goodsArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

/**
 * 载入促销活动详情
 * @param activityId
 * @param success
 * @param failure
 */
- (void)activity:(NSInteger)activityId success:(void (^)(Activity *activity))success failure:(void (^)(NSError *error))failure {
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/activity.do?activity_id=%d", activityId] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取促销活动信息失败,请您重试!"]);
            return;
        }
        NSDictionary *data = [resultJSON objectForKey:DATA_KEY];
        success([self toActivity:data]);
    } failure:^(NSError *error){
        failure(error);
    }];
}
/**
 * 加入购物车
 * @param activityId
 * @param success
 * @param failure
 */
-(void)addcar:(NSInteger)pintuan product:(NSInteger)productid num:(NSInteger)nums success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/cart/add.do?productid=%zd&num=%zd", productid,nums] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil ){
            failure([self createError:ESDataError message:@"获取促销活动信息失败,请您重试!"]);
            return;
        }
     //   NSDictionary *data = [resultJSON objectForKey:DATA_KEY];
        success(resultJSON);
    } failure:^(NSError *error){
        failure(error);
    }];
    
}

/**
 * 通过SN获取goodid
 */

- (void) bySNgetGoodid:(NSInteger)sn success:(void (^)(Goods *))success failure:(void (^)(NSError *))failure {
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/app/scan.do?sn=%zd", sn] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取拼团信息失败,请您重试!"]);
            return;
        }
        success([self toGoods:resultJSON]);
    } failure:^(NSError *error){
        failure(error);
    }];
}

- (NSMutableDictionary *) formatFilter:(NSMutableArray *)filters{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(filters == nil || filters.count == 0){
        return parameters;
    }
    for(GoodsFilter *filter in filters){
        if(filter.selectedValue == nil || [filter.selectedValue.value length] == 0)
            continue;
        if([filter.type isEqualToString:@"prop"]){
            NSString *propValue = [parameters objectForKey:@"prop"];
            if([propValue length] == 0){
                [parameters setObject:filter.selectedValue.value forKey:@"prop"];
                continue;
            }
            propValue = [propValue stringByAppendingFormat:@"@%@", filter.selectedValue.value];
            [parameters setObject:propValue forKey:@"prop"];

        }else{
            [parameters setObject:filter.selectedValue.value forKey:filter.type];
        }
    }
    return parameters;
}

- (GoodsGallery *) toGoodsGallery:(NSDictionary *) dic{
    GoodsGallery *gallery = [GoodsGallery new];
    gallery.goodsId = [[dic objectForKey:@"goods_id"] intValue];
    gallery.imageId = [[dic objectForKey:@"img_id"] intValue];
    gallery.thumbnail = [dic objectForKey:@"thumbnail"];
    gallery.small = [dic objectForKey:@"small"];
    gallery.big = [dic objectForKey:@"big"];
    gallery.original = [dic objectForKey:@"original"];
    return gallery;
}


- (Goods *) toGoods:(NSDictionary *) dic{
    Goods *goods = [Goods new];
    goods.id = [[dic objectForKey:@"goods_id"] intValue];
    goods.name = [dic objectForKey:@"name"];
    goods.price = [[dic objectForKey:@"price"] doubleValue];
    
    
    if([dic has:@"thumbnail"]) {
        goods.thumbnail = [dic objectForKey:@"thumbnail"];
    }
    if([dic has:@"mktprice"]) {
        goods.marketPrice = [[dic objectForKey:@"mktprice"] doubleValue];
    }

    if([dic has:@"comment_count"]) {
        goods.commentCount = [[dic objectForKey:@"comment_count"] intValue];
    }

    if([dic has:@"buy_count"]) {
        goods.buyCount = [[dic objectForKey:@"buy_count"] intValue];
    }

    if([dic has:@"product_id"]){
        goods.productId = [[dic objectForKey:@"product_id"] intValue];
    }
    
    if([dic has:@"sn"]){
        goods.sn = [dic objectForKey:@"sn"];
    }

    if([dic has:@"weight"]){
        goods.weight = [[dic objectForKey:@"weight"] doubleValue];
    }

    if([dic has:@"comment_percent"]){
        goods.goodCommentPercent = [dic objectForKey:@"comment_percent"];
    }

    if([dic has:@"favorited"]){
        goods.favorited = [[dic objectForKey:@"favorited"] boolValue];
    }

    if([dic has:@"specs"]){
        goods.specs = [dic objectForKey:@"specs"];
    }

    NSArray *specArray = [dic objectForKey:@"specList"];
    if(specArray != nil && ![specArray isKindOfClass:[NSNull class]] && specArray.count > 0){
        goods.specDic = [NSMutableDictionary dictionaryWithCapacity:specArray.count];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        NSMutableArray *specValueArray = [NSMutableArray arrayWithCapacity:specArray.count];
        for(NSDictionary *spec in specArray){
            int specValueId = [[spec objectForKey:@"spec_value_id"] intValue];
            int specId = [[spec objectForKey:@"spec_id"] intValue];
            [specValueArray addObject:[NSNumber numberWithInt:specValueId]];
            [goods.specDic setValue:[NSNumber numberWithInt:specValueId] forKey:[NSNumber numberWithInt:specId]];
        }
        [specValueArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        goods.specKey = [specValueArray componentsJoinedByString:@"-"];
    }

    if([dic has:@"activity"]){
        goods.activity = [self toActivity:[dic objectForKey:@"activity"]];
    }
    if([dic has:@"store_id"]){
        goods.store_id = [dic intForKey:@"store_id"];
    }

#pragma mark 拼团
    if([dic has:@"goodsGalleryList"]){
       goods.goodCommentPercent = [dic objectForKey:@"goodsGalleryList"];
    }
    
    if([dic has:@"is_pintuan"]){
       goods.is_pintuan = [[dic objectForKey:@"is_pintuan"] intValue];
    }
    
    if([dic has:@"pintuan_price"]){
        goods.pintuan_price = [[dic objectForKey:@"pintuan_price"] floatValue];
    }
    if([dic has:@"start_time"]){
       goods.start_time = [[dic objectForKey:@"start_time"] integerValue];
    }
    if([dic has:@"end_time"]){
       goods.end_time = [[dic objectForKey:@"end_time"] integerValue];
    }
    if([dic has:@"pintuan_peoplecount"]){
       goods.pintuan_peoplecount = [[dic objectForKey:@"pintuan_peoplecount"] intValue];
    }
    if([dic has:@"deposit"]){
        goods.deposit = [[dic objectForKey:@"deposit"] floatValue];
    }
    if([dic has:@"shareurl"]){
       goods.shareurl = [dic objectForKey:@"shareurl"];
    }
    if([dic has:@"modelList"]){
       goods.modelList = [dic objectForKey:@"modelList"];
    }
    if([dic has:@"peoplecount"]){
        goods.peoplecount = [[dic objectForKey:@"peoplecount"] intValue];
    }

#pragma mark - 秒杀
    goods.is_seckill = [dic intForKey:@"is_seckill"];
    goods.start_time = [dic longlongForKey:@"seckill_start_time"];
    goods.end_time = [dic longlongForKey:@"seckill_end_time"];
    goods.seckill_price = [dic doubleForKey:@"seckill_price"];
    goods.activity_id = [dic intForKey:@"seckill_activity_id"];
//    goods.enable_store = [dic intForKey:@"seckill_goods_enable_store"];
    
    if ([dic has:@"is_seckill"]) {
        if (goods.is_seckill == 0) {
            if([dic has:@"enable_store"]){
                goods.store = [[dic objectForKey:@"enable_store"] intValue];
            }else{
                if([dic has:@"store"]){
                    goods.store = [[dic objectForKey:@"store"] intValue];
                }
            }
        }else {
            if([dic has:@"seckill_goods_enable_store"]){
                goods.store = [[dic objectForKey:@"seckill_goods_enable_store"] intValue];
            }
        }
    }
#pragma mark - 扫码
    if([dic has:@"data"]){
        goods.id = [dic intForKey:@"data"];
    }
    
    return goods;
}

- (GoodsFilter *) toGoodsFilter:(NSDictionary *) dic{
    GoodsFilter *filter = [GoodsFilter new];
    filter.name = [dic objectForKey:@"name"];
    filter.type = [dic objectForKey:@"type"];
    filter.values = [NSMutableArray arrayWithCapacity:1];

    //默认
    GoodsFilterValue *defaultValue = [GoodsFilterValue new];
    defaultValue.name = @"全部";
    defaultValue.value = @"";
    defaultValue.selected = YES;
    [filter.values addObject:defaultValue];

    NSArray *valueArray = [dic objectForKey:@"valueList"];
    if(valueArray != nil && valueArray.count > 0){
        for(NSDictionary *value in valueArray){
            GoodsFilterValue *filterValue = [GoodsFilterValue new];
            filterValue.name = [value objectForKey:@"name"];
            filterValue.value = [value objectForKey:@"value"];
            filterValue.selected = NO;
            [filter.values addObject:filterValue];
        }
    }
    return filter;
}

- (GoodsSpec *) toGoodsSpec:(NSDictionary *) dic{
    GoodsSpec *spec = [GoodsSpec new];
    spec.id = [[dic objectForKey:@"spec_id"] intValue];
    spec.name = [dic objectForKey:@"spec_name"];
    NSArray *valueArray = [dic objectForKey:@"valueList"];
    if(valueArray != nil && valueArray.count > 0){
        spec.specValues = [NSMutableArray arrayWithCapacity:valueArray.count];
        for(NSDictionary *valueDic in valueArray){
            [spec.specValues addObject:[self toGoodsSpecValue:valueDic]];
        }
    }
    return spec;
}

- (GoodsSpecValue *) toGoodsSpecValue:(NSDictionary *) dic{
    GoodsSpecValue *specValue = [GoodsSpecValue new];
    specValue.valueId = [[dic objectForKey:@"spec_value_id"] intValue];
    specValue.name = [dic objectForKey:@"spec_value"];
    specValue.image = [dic objectForKey:@"spec_image"];
    return specValue;
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

@end
