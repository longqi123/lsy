//
//  RICustomAnimation.h
//  RealcastAR
//
//  Created by fish on 16/5/26.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCTransform.h"

// 缓动动画类型
typedef NS_ENUM(NSInteger, AnimationType){
    ANIM_TYPE_LINEAR = 0,        // 线性动画
    ANIM_TYPE_QUAD,    // 二次满进慢出动画
    ANIM_TYPE_CUBIC,   // 三次缓动
    ANIM_TYPE_QUART,   // 四次缓动
    ANIM_TYPE_QUINT,   // 五次缓动
    ANIM_TYPE_SINE,    // 正玄缓动
    ANIM_TYPE_CIRC,    // 圆缓动
    ANIM_TYPE_EXPO,    // 指数
    ANIM_TYPE_BOUNCE,  // 弹簧缓动
};

/**
 *  动画进行中回调
 *
 *  @param translate 当前位置
 *  @param rotate    当前角度
 *  @param scale     当前缩放
 */
typedef void(^animationCallback)(RCTransform *translate, RCTransform *rotate, RCTransform *scale);

/**
 *  动画结束回调
 */
typedef void(^animationEnd)();

@interface RCCustomAnimation : NSObject

/**
 *  位移开始状态
 */
@property(nonatomic, strong) RCTransform *transformTranslateBegin;

/**
 *  位移结束状态
 */
@property(nonatomic, strong) RCTransform *transformTranslateEnd;

/**
 *  旋转开始状态
 */
@property(nonatomic, strong) RCTransform *transformRotateBegin;

/**
 *  旋转结束状态
 */
@property(nonatomic, strong) RCTransform *transformRotateEnd;

/**
 *  缩放开始状态
 */
@property(nonatomic, strong) RCTransform *transformScaleBegin;

/**
 *  缩放结束状态
 */
@property(nonatomic, strong) RCTransform *transformScaleEnd;

/**
 *  动画持续时间
 */
@property(nonatomic, assign) CGFloat duration;

/**
 *  动画类型
 */
@property(nonatomic, assign) AnimationType animationType;

/**
 *  回调
 */
@property(nonatomic, strong) animationCallback animationCallback;

/**
 *  动画结束回调（非必须）
 */
@property(nonatomic, assign) animationEnd animationEnd;

/**
 *  初始化方法
 *
 *  @param begin         开始状态（位移|旋转|缩放）
 *  @param end           结束状态（位移|旋转|缩放）
 *  @param animationType 动画类型
 *  @param duration      动画时长
 *
 *  @return 实例化对象
 */
- (instancetype)initWithTransform:(RCTransform*)begin end:(RCTransform*)end animationType:(AnimationType)animationType duration:(CGFloat)duration;

/**
 *  便利构造
 */
+ (RCCustomAnimation*)customAnimationWithTransform:(RCTransform*)begin end:(RCTransform*)end animationType:(AnimationType)animationType duration:(CGFloat)duration;

///**
// *  执行动画
// *
// *  @param block 在block中返回当前状态
// */
//- (void)animation:(animationCallback)block;

/**
 *  开始动画
 */
- (void)startAnimation;

@end
