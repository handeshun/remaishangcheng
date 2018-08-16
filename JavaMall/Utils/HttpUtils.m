//
// Created by Dawei on 10/11/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import "HttpUtils.h"
#import "AFNetworking.h"


@implementation HttpUtils {

}

/**
 *  Http Get方法
 *
 *  @param url      要请求的网址
 *  @param success 请求成功后的回调方法
 *  @param failure 请求失败后的回调方法
 *
 *  @return 网页源代码
 */
+ (void) get:(NSString *)url success:(void (^)(NSString *responseString))success
                                                                          failure:(void (^)(NSError *error))failure {
    //构造request参数
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"Mozilla/5.0 (JavaShop App v2.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.118 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil error:nil];

    [self invoke:request withUrl:url success:success failure:failure];
}

/**
 *  Http Post方法
 *
 *  @param url      要请求的网址
 *  @param parameters     要Post的数据
 *  @param success 请求成功后的回调方法
 *  @param failure 请求失败后的回调方法
 *
 *  @return 网页源代码
 */
+ (void) post:(NSString *)url withParameters:(NSMutableDictionary *)parameters
      success:(void (^)(NSString *responseString))success
      failure:(void (^)(NSError *error))failure {
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.118 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Contsetent-Type"];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];

    [self invoke:request withUrl:url success:success failure:failure];
}

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
              failure:(void (^)(NSError *error))failure{
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.118 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Contsetent-Type"];
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        if(images != nil && images.count > 0) {
            NSInteger i = 0;
            for (NSDictionary *parameter in images) {
                UIImage *image = [parameter objectForKey:@"value"];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:[parameter objectForKey:@"name"] fileName:[NSString stringWithFormat:@"photo_%d.png", i] mimeType:@"image/jpg"];
                i++;
            }
        }
    } error:nil];
    [self invoke:request withUrl:url success:success failure:failure];
}

/**
 *  发送Http请求
 *
 *  @param request  NSMutableRequest对象
 *  @param url      要请求的网址
 *  @param success 请求成功后的回调方法
 *  @param failure 请求失败后的回调方法
 *
 *  @return 网页源代码
 */
+ (void) invoke:(NSMutableURLRequest *)request withUrl:(NSString *)url success:(void (^)(NSString *responseString))success
             failure:(void (^)(NSError *error))failure {
    //读取共享cookie
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppCookies"];
    if ([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
//validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;


    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    manager.securityPolicy  = securityPolicy;

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            DebugLog(error.debugDescription);
            failure([[NSError alloc] initWithDomain:kBaseUrl code:1 userInfo:[NSDictionary dictionaryWithObject:@"连接服务器失败,请您重试!" forKey:NSLocalizedDescriptionKey]]);
            return;
        }
        //保存Cookie到共享
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"AppCookies"];

        NSString *resString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (resString.length > 0) {
            success(resString);
            return;
        }
        failure([[NSError alloc] initWithDomain:kBaseUrl code:1 userInfo:[NSDictionary dictionaryWithObject:@"获取服务器数据失败,请您重试!" forKey:NSLocalizedDescriptionKey]]);
    }] resume];

//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
//
//        //保存Cookie到共享
//        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"AppCookies"];
//
//        NSString *resString = [NSString string];
//        if (encoding != 0) {
//            resString = [[NSString alloc] initWithData:[operation responseObject] encoding:encoding];
//        } else {
//            resString = [operation responseString];
//        }
//        if(resString.length > 0){
//            success(resString);
//            return;
//        }
//        failure([[NSError alloc] initWithDomain:kBaseUrl code:1 userInfo:[NSDictionary dictionaryWithObject:@"获取服务器数据失败,请您重试!" forKey:NSLocalizedDescriptionKey]]);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        DebugLog(error.debugDescription);
//        failure([[NSError alloc] initWithDomain:kBaseUrl code:1 userInfo:[NSDictionary dictionaryWithObject:@"连接服务器失败,请您重试!" forKey:NSLocalizedDescriptionKey]]);
//    }];
//
//    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    [operation setResponseSerializer:responseSerializer];
//    [operation start];
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