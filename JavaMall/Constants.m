//
//  Constants.m
//  JavaMall
//
//  Created by Dawei on 7/7/15.
//  Copyright (c) 2015 Enation. All rights reserved.
//

#import "Constants.h"
#import "Member.h"
#import "Setting.h"

static NSString *_action;

static Member *_member;

static Setting *_setting;

@implementation Constants


+ (void)setMember:(Member *)member {
    _member = member;
}

+ (Member *)currentMember {
    return _member;
}

+ (void)setSetting:(Setting *)setting {
    _setting = setting;
}

+ (Setting *)setting {
    return _setting;
}

+ (BOOL)isLogin {
    return _member != nil;
}


+ (void)setAction:(NSString *)toAction {
    _action = toAction;
}

+ (NSString *)action {
    return _action;
}

+ (BOOL)showIM {
//    if(EASEMOB_APP_KEY.length <= 0 || [Constants setting].services == nil || [[Constants setting].services count] <= 0){
//        return NO;
//    }
//    return YES;
    return NO;
}

@end
