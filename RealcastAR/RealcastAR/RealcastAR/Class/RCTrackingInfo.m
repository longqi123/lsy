//
//  RCARTrackingInfo.m
//  功能开发
//
//  Created by weily on 16/5/10.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCTrackingInfo.h"
#import "RealcastInteraction.h"

@implementation RCTrackingInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        ///	TODO
        self.trackingImage = RC_SAFE_OBJFORKEY(dictionary, @"trackingImage", NSString);
        self.trackingType = RC_SAFE_OBJFORKEY(dictionary, @"trackingType", NSString);
        self.mid = RC_SAFE_OBJFORKEY(dictionary, @"id", NSString);
    }
    return self;
}

@end
