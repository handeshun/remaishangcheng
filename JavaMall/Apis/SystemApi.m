//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SystemApi.h"
#import "HttpUtils.h"
#import "BaseApi.h"
#import "Setting.h"
#import "NSDictionary+Common.h"


@implementation SystemApi {

}

- (void)hotKeyword:(void (^)(NSMutableArray *keywordArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/system/hot-keyword.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取热门关键词失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([resultJSON objectForKey:DATA_KEY]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)setting:(void (^)(Setting *setting))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/system/setting.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取系统配置失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toSetting:[resultJSON objectForKey:DATA_KEY]]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (Setting *)toSetting:(NSDictionary *)dic {
    Setting *setting = [Setting new];

    //取当前缓存的客服id
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    setting.currentService = [defaults objectForKey:@"current_services"];

    setting.services = [NSMutableArray arrayWithCapacity:0];
    if(dic != nil && [dic has:@"services"]){
        NSString *services = [dic objectForKey:@"services"];
        if(services != nil && [services isKindOfClass:[NSString class]] && services.length > 0){
            [setting.services addObjectsFromArray:[services componentsSeparatedByString:@","]];

            //设置当前要使用哪个客服人员
            if(setting.currentService == nil || ![setting.currentService isKindOfClass:[NSString class]] || setting.currentService.length == 0 || ![setting.services containsObject:setting.currentService]){
                int index = arc4random() % [setting.services count];
                setting.currentService = [setting.services objectAtIndex:index];
            }
        }
    }

    [defaults setObject:setting.currentService forKey:@"current_services"];
    [defaults synchronize];

    return setting;
}


@end