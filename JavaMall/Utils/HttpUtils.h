//
// Created by Dawei on 10/11/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpUtils : NSObject


/**
 *  Http Get方法
 *
 *  @param url 要请求的网址
 *  @param success 请求成功后的回调方法
 *  @param failure 请求失败后的回调方法
 *
 *  @return HttpResult对象
 */
+ (void) get:(NSString *)url success:(void (^)(NSString *responseString))success
     failure:(void (^)(NSError *error))failure;

/**
 *  Http Post方法
 *
 *  @param url  要请求的网址
 *  @param parameters 要Post的数据
 *  @param success 请求成功后的回调方法
 *  @param failure 请求失败后的回调方法
 *
 *  @return 网页源代码
 */
+ (void) post:(NSString *)url withParameters:(NSMutableDictionary *)parameters
      success:(void (^)(NSString *responseString))success
      failure:(void (^)(NSError *error))failure;

/**
 *  Http Post方法
 *
 *  @param url      要请求的网址
 *  @param parameters     要Post的数据
 *  @param images   要上传的图片
 *  @param success 请求成功后的回调方法
 *  @param failure 请求失败后的回调方法
 *
 *  @return 网页源代码
 */
+ (void)multipartPost:(NSString *)url withParameters:(NSMutableDictionary *)parameters
            andImages:(NSMutableArray<NSDictionary *> *)images
              success:(void (^)(NSString *responseString))success
              failure:(void (^)(NSError *error))failure;


/**
 *  通过AFN加载图片
 *
 *  @param imageurl  图片url
 *  @param imageView imageview对象
 */
+(void) loadImage:(NSString *)imageurl:(UIImageView *)imageView ;
@end