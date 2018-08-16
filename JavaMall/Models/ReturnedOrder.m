//
// Created by Dawei on 7/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReturnedOrder.h"


@implementation ReturnedOrder {

}

- (NSString *)statusString {
    if(self.type == 1){
        switch (self.status){
            case 0:
                return @"等待处理";
            case 1:
                return @"审核通过";
            case 2:
                return @"审核拒绝";
            case 3:
                return @"等待平台退款";
            case 6:
                return @"已退款";
        }
    }else{
        switch (self.status){
            case 0:
                return @"等待处理";
            case 1:
                return @"审核通过";
            case 2:
                return @"审核拒绝";
            case 3:
            case 4:
                return @"等待平台退款";
            case 5:
                return @"自营-部分入库";
            case 6:
                return @"已退款";
        }
    }

    return @"";
}

@end