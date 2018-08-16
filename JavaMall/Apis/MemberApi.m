//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MemberApi.h"
#import "Member.h"
#import "HttpUtils.h"
#import "DateUtils.h"
#import "UIImage+Common.h"
#import "PointHistory.h"
#import "NSDictionary+Common.h"
#import "Bonus.h"
#import "DesUtils.h"
#import "Goods.h"

@implementation MemberApi {

}

//- (void)seckill:(NSInteger)page keyword:(NSString *)keyword success:(void (^)(LBSeckill *seckill))success failure:(void (^)(NSError *error))failure {
//    if(page == 0)
//        page = 1;
//    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/list-seckill.do?page=%zd&keyword=%@", page, keyword] success:^(NSString *responseString) {
//        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
//            failure([self createError:ESDataError message:@"获取用户信息失败,请您重试!"]);
//            return;
//        }
//        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
//            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
//            return;
//        }
//        success([self toSeckill:[resultJSON objectForKey:DATA_KEY]]);
//    }      failure:^(NSError *error) {
//        failure(error);
//    }];
//}

- (void)seckill:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSMutableArray *storeList))success failure:(void (^)(NSError *error))failure {
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/list-seckill.do?page=%zd&keyword=%@", page, keyword] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"搜索店铺失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];
        
        NSMutableArray *storeList = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [storeList addObject:[self toSeckill:dictionary]];
        }
        success(storeList);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)pintuan:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSMutableArray *storeList))success failure:(void (^)(NSError *error))failure {
    [HttpUtils get:[kBaseUrl stringByAppendingFormat:@"/api/mobile/goods/get-pintuan-list.do?page=%zd&keyword=%@", page, keyword] success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"搜索店铺失败,请您重试!"]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];
        
        NSMutableArray *storeList = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [storeList addObject:[self toPintuan:dictionary]];
        }
        success(storeList);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

-(void) loadLoginImage:(UIImageView *)imageview{
    NSString *url = [kBaseUrl stringByAppendingString:@"validcode.do?vtype=memberlogin"];
    [HttpUtils loadImage:url :imageview];
}

-(void) loadRegisterImage:(UIImageView *)imageview{
    NSString *url = [kBaseUrl stringByAppendingString:@"validcode.do?vtype=memberreg"];
    [HttpUtils loadImage:url :imageview];
}

- (void)login:(NSString *)username password:(NSString *)password vcode:(NSString *)vcode success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure {
    if ([username length] <= 0 || [password length] <= 0) {
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }

    NSMutableDictionary *parameters = @{@"username": username, @"password": password, @"validcode": vcode};
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/login.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"登录失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:@"用户名或密码错误！"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESDataError message:@"登录失败,请您重试!"]);
            return;
        }
        success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

-(void) mLogin:(NSString *)connectType openid:(NSString *)openid success:(void (^)(Member *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:connectType forKey:@"connectType"];
    [parameters setObject:[DesUtils encrypt:openid] forKey:@"openid"];
    NSString *url = [kBaseUrl stringByAppendingString:@"/connect/mlogin.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSLog(responseString);
        NSLog(openid);
        NSLog(connectType);
         NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESDataError message:[resultJSON objectForKey:MESSAGE_KEY]]);
        }else{
            success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
        }
    } failure:^(NSError *error) {
        failure([self createError:ESDataError message:@"NetError"]);
    }];
}

-(void) mLoginBind:(NSString *)connectType openid:(NSString *)openid username:(NSString *)username password:(NSString *)password success:(void (^)(Member *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:connectType forKey:@"connectType"];
    [parameters setObject:[DesUtils encrypt:openid] forKey:@"openid"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    NSString *url = [kBaseUrl stringByAppendingString:@"/connect/mloginbind.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESDataError message:[resultJSON objectForKey:MESSAGE_KEY]]);
        }else{
            success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
        }
    } failure:^(NSError *error) {
        failure([self createError:ESDataError message:@"网络错误！"]);
    }];
}
-(void)mRegisterBind:(NSString *)connectType openid:(NSString *)openid username:(NSString *)username password:(NSString *)password nikename:(NSString *)nikename face:(NSString *)face success:(void (^)(Member *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:connectType forKey:@"connectType"];
    [parameters setObject:[DesUtils encrypt:openid] forKey:@"openid"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    [parameters setObject:face forKey:@"face"];
    [parameters setObject:nikename forKey:@"nikename"];
    NSString *url = [kBaseUrl stringByAppendingString:@"/connect/mregister.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESDataError message:[resultJSON objectForKey:MESSAGE_KEY]]);
        }else{
            success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
        }
    } failure:^(NSError *error) {
        failure([self createError:ESDataError message:@"网络错误！"]);
    }];
}
- (void)isLogin:(void (^)(BOOL logined))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/islogin.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取登录信息失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            success(NO);
            return;
        }
        success(YES);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)logout:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/logout.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"退出登录失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            success(NO);
            return;
        }
        success(YES);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)info:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/info.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取用户信息失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)sign:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/sign/sign.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取用户信息失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)saveInfo:(Member *)member success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:(member.name == nil ? @"" : member.name) forKey:@"name"];
    [parameters setObject:[NSString stringWithFormat:@"%d", member.sex] forKey:@"sex"];
    if (member.birthday != nil) {
        [parameters setObject:[NSString stringWithFormat:@"%d", [DateUtils dateToTimestamp:member.birthday]] forKey:@"birthday"];
    }
    [parameters setObject:(member.province == nil ? @"" : member.province) forKey:@"province"];
    [parameters setObject:[NSString stringWithFormat:@"%d", member.provinceId] forKey:@"province_id"];
    [parameters setObject:(member.city == nil ? @"" : member.city) forKey:@"city"];
    [parameters setObject:[NSString stringWithFormat:@"%d", member.cityId] forKey:@"city_id"];
    [parameters setObject:(member.region == nil ? @"" : member.region) forKey:@"region"];
    [parameters setObject:[NSString stringWithFormat:@"%d", member.regionId] forKey:@"region_id"];
    [parameters setObject:(member.address == nil ? @"" : member.address) forKey:@"address"];
    [parameters setObject:(member.mobile == nil ? @"" : member.mobile) forKey:@"mobile"];
    [parameters setObject:(member.zip == nil ? @"" : member.zip) forKey:@"zip"];
    [parameters setObject:(member.tel == nil ? @"" : member.tel) forKey:@"tel"];

    NSMutableArray *imageParameters = [NSMutableArray arrayWithCapacity:0];
    if (member.faceImage != nil) {
        member.faceImage = [member.faceImage scaledToSize:CGSizeMake(800, 600)];
        [imageParameters addObject:@{@"name": @"photo", @"value": member.faceImage}];
    }

    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/save.do"];
    [HttpUtils multipartPost:url withParameters:parameters andImages:imageParameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"修改资料失败,请您重试!"]);
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

- (void)changePassword:(NSString *)oldPass newPass:(NSString *)newPass rePass:(NSString *)rePass success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/member/change-password.do?oldpass=%@&password=%@&repass=%@", oldPass, newPass, rePass];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"修改密码失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)pointHistory:(NSInteger)page success:(void (^)(NSMutableArray *pointArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/member/point-history.do?page=%d", page];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取积分明细失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [pointArray addObject:[self toPointHistory:dictionary]];
        }
        success(pointArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)register:(NSString *)username password:(NSString *)password vcode:(NSString *)vcode  success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure {
    if ([username length] <= 0 || [password length] <= 0) {
        failure([self createError:ESParameterError message:@"系统参数错误!"]);
        return;
    }

    NSMutableDictionary *parameters = @{@"username": username, @"password": password,@"validcode": vcode};
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/register.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"注册失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)sendFindCode:(NSString *)mobile success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = @{@"mobile": mobile};
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/send-find-code.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"发送验证码失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)validMobileCode:(NSString *)mobile mobileCode:(NSString *)mobileCode success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = @{@"mobile": mobile, @"mobilecode": mobileCode};
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/valid-mobile.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"手机验证码校验失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)mobileChangePassword:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = @{@"mobile": mobile, @"mobilecode": mobileCode, @"password": password};
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/mobile-change-pass.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"设置新密码失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)sendRegisterCode:(NSString *)mobile success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = @{@"mobile": mobile};
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/send-register-code.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"发送验证码失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)mobileRegister:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(NSString *)password success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = @{@"mobile": mobile, @"mobilecode": mobileCode, @"password": password};
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/mobile-register.do"];
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"手机注册失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] == 0) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([self toMember:[resultJSON objectForKey:DATA_KEY]]);
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)bonus:(NSInteger)page type:(NSInteger)type success:(void (^)(NSMutableArray *bonusArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/member/bonus.do?type=%d&page=%d", type, page];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取优惠券失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *bonusArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [bonusArray addObject:[self toBonus:dictionary]];
        }
        success(bonusArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)bonusCount:(void (^)(NSInteger unusedCount, NSInteger usedCount, NSInteger expriedCount))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/member/bonus-count.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取优惠券数量失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        success([dataDic intForKey:@"unused_count"], [dataDic intForKey:@"used_count"], [dataDic intForKey:@"expired_count"]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}


- (Member *)toMember:(NSDictionary *)dic {
    Member *member = [Member new];
    member.userName = [dic objectForKey:@"username"];
    member.face = [dic objectForKey:@"face"];
    member.levelName = [dic objectForKey:@"level"];
    if ([dic has:@"nick_name"]) {
        member.nickName = [dic objectForKey:@"nick_name"];
    }
    if ([dic has:@"name"]) {
        member.name = [dic objectForKey:@"name"];
    }
    if ([dic has:@"level_id"]) {
        member.levelId = [[dic objectForKey:@"level_id"] intValue];
    }
    if ([dic has:@"sex"]) {
        member.sex = [[dic objectForKey:@"sex"] intValue];
    }
    if ([dic has:@"birthday"]) {
        member.birthday = [DateUtils timestampToDate:[[dic objectForKey:@"birthday"] intValue]];
    }
    if ([dic has:@"province_id"]) {
        member.provinceId = [[dic objectForKey:@"province_id"] intValue];
    }
    if ([dic has:@"province"]) {
        member.province = [dic objectForKey:@"province"];
    }
    if ([dic has:@"city_id"]) {
        member.cityId = [[dic objectForKey:@"city_id"] intValue];
    }
    if ([dic has:@"city"]) {
        member.city = [dic objectForKey:@"city"];
    }
    if ([dic has:@"region_id"]) {
        member.regionId = [[dic objectForKey:@"region_id"] intValue];
    }
    if ([dic has:@"region"]) {
        member.region = [dic objectForKey:@"region"];
    }
    if ([dic has:@"address"]) {
        member.address = [dic objectForKey:@"address"];
    }
    if ([dic has:@"zip"]) {
        member.zip = [dic objectForKey:@"zip"];
    }
    if ([dic has:@"mobile"]) {
        member.mobile = [dic objectForKey:@"mobile"];
    }
    if ([dic has:@"tel"]) {
        member.tel = [dic objectForKey:@"tel"];
    }
    if ([dic has:@"favoriteCount"]) {
        member.favoriteCount = [[dic objectForKey:@"favoriteCount"] intValue];
    }
    if ([dic has:@"point"]) {
        member.point = [[dic objectForKey:@"point"] intValue];
    }
    if ([dic has:@"mp"]) {
        member.mp = [[dic objectForKey:@"mp"] intValue];
    }
    if ([dic has:@"paymentOrderCount"]) {
        member.paymentOrderCount = [[dic objectForKey:@"paymentOrderCount"] intValue];
    }
    if ([dic has:@"shippingOrderCount"]) {
        member.shippingOrderCount = [[dic objectForKey:@"shippingOrderCount"] intValue];
    }
    if ([dic has:@"commentOrderCount"]) {
        member.commentOrderCount = [[dic objectForKey:@"commentOrderCount"] intValue];
    }
    if ([dic has:@"returnedOrderCount"]) {
        member.returnedOrderCount = [[dic objectForKey:@"returnedOrderCount"] intValue];
    }
    if ([dic has:@"imuser"]) {
        member.imUser = [dic objectForKey:@"imuser"];
    }
    if ([dic has:@"impass"]) {
        member.imPass = [dic objectForKey:@"impass"];
    }
    if([dic has:@"favoriteStoreCount"]){
        member.favoriteStoreCount = [dic intForKey:@"favoriteStoreCount"];
    }
    if ([dic has:@"issign"]) {
        member.issign = [[dic objectForKey:@"issign"] integerValue];
    }
    if ([dic has:@"ishavestore"]) {
        member.ishavestore = [[dic objectForKey:@"ishavestore"] integerValue];
    }
    return member;
}

- (PointHistory *)toPointHistory:(NSDictionary *)dic {
    PointHistory *pointHistory = [PointHistory new];
    pointHistory.id = [[dic objectForKey:@"id"] intValue];
    pointHistory.time = [DateUtils timestampToDate:[[dic objectForKey:@"time"] intValue]];
    pointHistory.reason = [dic objectForKey:@"reason"];
    pointHistory.point = [[dic objectForKey:@"point"] intValue];
    pointHistory.mp = [[dic objectForKey:@"mp"] intValue];
    return pointHistory;
}

- (Bonus *)toBonus:(NSDictionary *)dic {
    Bonus *bonus = [Bonus new];
    bonus.type = [dic intForKey:@"type_id"];
    bonus.money = [dic doubleForKey:@"type_money"];
    bonus.name = [dic stringForKey:@"type_name"];
    bonus.startDate = [DateUtils timestampToDate:[dic intForKey:@"use_start_date"]];
    bonus.endDate = [DateUtils timestampToDate:[dic intForKey:@"use_end_date"]];
    bonus.minAmount = [dic doubleForKey:@"min_goods_amount"];
    bonus.store_name = [dic stringForKey:@"store_name"];
    bonus.store_id = [dic intForKey:@"store_id"];
    bonus.used = ([dic intForKey:@"used"] == 1);
    return bonus;
}

- (Goods *)toSeckill:(NSDictionary *)dic {
    Goods *model = [Goods new];
    model.id = [dic intForKey:@"goods_id"];
    model.is_seckill = [dic intForKey:@"is_seckill"];
    model.name = [dic stringForKey:@"name"];
    model.start_time = [dic longlongForKey:@"start_time"];
    model.end_time = [dic longlongForKey:@"end_time"];
    model.thumbnail = [dic stringForKey:@"thumbnail"];
    model.seckill_price = [dic doubleForKey:@"seckill_price"];
    model.price = [dic doubleForKey:@"price"];
    model.activity_id = [dic intForKey:@"activity_id"];
    model.enable_store = [dic intForKey:@"enable_store"];
    return model;
}

- (Goods *)toPintuan:(NSDictionary *)dic {
    Goods *model = [Goods new];
    model.productId =[dic intForKey:@"product_id"];
    model.id = [dic intForKey:@"goods_id"];
    model.is_seckill = [dic intForKey:@"is_seckill"];
    model.name = [dic stringForKey:@"name"];
    model.start_time = [dic longlongForKey:@"start_time"];
    model.end_time = [dic longlongForKey:@"end_time"];
    model.thumbnail = [dic stringForKey:@"thumbnail"];
    model.seckill_price = [dic doubleForKey:@"seckill_price"];
    model.price = [dic doubleForKey:@"price"];
    model.activity_id = [dic intForKey:@"activity_id"];
    model.enable_store = [dic intForKey:@"enable_store"];
    model.modelList = [dic objectForKey:@"modelList"];
    model.deposit = [[dic stringForKey:@"deposit"] floatValue];
    return model;
}

+(void) loadImage:(NSString *)imageurl:(UIImageView *)imageView {
    //读取共享cookie
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppCookies"];
    if ([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    NSURL *url = [NSURL URLWithString:imageurl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];     //使用default配置
    [config setHTTPAdditionalHeaders:@{@"Accept":@"image/*"}];//设置网络数据格式
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        NSData *datas = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:datas forKey:@"AppCookies"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data];
            imageView.image = image;
        });
    }];
    [task resume];
}


@end
