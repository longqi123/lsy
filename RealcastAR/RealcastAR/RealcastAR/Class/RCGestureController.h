//
//  RCAREventGesture.h
//  功能开发
//
//  Created by fish on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//
/**
 *  RXSDK 手势事件封装
 */

/*
 CGFloat m11（x缩放）, m12（y切变）, m13（旋转）, m14（）;
 CGFloat m21（x切变）, m22（y缩放）, m23（）, m24（）;
 CGFloat m31（旋转） , m32（）, m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
 CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
 */


#import <UIKit/UIKit.h>
#import "RCTransform.h"


#pragma mark -- block定义
/**
 *  手势触发时执行的block定义
 *
 *  @return 对象初始变换矩阵
 */
typedef RCTransform* (^eventGestureBegin)();

/**
 *  手势执行时调用的block定义
 *
 *  @param transformBegin 对象初始变换矩阵
 *  @param transform      变化增量矩阵
 */
typedef void(^eventGestureCallback)(RCTransform *transformBegin, RCTransform *transform);

#pragma mark -- 接口定义
@interface RCGestureController : NSObject

@property(nonatomic, assign) CGFloat rate; // 比例，默认为1.0

/**
 *  初始化方法
 *
 *  @param target   手势目标对象
 *  @param begin    手势触发回调
 *  @param callback 手势执行回调
 *
 *  @return 实例对象
 */
- (instancetype)initWithTarget:(id)target eventBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback;

- (instancetype)initWithTarget:(id)target;

// 便利构造
+ (instancetype)arEventGestureWithTarget:(id)target eventBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback;

+ (instancetype)arEventGestureWithTarget:(id)target;

/**
 *  拖动手势
 */
- (void)arEventPanGesture;

- (void)arEventPanGestureWithBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback;

/**
 *  旋转手势
 */
- (void)arEventRotationGesture;

/**
 *  缩放手势
 */
- (void)arEventScaleGesture;

- (void)arEventScaleGestureWithBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback;

@end
