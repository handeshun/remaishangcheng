//
// Created by Dawei on 3/27/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CommentApi.h"
#import "HttpUtils.h"
#import "GoodsComment.h"
#import "DateUtils.h"
#import "Goods.h"
#import "UIImage+Common.h"
#import "NSDictionary+Common.h"


@implementation CommentApi {

}

- (void) list:(NSInteger)goodsId type:(NSInteger)type page:(NSInteger)page success:(void (^) (NSMutableArray *commentArray))success failure:(void (^) (NSError *error)) failure{
    if(goodsId <= 0){
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    if(page <= 0){
        page = 1;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/comment/list.do?goodsid=%d&page=%d", goodsId, page];
    switch (type){
        case 0: //全部
            url = [url stringByAppendingFormat:@"&min=%d&max=%d&onlyimage=%d", -1, 5, 0];
            break;
        case 1: //好评
            url = [url stringByAppendingFormat:@"&min=%d&max=%d&onlyimage=%d", 2, 3, 0];
            break;
        case 2: //中评
            url = [url stringByAppendingFormat:@"&min=%d&max=%d&onlyimage=%d", 1, 2, 0];
            break;
        case 3: //差评
            url = [url stringByAppendingFormat:@"&min=%d&max=%d&onlyimage=%d", 0, 1, 0];
            break;
        case 4: //图片
            url = [url stringByAppendingFormat:@"&min=%d&max=%d&onlyimage=%d", -1, 5, 1];
            break;
    }
    [HttpUtils get:url success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取评论列表失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *commentArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [commentArray addObject:[self toGoodsComment:dictionary]];
        }
        success(commentArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

- (void) hot:(NSInteger)goodsId success:(void (^) (NSMutableArray *commentArray))success failure:(void (^) (NSError *error)) failure{
    if(goodsId <= 0){
        failure([self createError:ESParameterError message:@"系统参数错误,请您重试!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/comment/hot.do?goodsid=%d", goodsId];
    [HttpUtils get:url success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取热门评论失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *commentArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [commentArray addObject:[self toGoodsComment:dictionary]];
        }
        success(commentArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

- (void)count:(NSInteger)goodsId success:(void (^)(NSMutableArray *commentCountArray))success failure:(void (^)(NSError *error))failure {
    if(goodsId <= 0){
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/comment/count.do?goodsid=%d", goodsId];
    [HttpUtils get:url success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取评论数失败,请您重试!"]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *commentCountArray = [NSMutableArray arrayWithCapacity:5];
        [commentCountArray addObject:[dataDic objectForKey:@"all"]];
        [commentCountArray addObject:[dataDic objectForKey:@"good"]];
        [commentCountArray addObject:[dataDic objectForKey:@"general"]];
        [commentCountArray addObject:[dataDic objectForKey:@"poor"]];
        [commentCountArray addObject:[dataDic objectForKey:@"image"]];
        success(commentCountArray);
    } failure:^(NSError *error){
        failure(error);
    }];
}

- (void)waitList:(NSInteger)page orderId:(NSInteger)orderId success:(void (^)(NSMutableArray *goodsArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/comment/wait-list.do?page=%d&order_id=%d", page, orderId];
    [HttpUtils get:url success:^(NSString *responseString){
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil){
            failure([self createError:ESDataError message:@"获取待评价商品失败,请您重试!"]);
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

- (void)create:(GoodsComment *)comment success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", comment.goodsId] forKey:@"goods_id"];
    [parameters setObject:[NSString stringWithFormat:@"%d", comment.grade] forKey:@"grade"];
    [parameters setObject:comment.content forKey:@"content"];

    NSMutableArray *imageParameters = [NSMutableArray arrayWithCapacity:0];
    if (comment.imageFiles != nil && comment.imageFiles.count > 0) {
        for(UIImage *image in comment.imageFiles) {
            UIImage *resizedImage = [image scaledToSize:CGSizeMake(800, 600)];
            [imageParameters addObject:@{@"name":@"images", @"value":resizedImage}];

        }
    }

    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/comment/create.do"];
    [HttpUtils multipartPost:url withParameters:parameters andImages:imageParameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"发表评论失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }                failure:^(NSError *error) {
        failure(error);
    }];
}

- (GoodsComment *) toGoodsComment:(NSDictionary *) dic{
    GoodsComment *comment = [GoodsComment new];
    comment.id = [[dic objectForKey:@"comment_id"] intValue];
    comment.goodsId = [[dic objectForKey:@"goods_id"] intValue];
    comment.memberId = [[dic objectForKey:@"member_id"] intValue];
    comment.memberName = [dic objectForKey:@"uname"];
    comment.memberFace = [dic objectForKey:@"face"];
    comment.grade = [[dic objectForKey:@"grade"] intValue];
    comment.content = [dic objectForKey:@"content"];
    comment.date = [DateUtils timestampToDate:[[dic objectForKey:@"dateline"] intValue]];
    if([dic objectForKey:@"gallery"]){
        NSArray *galleryArray = [dic objectForKey:@"gallery"];
        if(galleryArray.count > 0) {
            comment.images = [NSMutableArray arrayWithCapacity:galleryArray.count];
            for (NSDictionary *galleryDic in galleryArray) {
                [comment.images addObject:[galleryDic objectForKey:@"original"]];
            }
        }
    }
    return comment;
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
    if([dic has:@"sn"]){
        goods.sn = [dic objectForKey:@"sn"];
    }
    if([dic has:@"weight"]){
        goods.weight = [[dic objectForKey:@"weight"] doubleValue];
    }
    return goods;
}

@end