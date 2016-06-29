//
//  RCAREvent.h
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCAction.h"

typedef NS_ENUM(NSUInteger, RCEventType) {
    RCEventTypeClick,
    RCEventTypeTracking,
    RCEventTypeLostTracking,
    RCEventTypeRotated,
    RCEventTypeTranslated,
    RCEventTypeScaled,
    RCEventTypeAnimationStart,
    RCEventTypeAnimationPause,
    RCEventTypeAnimationEnded,
    RCEventTypeMovieStarted,
    RCEventTypeMoviePause,
    RCEventTypeMovieEnded,
    RCEventTypeDynamicLoaded
};

RCEventType eventTypeWithString(NSString *typeString);

@interface RCEvent : NSObject

@property (nonatomic, strong) NSDictionary *arguments;

@property (nonatomic, copy) NSString *eventID;

@property (nonatomic, assign) BOOL status;

@property (nonatomic, strong) NSDictionary *triggerConditions;

@property (nonatomic, assign) RCEventType eventType;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<RCAction *> *actions;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@end


