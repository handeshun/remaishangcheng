//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "DateUtils.h"


@implementation DateUtils {

}

+ (NSString *)dateToString:(NSDate *)date {
    return [DateUtils dateToString:date withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format {
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:format];
    //NSDate转NSString
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringToDate:(NSString *)string withFormat:(NSString *)format {
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    //NSString转NSDate
    return [formatter dateFromString:string];
}

+ (NSDate *)timestampToDate:(NSInteger)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

+ (NSInteger)dateToTimestamp:(NSDate *)date {
    return [date timeIntervalSince1970];
}


@end