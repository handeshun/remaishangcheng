//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OrderItemState_NORMAL = 0, 		 //0.正常
    OrderItemState_APPLY_RETURN = 1,    //1.申请退货
    OrderItemState_APPLY_CHANGE = 2,    //2.申请换货
    OrderItemState_REFUSE_RETURN = 3,   //3.退货已拒绝
    OrderItemState_REFUSE_CHANGE = 4,   //4.换货已拒绝
    OrderItemState_RETURN_PASSED =5,    //5.退货已通过审核
    OrderItemState_CHANGE_PASSED =6,    //6.换货已通过审核
    OrderItemState_RETURN_REC =7,       //7.退货已收到
    OrderItemState_CHANGE_REC =8,       //8.换货已收到,换货已发出
    OrderItemState_RETURN_END =9,       //9.退货完成
    OrderItemState_CHANGE_END =10       //10.换货完成
} OrderItemState;

@interface OrderItem : NSObject

/**
 * 商品分类id
 */
@property (assign, nonatomic) NSInteger categoryId;

/**
 * 商品id
 */
@property (assign, nonatomic) NSInteger goodsId;

/**
 * 货品ID
 */
@property (assign, nonatomic) NSInteger productId;

/**
 * 订单项id
 */
@property (assign, nonatomic) NSInteger itemId;

/**
 * 订单id
 */
@property (assign, nonatomic) NSInteger orderId;

/**
 * 商品名称
 */
@property (strong, nonatomic) NSString *name;

/**
 * 商品价格
 */
@property (assign, nonatomic) double price;

/**
 * 商品数量
 */
@property (assign, nonatomic) NSInteger number;

/**
 * 商品货号
 */
@property (strong, nonatomic) NSString *sn;

/**
 * 商品图片
 */
@property (strong, nonatomic) NSString *thumbnail;

/**
 * 规格信息
 */
@property (strong, nonatomic) NSMutableArray *addon;

/**
 * 订单货物状态
 */
@property (assign, nonatomic) NSInteger state;

/**
 * 订单货物状态
 */
@property (strong, nonatomic) NSString *stateString;

/**
 * 是否选中
 */
@property (assign, nonatomic) BOOL selected;

/**
 * 选中的个数
 */
@property (assign, nonatomic) NSInteger selectedNumber;

@end