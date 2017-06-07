//
//  CSUnsupportContentConfig.m
//  CSKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "CSUnsupportContentConfig.h"

@implementation CSUnsupportContentConfig
+ (instancetype)sharedConfig
{
    static CSUnsupportContentConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSUnsupportContentConfig alloc] init];
    });
    return instance;
}

- (CGSize)contentSize:(CGFloat)cellWidth
{
    return CGSizeMake(100.f, 40.f);
}

- (NSString *)cellContent
{
    return @"CSSessionUnknowContentView";
}

- (UIEdgeInsets)contentViewInsets
{
    return self.message.isOutgoingMsg ?
    UIEdgeInsetsMake(11.f,11.f,9.f,15.f) : UIEdgeInsetsMake(11.f, 15.f, 9.f, 9.f);
}

@end
