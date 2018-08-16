//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "AddressApi.h"
#import "Address.h"
#import "HttpUtils.h"
#import "Region.h"


@implementation AddressApi {

}

- (void)getDefault:(void (^)(Address *address))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/address/default.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取默认收货地址失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toAddress:[resultJSON objectForKey:DATA_KEY]]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getRegions:(NSInteger)parentid success:(void (^)(NSMutableArray *regions))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/address/region-list.do?parentid=%d", parentid];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取地区数据失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }

        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];


        NSMutableArray *regionArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [regionArray addObject:[self toRegion:dictionary]];
        }
        success(regionArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}


/**
 * 获取附近店铺地址6
 */
- (void)getAddress:(CGFloat)lat lon:(CGFloat)lon success:(void (^)(NSMutableArray *address))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/api/mobile/app/list.do?lat=%f&lon=%f",lat,lon]];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSLog(@"%@",responseString);
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取默认收货地址失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];
        
        NSMutableArray *regionArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [regionArray addObject:[self toAddress:dictionary]];
        }
        success(regionArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)add:(Address *)address success:(void (^)(Address *address))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:address.name forKey:@"name"];
    [param setObject:address.mobile forKey:@"mobile"];
    [param setObject:[NSString stringWithFormat:@"%d", address.provinceId] forKey:@"province_id"];
    [param setObject:[NSString stringWithFormat:@"%d", address.cityId] forKey:@"city_id"];
    [param setObject:[NSString stringWithFormat:@"%d", address.regionId] forKey:@"region_id"];
    [param setObject:address.address forKey:@"addr"];
    if(address.isDefault){
        [param setObject:@"1" forKey:@"def"];
    }else{
        [param setObject:@"0" forKey:@"def"];
    }

    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/address/add.do"];
    [HttpUtils post:url withParameters:param success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil || [[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESDataError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toAddress:[resultJSON objectForKey:DATA_KEY]]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)edit:(Address *)address success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:address.name forKey:@"name"];
    [param setObject:address.mobile forKey:@"mobile"];
    [param setObject:[NSString stringWithFormat:@"%d", address.provinceId] forKey:@"province_id"];
    [param setObject:[NSString stringWithFormat:@"%d", address.cityId] forKey:@"city_id"];
    [param setObject:[NSString stringWithFormat:@"%d", address.regionId] forKey:@"region_id"];
    [param setObject:address.address forKey:@"addr"];
    if(address.isDefault){
        [param setObject:@"1" forKey:@"def"];
    }else{
        [param setObject:@"0" forKey:@"def"];
    }
    [param setObject:[NSString stringWithFormat:@"%d", address.id] forKey:@"addr_id"];

    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/address/edit.do"];
    [HttpUtils post:url withParameters:param success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil || [[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESDataError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toAddress:[resultJSON objectForKey:DATA_KEY]]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)list:(void (^)(NSMutableArray *addressArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/address/list.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取收货地址失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *addressArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [addressArray addObject:[self toAddress:dictionary]];
        }
        success(addressArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)delete:(NSInteger)addressId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/address/delete.do?addr_id=%d", addressId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"删除收货地址失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)setDefault:(NSInteger)addressId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/address/set-default.do?addr_id=%d", addressId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"设置默认地址失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

-(Address *) toAddress:(NSDictionary *)dic{
    Address *address = [Address new];
    address.id = [[dic objectForKey:@"addr_id"] intValue];
    address.name = [dic objectForKey:@"name"];
    address.province = [dic objectForKey:@"province"];
    address.provinceId = [[dic objectForKey:@"province_id"] intValue];
    address.city = [dic objectForKey:@"city"];
    address.cityId = [[dic objectForKey:@"city_id"] intValue];
    address.region = [dic objectForKey:@"region"];
    address.regionId = [[dic objectForKey:@"region_id"] intValue];
    address.address = [dic objectForKey:@"addr"];
    address.zip = [dic objectForKey:@"zip"];
    if([dic objectForKey:@"tel"] && [[dic objectForKey:@"tel"] isKindOfClass:[NSString class]]) {
        address.tel = [dic objectForKey:@"tel"];
    }
    if([dic objectForKey:@"mobile"] && [[dic objectForKey:@"mobile"] isKindOfClass:[NSString class]]){
        address.mobile = [dic objectForKey:@"mobile"];
    }
    address.isDefault = [[dic objectForKey:@"def_addr"] intValue] == 1;
    address.remark = [dic objectForKey:@"remark"];
    
    //附近的店铺
    address.attr = [dic objectForKey:@"attr"];
    address.store_name = [dic objectForKey:@"store_name"];
    address.store_logo = [dic objectForKey:@"store_logo"];
    address.distance = [dic objectForKey:@"distance"];
    address.store_id = [[dic objectForKey:@"store_id"] intValue];
    address.latitude = [[dic objectForKey:@"latitude"] floatValue];
    address.longitude = [[dic objectForKey:@"longitude"] floatValue];
    
    return address;
}

-(Region *)toRegion:(NSDictionary *)dic{
    Region *region = [Region new];
    region.id = [[dic objectForKey:@"region_id"] intValue];
    region.name = [dic objectForKey:@"local_name"];
    region.zipcode = [dic objectForKey:@"zip_code"];
    region.cod = ([dic objectForKey:@"cod"] == @"1");
    return region;
}

@end
