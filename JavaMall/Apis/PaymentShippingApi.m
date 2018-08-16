//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PaymentShippingApi.h"
#import "Payment.h"
#import "Shipping.h"
#import "HttpUtils.h"
#import "DesUtils.h"
#import "NSDictionary+Common.h"


@implementation PaymentShippingApi {

}

- (void)list:(void (^)(NSMutableArray *paymentArray, NSMutableArray *shippingArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/payment/payment-shipping.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取支付及配送方式失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *payments = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dic in [dataDic objectForKey:@"payment"]){
            [payments addObject:[self toPayment:dic]];
        }

        NSMutableArray *shippings = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dic in [dataDic objectForKey:@"shipping"]){
            [shippings addObject:[self toShipping:dic]];
        }
        success(payments, shippings);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)payment:(NSInteger)orderId paymentId:(NSInteger)paymentId success:(void (^)(NSString *payhtml))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/payment/pay.do?orderid=%d&paymentid=%d", orderId, paymentId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"发起支付失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success([resultJSON objectForKey:DATA_KEY]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}


- (Payment *)toPayment:(NSDictionary *)dic {
    Payment *payment = [Payment new];
    payment.id = [[dic objectForKey:@"id"] intValue];
    payment.name = [dic objectForKey:@"name"];
    payment.config = [DesUtils decrypt:[dic objectForKey:@"config"]];

    NSString *type = [dic objectForKey:@"type"];
    if([type isEqualToString:@"alipayMobilePlugin"]){
        payment.type = Payment_Alipay;
    }else if([type isEqualToString:@"wechatMobilePlugin"]){
        payment.type = Payment_Wechat;
    }else if([type isEqualToString:@"unionpayMobilePlugin"]){
        payment.type = Payment_UnionPay;
    }else if([type isEqualToString:@"cod"]){
        payment.type = Payment_Cod;
    }
    return payment;
}

- (Shipping *)toShipping:(NSDictionary *)dic {
    Shipping *shipping = [Shipping new];
    shipping.id = [[dic objectForKey:@"type_id"] intValue];
    shipping.name = [dic objectForKey:@"name"];
    shipping.cod = [dic intForKey:@"has_cod"] == 1;
    shipping.price = [[dic objectForKey:@"price"] doubleValue];
    return shipping;
}

@end