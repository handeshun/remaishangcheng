//
// Created by Dawei on 1/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CategoryApi.h"
#import "HttpUtils.h"
#import "GoodsCategory.h"


@implementation CategoryApi

/**
 * 载入所有分类
 */
- (void) loadAll:(void (^) (NSMutableArray *categories))success failure:(void (^) (NSError *error)) failure{
    [HttpUtils get:[kBaseUrl stringByAppendingString:@"/api/mobile/goodscat/list.do"] success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取分类列表失败!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [categoryArray addObject:[self toCategory:dictionary]];
        }
        success(categoryArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

- (GoodsCategory *) toCategory:(NSDictionary *) dictionary{
    GoodsCategory *category = [GoodsCategory new];
    category.id = [[dictionary objectForKey:@"cat_id"] intValue];
    category.name = [dictionary objectForKey:@"name"];
    category.level = [[dictionary objectForKey:@"level"] intValue];
    category.image = [dictionary objectForKey:@"image"];

    NSArray *childrenArray = [dictionary objectForKey:@"children"];
    if(childrenArray != nil && childrenArray.count > 0){
        category.children = [[NSMutableArray alloc] initWithCapacity:childrenArray.count];
        for (NSDictionary *dic in childrenArray) {
            [category.children addObject:[self toCategory:dic]];
        }
    }
    return category;
}

@end