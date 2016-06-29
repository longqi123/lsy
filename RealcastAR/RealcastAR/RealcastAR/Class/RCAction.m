//
//  RCARAction.m
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCAction.h"

@implementation RCAction

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.actionID = [dictionary objectForKey:@"id"];
        NSString *actionType = [dictionary objectForKey:@"actionType"];
        self.actionType = actionTypeWithString(actionType);
        self.name = [dictionary objectForKey:@"name"];
        self.value = [dictionary objectForKey:@"value"];
        
        NSDictionary *parameters = [dictionary objectForKey:@"parameters"];
        if (parameters)
        {
            switch (self.actionType) {
                case RCActionTypeVisibility: {
                    self.parameters = [[RIVisibilityActionParameters alloc] initWithDictionary:parameters];
                    break;
                }
                default: {
                    self.parameters = [[RCActionParameters alloc] initWithDictionary:parameters];
                    break;
                }
            }
        }
    }
    return self;
}

@end



RCActionType actionTypeWithString(NSString *typeString)
{
    NSDictionary *typeMapping = @{@"animate": @(RCActionTypeAnimate),
                                  @"tel": @(RCActionTypeTel),
                                  @"http": @(RCActionTypeHttp),
                                  @"https": @(RCActionTypeHttps),
                                  @"gesture": @(RCActionTypeGesture),
                                  @"visibility": @(RCActionTypeVisibility),
                                  @"mailTo": @(RCActionTypeMailTo),
                                  @"html": @(RCActionTypeHtml),
                                  @"arVideo": @(RCActionTypeARVideo),
                                  @"onlineVideo": @(RCActionTypeOnlineVideo),
                                  @"sound": @(RCActionTypeSound),
                                  @"channels": @(RCActionTypeChannels),
                                  @"route": @(RCActionTypeRoute),
                                  @"sms": @(RCActionTypeSms),
                                  @"show": @(RCActionTypeShow),
                                  @"hide": @(RCActionTypeHide),
                                  @"effect": @(RCActionTypeEffect),
                                  };
    
    return [typeMapping[typeString] unsignedIntegerValue];
}
