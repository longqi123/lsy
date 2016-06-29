//
//  RCARTransform.h
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief AR变换
 */

@interface RCTransform : NSObject

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat z;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

+ (instancetype)transformWithArray:(NSArray *)array;

+ (instancetype)transformWithX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;

- (NSArray *)transformArray;

@end
