//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Member.h"


@implementation Member

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.id forKey:@"id"];
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.nickName forKey:@"nickName"];
    [coder encodeObject:self.face forKey:@"face"];
    [coder encodeObject:self.levelName forKey:@"levelName"];
    [coder encodeObject:self.imUser forKey:@"imUser"];
    [coder encodeObject:self.imPass forKey:@"imPass"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self == [super init]) {
        self.id = [decoder decodeIntegerForKey:@"id"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.face = [decoder decodeObjectForKey:@"face"];
        self.levelName = [decoder decodeObjectForKey:@"levelName"];
        self.imUser = [decoder decodeObjectForKey:@"imUser"];
        self.imPass = [decoder decodeObjectForKey:@"imPass"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Member *copy = [[[self class] allocWithZone:zone] init];
    copy.id = self.id;
    copy.userName = self.userName;
    copy.nickName = self.nickName;
    copy.face = self.face;
    copy.levelName = self.levelName;
    copy.imUser = self.imUser;
    copy.imPass = self.imPass;
    return copy;
}


@end