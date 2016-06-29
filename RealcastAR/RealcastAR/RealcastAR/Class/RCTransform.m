//
//  RCARTransform.m
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCTransform.h"

@implementation RCTransform

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.x = [[dictionary objectForKey:@"x"] floatValue];
        self.y = [[dictionary objectForKey:@"y"] floatValue];
        self.z = [[dictionary objectForKey:@"z"] floatValue];
    }
    return self;
}

+ (instancetype)transformWithX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    RCTransform *transform = [[RCTransform alloc] init];
    transform.x = x;
    transform.y = y;
    transform.z = z;
    return transform;
}

- (NSArray *)transformArray {
    return @[@(self.x), @(self.y), @(self.z)];
}

+ (instancetype)transformWithArray:(NSArray *)array {
    if (array.count > 2) {
        RCTransform *transform = [[RCTransform alloc] init];
        transform.x = [array[0] integerValue];
        transform.y = [array[1] integerValue];
        transform.z = [array[2] integerValue];
        return transform;
    }
    return nil;
}

@end
