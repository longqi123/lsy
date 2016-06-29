//
//  RCARGestureConfig.h
//  tianyanAR
//
//  Created by weily on 16/5/11.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 决定一个存在于ARInterface中，决定该ar是否支持哪些手势
@interface RCGestureConfig : NSObject

@property (nonatomic, assign) BOOL transition;

@property (nonatomic, assign) BOOL scale;

@property (nonatomic, assign) BOOL rotation;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
