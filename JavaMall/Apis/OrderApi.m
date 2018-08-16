//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "OrderApi.h"
#import "Bonus.h"
#import "HttpUtils.h"
#import "OrderPrice.h"
#import "Address.h"
#import "Payment.h"
#import "Shipping.h"
#import "Receipt.h"
#import "Order.h"
#import "OrderItem.h"
#import "ReturnedOrder.h"
#import "ReturnedOrderItem.h"
#import "DateUtils.h"
#import "NSDictionary+Common.h"
#import "Delivery.h"
#import "Express.h"
#import "Cart.h"
#import "Store.h"
#import "ShipType.h"
#import "ActivityGift.h"
#import "Utils.h"
#import "ReceiptModel.h"

@implementation OrderApi {

}

- (void)orderPrice:(NSInteger)regionid shippingId:(NSInteger)shippingid success:(void (^)(OrderPrice *orderPrice))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/orderprice.do?regionid=%d&shippingid=%d", regionid, shippingid];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取订单金额失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        success([self toOrderPrice:dataDic]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)useBonus:(NSInteger)bonusId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/use-bonus.do?bonusid=%d", bonusId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"使用优惠券失败,请您重试!"]);
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

- (void)create:(Order *)order receipt:(Receipt *)receipt success:(void (^)(Order *order))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSNumber numberWithInt:order.shippingId] forKey:@"shippingId"];
    [parameters setObject:[NSNumber numberWithInt:order.paymentId] forKey:@"paymentId"];
    [parameters setObject:[NSNumber numberWithInt:order.addressId] forKey:@"addressId"];
    [parameters setObject:order.shippingTime forKey:@"shippingTime"];
    [parameters setObject:order.remark forKey:@"remark"];
    [parameters setObject:[NSNumber numberWithInt:receipt.type] forKey:@"receiptType"];
    if (receipt.type > 0) {
         [parameters setObject:@"1" forKey:@"receipt"];
        [parameters setObject:receipt.title forKey:@"receiptTitle"];
        [parameters setObject:receipt.content forKey:@"receiptContent"];
        [parameters setObject:receipt.duby forKey:@"receiptDuty"];
        [parameters setObject:[Utils intToString:receipt.type] forKey:@"receiptType"];
    }else{
     [parameters setObject:@"0" forKey:@"receipt"];
    }
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/order/create.do"];
    NSLog(@"%@",parameters);
    [HttpUtils post:url withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"提交订单失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            NSLog(@"%@",resultJSON[@"message"]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        success([self toOrder:dataDic]);
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)list:(NSInteger)status page:(NSInteger)page success:(void (^)(NSMutableArray *orderArray))success failure:(void (^)(NSError *error))failure {
    NSString *statusStr = @"";
    if (status == OrderStatus_NOPAY) {
        statusStr = @"wait_pay";
    }
    if (status == OrderStatus_SHIP) {
        statusStr = @"wait_rog";
    }

    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/list.do?status=%@&page=%d", statusStr, page];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取订单列表失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *favoriteArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [favoriteArray addObject:[self toOrder:dictionary]];
        }
        success(favoriteArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)detail:(NSInteger)orderId success:(void (^)(Order *order, Receipt *receipt))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/detail.do?orderid=%d", orderId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取订单失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }

        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        success([self toOrder:[dataDic objectForKey:@"order"]], [self toReceipt:[dataDic objectForKey:@"receipt"]]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)cancel:(NSInteger)orderId reason:(NSString *)reason success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setObject:[NSString stringWithFormat:@"%d", orderId] forKey:@"orderid"];
    [parameters setObject:reason forKey:@"reason"];
    [HttpUtils post:[kBaseUrl stringByAppendingString:@"/api/mobile/order/cancel.do"] withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"取消订单失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)rogConfirm:(NSInteger)orderId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/confirm.do?orderid=%d", orderId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"确认收货失败,请您重试!"]);
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

- (void)returned:(ReturnedOrder *)returnedOrder success:(void (^)())success failure:(void (^)(NSError *error))failure {
    ReturnedOrderItem *item = [returnedOrder.returnedOrderItems objectAtIndex:0];

    NSString *urlParameters = @"";
    NSMutableArray *goods_num_array = [NSMutableArray arrayWithCapacity:returnedOrder.returnedOrderItems.count];
    NSMutableArray *item_id_array = [NSMutableArray arrayWithCapacity:returnedOrder.returnedOrderItems.count];
    for(ReturnedOrderItem *item in returnedOrder.returnedOrderItems){
        urlParameters = [urlParameters stringByAppendingFormat:@"&goods_num=%d&item_id=%d", item.returnNumber, item.itemId];
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:6];
    [parameters setObject:[NSString stringWithFormat:@"%d", returnedOrder.orderId] forKey:@"order_id"];
    [parameters setObject:returnedOrder.refundWay forKey:@"refund_way"];
    [parameters setObject:returnedOrder.remark forKey:@"remark"];
    [parameters setObject:returnedOrder.returnAccount forKey:@"return_account"];
    [parameters setObject:returnedOrder.reason forKey:@"reason"];
    [parameters setObject:[NSString stringWithFormat:@"%d", returnedOrder.ship_status] forKey:@"ship_status"];
    [parameters setObject:[NSString stringWithFormat:@"%.2f", returnedOrder.apply_alltotal] forKey:@"apply_alltotal"];
    [HttpUtils post:[kBaseUrl stringByAppendingFormat:@"/api/mobile/order/returned.do?client=ios%@", urlParameters] withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"申请退货失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)refund:(ReturnedOrder *)returnedOrder success:(void (^)())success failure:(void (^)(NSError *error))failure {
    ReturnedOrderItem *item = [returnedOrder.returnedOrderItems objectAtIndex:0];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:6];
    [parameters setObject:[NSString stringWithFormat:@"%d", returnedOrder.orderId] forKey:@"order_id"];
    [parameters setObject:returnedOrder.remark forKey:@"remark"];
    [parameters setObject:returnedOrder.reason forKey:@"reason"];
    [parameters setObject:[NSString stringWithFormat:@"%d", returnedOrder.ship_status] forKey:@"ship_status"];
    [parameters setObject:[NSString stringWithFormat:@"%.2f", returnedOrder.apply_alltotal] forKey:@"apply_alltotal"];
    [HttpUtils post:[kBaseUrl stringByAppendingString:@"/api/mobile/order/refund.do"] withParameters:parameters success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"申请退款失败,请您重试!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        success();
    }       failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)returnedOrderList:(NSInteger)page success:(void (^)(NSMutableArray *orderList))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/sell-back-list.do?page=%d", page];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取退换货列表失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];

        NSMutableArray *orderArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dictionary in dataArray) {
            [orderArray addObject:[self toReturnedOrder:dictionary]];
        }
        success(orderArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)returnedOrder:(NSInteger)id orderId:(NSInteger)orderId success:(void (^)(ReturnedOrder *returnedOrder))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/sell-back.do?id=%d&orderid=%d", id, orderId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取售后详情失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        success([self toReturnedOrder:dataDic]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)delivery:(NSInteger)orderId success:(void (^)(Delivery *delivery, NSMutableArray *expressArray))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/delivery.do?orderid=%d", orderId];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"获取物流信息失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];

        Delivery *delivery = [self toDelivery:[dataDic objectForKey:@"delivery"]];

        NSArray *expressDataArray = [dataDic objectForKey:@"express"];
        NSMutableArray *expressArray = [NSMutableArray arrayWithCapacity:expressDataArray.count];
        for (NSDictionary *dictionary in expressDataArray) {
            [expressArray addObject:[self toExpress:dictionary]];
        }
        success(delivery, expressArray);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}


-(void) getReceiptList:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure{
    NSString *url = [kBaseUrl stringByAppendingString:@"/api/shop/member-receipt/list.do"];
    [HttpUtils get:url success:^(NSString *responseString) {
         NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"尚未填写过发票!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        NSArray *receiptDataArray = [dataDic objectForKey:@"receiptList"];
        NSMutableArray *receiptArray = [NSMutableArray arrayWithCapacity:receiptDataArray.count];
        for (NSDictionary *dictionary in receiptDataArray) {
            [receiptArray addObject:[self toReceiptModel:dictionary]];
        }
        if (receiptArray.count==0) {
            failure([self createError:ESDataError message:@"尚未填写过发票!"]);
        }else{
            success(receiptArray);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void) addReceipt:(Receipt *)receiptmodel success:(void (^)(ReceiptModel *))success failure:(void (^)(NSError *))failure{
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/shop/member-receipt/add.do?title=%@&content=%@&duty=%@&type=%d",receiptmodel.title,receiptmodel.content,receiptmodel.duby,receiptmodel.type];
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"添加发票失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        if (dataDic!=nil&&![dataDic isKindOfClass:[NSNull class]]) {
            success([self toReceiptModel:dataDic]);
        }else{
            failure([self createError:ESDataError message:@"添加发票失败!"]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void) getReceiptContent:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure{
     NSString *url = [kBaseUrl stringByAppendingString:@"/api/mobile/cart/get-receipt-content.do"];
     [HttpUtils get:url success:^(NSString *responseString) {
         NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
         if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
             failure([self createError:ESDataError message:@"没有发票模板!"]);
             return;
         }
         if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
             failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
             return;
         }
         NSArray *dataArray = [resultJSON objectForKey:DATA_KEY];
         NSMutableArray *res = [NSMutableArray arrayWithCapacity:dataArray.count];
         for (NSDictionary *dic in dataArray) {
             [res addObject:[dic stringForKey:@"receipt_content"]];
         }
         success(res);
     } failure:^(NSError *error) {
         failure(error);
     }];
}

- (void)changeShipBonus:(NSInteger)regionid Cart:(Cart *)cart success:(void (^)(OrderPrice *orderPrice))success failure:(void (^)(NSError *error))failure {
    NSString *url = [kBaseUrl stringByAppendingFormat:@"/api/mobile/order/change-ship-bonus.do?regionid=%d", regionid];
    for (Store *store in cart.storeList) {
        url = [url stringByAppendingFormat:@"&store_ids=%d&type_ids=%d&bonus_ids=%d",
                                           store.id,
                                           (store.shipType == nil ? 0 : store.shipType.type_id),
                                           (store.bonus == nil ? 0 : store.bonus.id)];
    }
    [HttpUtils get:url success:^(NSString *responseString) {
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (resultJSON == nil || [resultJSON objectForKey:CODE_KEY] == nil) {
            failure([self createError:ESDataError message:@"修改配送方式或优惠券失败!"]);
            return;
        }
        if ([[resultJSON objectForKey:CODE_KEY] intValue] != 1 || [resultJSON objectForKey:DATA_KEY] == nil) {
            failure([self createError:ESLogicError message:[resultJSON objectForKey:MESSAGE_KEY]]);
            return;
        }
        NSDictionary *dataDic = [resultJSON objectForKey:DATA_KEY];
        success([self toOrderPrice:dataDic]);
    }      failure:^(NSError *error) {
        failure(error);
    }];
}


- (Bonus *)toBonus:(NSDictionary *)dic {
    Bonus *bonus = [Bonus new];
    bonus.id = [[dic objectForKey:@"bonus_id"] intValue];
    bonus.money = [[dic objectForKey:@"type_money"] doubleValue];
    bonus.minAmount = [[dic objectForKey:@"min_goods_amount"] doubleValue];
    bonus.startDate = [DateUtils timestampToDate:[[dic objectForKey:@"use_start_date"] doubleValue]];
    bonus.endDate = [DateUtils timestampToDate:[[dic objectForKey:@"use_end_date"] doubleValue]];
    bonus.type = [[dic objectForKey:@"send_type"] intValue];
    return bonus;
}

- (OrderPrice *)toOrderPrice:(NSDictionary *)dic {
    OrderPrice *orderPrice = [OrderPrice new];
    orderPrice.goodsPrice = [[dic objectForKey:@"goodsPrice"] doubleValue];
    orderPrice.shippingPrice = [[dic objectForKey:@"shippingPrice"] doubleValue];
    orderPrice.discountPrice = [[dic objectForKey:@"discountPrice"] doubleValue];
    orderPrice.paymentMoney = [[dic objectForKey:@"needPayMoney"] doubleValue];
    if ([dic has:@"actDiscount"]) {
        orderPrice.actDiscount = [dic doubleForKey:@"actDiscount"];
    }
    return orderPrice;
}

- (OrderItem *)toOrderItem:(NSDictionary *)dic {
    OrderItem *orderItem = [OrderItem new];
    orderItem.categoryId = [[dic objectForKey:@"cat_id"] intValue];
    orderItem.goodsId = [[dic objectForKey:@"goods_id"] intValue];
    orderItem.productId = [[dic objectForKey:@"product_id"] intValue];
    orderItem.itemId = [[dic objectForKey:@"item_id"] intValue];
    orderItem.orderId = [[dic objectForKey:@"order_id"] intValue];
    orderItem.name = [dic objectForKey:@"name"];
    orderItem.price = [[dic objectForKey:@"price"] doubleValue];
    orderItem.number = [[dic objectForKey:@"num"] intValue];
    orderItem.sn = [dic objectForKey:@"sn"];
    if ([dic has:@"image"]) {
        orderItem.thumbnail = [dic objectForKey:@"image"];
    }
    if ([dic has:@"state"]) {
        orderItem.state = [[dic objectForKey:@"state"] intValue];
    }
    if ([dic has:@"addon"]) {
        NSString *addon = [dic objectForKey:@"addon"];
        if (addon.length > 0) {
            NSArray *addonArray = [NSJSONSerialization JSONObjectWithData:[addon dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            orderItem.addon = [NSMutableArray arrayWithCapacity:addonArray.count];
            for (NSDictionary *dic in addonArray) {
                [orderItem.addon addObject:[NSString stringWithFormat:@"%@:%@", [dic objectForKey:@"name"], [dic objectForKey:@"value"]]];
            }
        }
    }
    return orderItem;
}

- (Order *)toOrder:(NSDictionary *)dic {
    Order *order = [Order new];
    order.id = [[dic objectForKey:@"order_id"] intValue];
    if([dic has:@"storeAddr"])
    {
    order.storeAddr = [dic objectForKey:@"storeAddr"];
    }
    order.sn = [dic objectForKey:@"sn"];
    order.orderAmount = [[dic objectForKey:@"order_amount"] doubleValue];
    order.goodsAmount = [[dic objectForKey:@"goods_amount"] doubleValue];
    order.shippingAmount = [[dic objectForKey:@"shipping_amount"] doubleValue];
    order.discount = [[dic objectForKey:@"discount"] doubleValue];
    order.needPayMoney = [[dic objectForKey:@"need_pay_money"] doubleValue];
    order.status = [[dic objectForKey:@"status"] intValue];
    order.paymentStatus = [[dic objectForKey:@"pay_status"] intValue];
    order.shippingStatus = [[dic objectForKey:@"ship_status"] intValue];
    order.paymentId = [[dic objectForKey:@"payment_id"] intValue];
    order.paymentType = [dic objectForKey:@"payment_type"];
    order.shippingId = [[dic objectForKey:@"shipping_id"] intValue];
    order.shippingName = [dic objectForKey:@"shipping_type"];
    order.shippingNumber = [dic objectForKey:@"ship_no"];
    order.addressId = [[dic objectForKey:@"address_id"] intValue];
    order.createTime = [DateUtils timestampToDate:[[dic objectForKey:@"create_time"] intValue]];
    order.cancelReason = [dic objectForKey:@"cancel_reason"];
    order.provinceId = [[dic objectForKey:@"ship_provinceid"] intValue];
    order.cityId = [[dic objectForKey:@"ship_cityid"] intValue];
    order.regionId = [[dic objectForKey:@"ship_regionid"] intValue];
    order.area = [dic objectForKey:@"shipping_area"];
    order.address = [dic objectForKey:@"ship_addr"];
    order.mobile = [dic objectForKey:@"ship_mobile"];
    order.name = [dic objectForKey:@"ship_name"];
    order.shippingTime = [dic objectForKey:@"ship_day"];
    order.remark = [dic objectForKey:@"remark"];
    order.is_cancel = [dic intForKey:@"is_cancel"];
    if ([dic has:@"payment_name"]) {
        order.paymentName = [dic objectForKey:@"payment_name"];
    }
    if([dic has:@"act_discount"]){
        order.actDiscount = [dic doubleForKey:@"act_discount"];
    }
    order.order_type = [dic longlongForKey:@"order_type"];

    NSArray *itemArray = [dic objectForKey:@"itemList"];
    if (itemArray == nil || [itemArray isKindOfClass:[NSNull class]] || itemArray.count == 0) {
        itemArray = [dic objectForKey:@"orderItemList"];
    }
    if(itemArray != nil && ![itemArray isKindOfClass:[NSNull class]] && itemArray.count > 0){
        order.orderItems = [NSMutableArray arrayWithCapacity:itemArray.count];
        for (NSDictionary *itemDic in itemArray) {
            [order.orderItems addObject:[self toOrderItem:itemDic]];
        }
    }

    
    
    //赠品及优惠券
    if ([dic has:@"fields"]) {
        NSDictionary *fieldDic = [dic objectForKey:@"fields"];
        if ([fieldDic has:@"gift"]) {
            order.gift = [self toGift:[fieldDic objectForKey:@"gift"]];
        }
        if ([fieldDic has:@"bonus"]) {
            order.bonus = [self toOrderBonus:[fieldDic objectForKey:@"bonus"]];
        }
    }

    return order;
}

- (Receipt *)toReceipt:(NSDictionary *)dic {
    if ([[dic objectForKey:@"title"] isKindOfClass:[NSNull class]])
        return nil;
    Receipt *receipt = [Receipt new];
    receipt.title = [dic objectForKey:@"title"];
    receipt.content = [dic objectForKey:@"content"];
    receipt.type = [[dic objectForKey:@"type"]intValue];
    receipt.duby = [dic objectForKey:@"duty"];
    return receipt;
}

- (ReturnedOrderItem *)toReturnedOrderItem:(NSDictionary *)dic {
    ReturnedOrderItem *item = [ReturnedOrderItem new];
    item.id = [[dic objectForKey:@"id"] intValue];
    item.itemId = [[dic objectForKey:@"item_id"] intValue];
    item.goodsId = [[dic objectForKey:@"goods_id"] intValue];
    item.productId = [[dic objectForKey:@"product_id"] intValue];
    item.returnNumber = [[dic objectForKey:@"return_num"] intValue];
    item.buyNumber = [[dic objectForKey:@"ship_num"] intValue];
    item.price = [[dic objectForKey:@"price"] doubleValue];
    item.thumbnail = [dic objectForKey:@"goods_image"];
    item.goodsName = [dic objectForKey:@"goods_name"];
    return item;
}

- (ReturnedOrder *)toReturnedOrder:(NSDictionary *)dic {
    ReturnedOrder *order = [ReturnedOrder new];
    order.id = [[dic objectForKey:@"id"] intValue];
    order.orderId = [[dic objectForKey:@"orderid"] intValue];
    order.status = [[dic objectForKey:@"tradestatus"] intValue];
    order.createTime = [DateUtils timestampToDate:[[dic objectForKey:@"regtime"] intValue]];
    order.sn = [dic objectForKey:@"ordersn"];
    order.refundWay = [dic objectForKey:@"refund_way"];
    order.returnAccount = [dic objectForKey:@"return_account"];
    order.remark = [dic objectForKey:@"remark"];
    order.reason = [dic objectForKey:@"reason"];
    order.sellerRemark = [dic objectForKey:@"seller_remark"];
    NSArray *itemArray = [dic objectForKey:@"goodsList"];
    order.returnedOrderItems = [NSMutableArray arrayWithCapacity:itemArray.count];
    for (NSDictionary *itemDic in itemArray) {
        [order.returnedOrderItems addObject:[self toReturnedOrderItem:itemDic]];
    }
    if([dic has:@"type"]){
        order.type = [dic intForKey:@"type"];
    }
    return order;
}

- (Delivery *)toDelivery:(NSDictionary *)dic {
    Delivery *delivery = [Delivery new];
    delivery.deliveryId = [[dic objectForKey:@"delivery_id"] intValue];
    delivery.logicName = [dic objectForKey:@"logi_name"];
    delivery.logicNumber = [dic objectForKey:@"logi_no"];
    return delivery;
}

- (Express *)toExpress:(NSDictionary *)dic {
    Express *express = [Express new];
    express.time = [dic objectForKey:@"time"];
    express.content = [dic objectForKey:@"context"];
    return express;
}

- (ActivityGift *)toGift:(NSDictionary *)dic {
    ActivityGift *gift = [ActivityGift new];
    gift.id = [dic intForKey:@"gift_id"];
    gift.img = [dic stringForKey:@"gift_img"];
    gift.name = [dic stringForKey:@"gift_name"];
    gift.price = [dic doubleForKey:@"gift_price"];
    return gift;
}

- (Bonus *)toOrderBonus:(NSDictionary *)dic {
    Bonus *bonus = [Bonus new];
    bonus.id = [dic intForKey:@"bonus_id"];
    bonus.money = [dic doubleForKey:@"bonus_money"];
    bonus.name = [dic stringForKey:@"bonus_name"];
    bonus.minAmount = [dic doubleForKey:@"min_goods_amount"];
    bonus.type = [dic intForKey:@"send_type"];
    return bonus;
}

- (ReceiptModel *)toReceiptModel:(NSDictionary *)dic {
    ReceiptModel *rece = [ReceiptModel new];
    rece.type =[dic intForKey:@"type"];
    rece.title = [dic stringForKey:@"title"];
    rece.content = [dic stringForKey:@"content"];
    rece.duty = [dic stringForKey:@"duty"];
    rece.id = [dic intForKey:@"id"];
    return rece;
}


@end
