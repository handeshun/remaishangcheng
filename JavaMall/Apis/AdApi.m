//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "AdApi.h"
#import "Ad.h"
#import "HttpUtils.h"


@implementation AdApi {

}

/**
 * 根据广告位获取一个首屏广告
 */
- (void)detail:(NSInteger)advid success:(void (^)(Ad *ad))success failure:(void (^)(NSError *error))failure {
//    if (advid <= 0) {
//        failure([self createError:ESParameterError message:@"广告位ID不能为空!"]);
//        return;
//    }
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/adv/homepage.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:@"result"] == nil) {
            failure([self createError:ESDataError message:@"获取广告失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:@"result"] intValue] != 1 || [resultJSON objectForKey:@"data"] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:@"message"]]);
            return;
        }
        success([self toAd:[resultJSON objectForKey:@"data"]]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (Ad *)toAd:(NSDictionary *)dic {
    Ad *ad = [Ad new];
    ad.id = [[dic objectForKey:@"aid"] intValue];
    //ad.name = [dic objectForKey:@"aname"];
    //ad.url = [dic objectForKey:@"url"];
    ad.image = [dic objectForKey:@"atturl"];
    return ad;
}

@end
