//
//  RCARAction.h
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCActionParameters.h"

typedef NS_ENUM(NSUInteger, RCActionType) {
    RCActionTypeAnimate,
    RCActionTypeTel,
    RCActionTypeHttp,
    RCActionTypeHttps,
    RCActionTypeMailTo,
    RCActionTypeHtml,
    RCActionTypeARVideo,
    RCActionTypeOnlineVideo,
    RCActionTypeSound,
    RCActionTypeChannels,
    RCActionTypeRoute,
    RCActionTypeSms,
    RCActionTypeShow,
    RCActionTypeHide,
    RCActionTypeEffect,
    RCActionTypeGesture,
    RCActionTypeVisibility
};
/// actionType的便利方法
RCActionType actionTypeWithString(NSString *typeString);

@interface RCAction : NSObject

@property (nonatomic, copy) NSString *actionID;

@property (nonatomic, strong) NSArray *value;

@property (nonatomic, assign) RCActionType actionType;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) RCActionParameters *parameters;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@end
