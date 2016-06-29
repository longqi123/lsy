//
//  RCActionParameters.m
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCActionParameters.h"

@implementation RCActionParameters
{
    NSDictionary *_store;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
    if (self = [super init]) {
        _store = otherDictionary;
    }
    return self;
}

- (id)objectForKey:(NSString *)aKey {
    return [_store objectForKey:aKey];
}

- (id)objectForKeyedSubscript:(NSString *)key
{
    return [_store objectForKeyedSubscript:key];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (![self respondsToSelector:aSelector]) {
        return _store;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end


@implementation RIVisibilityActionParameters

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
    if (self = [super initWithDictionary:otherDictionary]) {
        self.type = [otherDictionary objectForKey:@"type"];
    }
    return self;
}

@end
