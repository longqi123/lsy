//
//  CSSDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "CSSDemoConfig.h"

@interface CSSDemoConfig ()

@end

@implementation CSSDemoConfig
+ (instancetype)sharedConfig
{
    static CSSDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSSDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appKey = @"1ee5a51b7d008254cd73b1d4369a9494";
        _apiURL = @"https://app.netease.im/api";
        _cerName= @"ENTERPRISE";
    }
    return self;
}

- (NSString *)appKey
{
    return _appKey;
}

- (NSString *)apiURL
{
    return _apiURL;
}

- (NSString *)cerName
{
    return _cerName;
}



@end
