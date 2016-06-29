//
//  RCAREvent.m
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCEvent.h"

@implementation RCEvent

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.eventID = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
        self.status = [[dictionary objectForKey:@"status"] boolValue];
        self.triggerConditions = [dictionary objectForKey:@"triggerConditions"];
        NSString *eventType = [dictionary objectForKey:@"eventType"];
        self.eventType = eventTypeWithString(eventType);
        
        /// actions
        NSArray *actions = [dictionary objectForKey:@"actions"];
        if (actions) {
            NSMutableArray *actionModels = [[NSMutableArray alloc] init];
            for (NSDictionary *action in actions) {
                RCAction *amodel = [[RCAction alloc] initWithDictionary:action];
                [actionModels addObject:amodel];
            }
            self.actions = (id)actionModels;
        }
    }
    return self;
}

@end



RCEventType eventTypeWithString(NSString *typeString)
{
    NSDictionary *typeMapping = @{@"click": @(RCEventTypeClick),
                                  @"tracking": @(RCEventTypeTracking),
                                  @"lostTracking": @(RCEventTypeLostTracking),
                                  @"rotated": @(RCEventTypeRotated),
                                  @"translated": @(RCEventTypeTranslated),
                                  @"scaled": @(RCEventTypeScaled),
                                  @"animationStart": @(RCEventTypeAnimationStart),
                                  @"animationPause": @(RCEventTypeAnimationPause),
                                  @"animationEnded": @(RCEventTypeAnimationEnded),
                                  @"movieStart": @(RCEventTypeMovieStarted),
                                  @"moviePause": @(RCEventTypeMoviePause),
                                  @"movieEnded": @(RCEventTypeMovieEnded),
                                  @"dynamicLoaded": @(RCEventTypeDynamicLoaded)};
    return [typeMapping[typeString] unsignedIntegerValue];
}


