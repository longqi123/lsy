//
//  RCARGestureConfig.m
//  tianyanAR
//
//  Created by weily on 16/5/11.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import "RCGestureConfig.h"

@implementation RCGestureConfig


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.transition = [[dictionary objectForKey:@"transition"] boolValue];
        self.scale = [[dictionary objectForKey:@"scale"] boolValue];
        self.rotation = [[dictionary objectForKey:@"rotation"] boolValue];
    }
    return self;
}

@end
