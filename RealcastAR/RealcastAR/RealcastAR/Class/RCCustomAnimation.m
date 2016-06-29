//
//  RCCustomAnimation.m
//  RealcastAR
//
//  Created by fish on 16/5/26.
//  Copyright © 2016年 huangtao. All rights reserved.
//

// 用户自定义动画

#import "RCCustomAnimation.h"

@interface RCCustomAnimation()

/**
 *  当前位移
 */
@property(nonatomic, strong) RCTransform *translate;

/**
 *  当前角度
 */
@property(nonatomic, strong) RCTransform *rotate;

/**
 *  当前缩放
 */
@property(nonatomic, strong) RCTransform *scale;

/**
 *  当前时间（从0开始）
 */
@property(nonatomic, assign) CGFloat currentTime;

/**
 *  结束时间（时间频率按1计算）
 */
@property(nonatomic, assign) CGFloat timeEnd;

@property(nonatomic, assign) CGFloat timeRate;

/**
 *  时间控制器
 */
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation RCCustomAnimation

- (void)dealloc {
    [self.timer invalidate];
}

- (instancetype)initWithTransform:(RCTransform *)begin end:(RCTransform *)end animationType:(AnimationType)animationType duration:(CGFloat)duration {
    self = [super init];
    if (self) {
        _transformTranslateBegin = begin;
        _transformRotateBegin    = begin;
        _transformScaleBegin     = begin;
        
        _transformTranslateEnd   = end;
        _transformRotateEnd      = end;
        _transformScaleEnd       = end;
        
        self.animationType = animationType;
        self.duration = duration;
    }
    return self;
}

+ (RCCustomAnimation *)customAnimationWithTransform:(RCTransform *)begin end:(RCTransform *)end animationType:(AnimationType)animationType duration:(CGFloat)duration {
    return [[RCCustomAnimation alloc] initWithTransform:begin end:end animationType:animationType duration:duration];
}

- (void)timeCall {
    
    self.currentTime += self.timeRate;
    if (self.currentTime >= self.duration) {
        self.currentTime = self.duration;
    }

    if (_animationCallback) {
        CGFloat d = self.duration;
        CGFloat t = self.currentTime;
        
        // 计算位移
        CGFloat xTranslate = [self countWithAnimationType:self.animationType time:t start:self.transformTranslateBegin.x delta:(self.transformTranslateEnd.x - self.transformTranslateBegin.x) duration:d];
        CGFloat yTranslate = [self countWithAnimationType:self.animationType time:t start:self.transformTranslateBegin.y delta:(self.transformTranslateEnd.y - self.transformTranslateBegin.y) duration:d];
        CGFloat zTranslate = [self countWithAnimationType:self.animationType time:t start:self.transformTranslateBegin.z delta:(self.transformTranslateEnd.z - self.transformTranslateBegin.z) duration:d];
        
        self.translate.x = xTranslate;
        self.translate.y = yTranslate;
        self.translate.z = zTranslate;
        
        // 计算旋转
        CGFloat xRotate = [self countWithAnimationType:self.animationType time:t start:self.transformRotateBegin.x delta:(self.transformRotateEnd.x - self.transformRotateBegin.x) duration:d];
        CGFloat yRotate = [self countWithAnimationType:self.animationType time:t start:self.transformRotateBegin.y delta:(self.transformRotateEnd.y - self.transformRotateBegin.y) duration:d];
        CGFloat zRotate = [self countWithAnimationType:self.animationType time:t start:self.transformRotateBegin.z delta:(self.transformRotateEnd.z - self.transformRotateBegin.z) duration:d];
        
        self.rotate.x = xRotate;
        self.rotate.y = yRotate;
        self.rotate.z = zRotate;
        
        // 计算缩放
        CGFloat xScale = [self countWithAnimationType:self.animationType time:t start:self.transformScaleBegin.x delta:(self.transformScaleEnd.x - self.transformScaleBegin.x) duration:d];
        CGFloat yScale = [self countWithAnimationType:self.animationType time:t start:self.transformScaleBegin.y delta:(self.transformScaleEnd.y - self.transformScaleBegin.y) duration:d];
        CGFloat zScale = [self countWithAnimationType:self.animationType time:t start:self.transformScaleBegin.z delta:(self.transformScaleEnd.z - self.transformScaleBegin.z) duration:d];
        
        self.scale.x = xScale;
        self.scale.y = yScale;
        self.scale.z = zScale;
        
        self.animationCallback(self.translate, self.rotate, self.scale);
    }
    
    if (self.currentTime >= self.duration) { // 时间结束
        self.timer.fireDate = [NSDate distantFuture];
        [self.timer invalidate];
        
        // 结束回调
        if (self.animationEnd) {
            self.animationEnd();
        }
    }
}

- (void)startAnimation {
    // 初始化时间相关
    self.currentTime = 0;
    self.timeRate = 1.0 / 120; // 120帧每秒
    
    // 初始化矩阵
    self.translate = [[RCTransform alloc] init];
    self.rotate    = [[RCTransform alloc] init];
    self.scale     = [[RCTransform alloc] init];
    
    // 开启时间控制器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeRate target:self selector:@selector(timeCall) userInfo:nil repeats:YES];
    [self.timer fire];
}

#pragma mark -- 计算
/**
 *  计算当前x|y|z状态
 *
 *  @param type 动画类型
 *  @param t    当前时间
 *  @param b    初始值
 *  @param c    变化量
 *  @param d    持续时间
 *
 *  @return 当前值
 */
- (CGFloat)countWithAnimationType:(AnimationType)type time:(CGFloat)t start:(CGFloat)b delta:(CGFloat)c duration:(CGFloat)d {
    
    switch (type) {
        case ANIM_TYPE_LINEAR://线性缓动
        {
            return c*t/d + b;
        } break;
            
        case ANIM_TYPE_QUAD://二次缓动
        {
            if ((t/=d/2) < 1) return c/2*t*t + b;
            
            t -= 1;
            return -c/2 * ((t)*(t-2) - 1) + b;
        } break;
            
        case ANIM_TYPE_CUBIC://三次缓动
        {
            if ((t/=d/2) < 1) return c/2*t*t*t + b;
            
            t -= 2;
            return c/2*((t)*t*t + 2) + b;
            
        } break;
            
        case ANIM_TYPE_QUART://四次缓动
        {
            if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
            
            t-=2;
            return -c/2 * ((t)*t*t*t - 2) + b;
        } break;
            
        case ANIM_TYPE_QUINT://五次缓动
        {
            if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
            
            t-=2;
            return c/2*((t)*t*t*t*t + 2) + b;
        } break;
            
        case ANIM_TYPE_CIRC://圆
        {
            if ((t/=d/2) < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
            
            t-=2;
            return c/2 * (sqrt(1 - t*t) + 1) + b;
        } break;
            
        case ANIM_TYPE_SINE://正弦
        {
            return -c/2 * (cos(M_PI*t/d) - 1) + b;
        } break;
            
        case ANIM_TYPE_EXPO://指数
        {
            if (t==0) return b;
            if (t==d) return b+c;
            if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
            return c/2 * (-pow(2, -10 * --t) + 2) + b;
        } break;
            
        case ANIM_TYPE_BOUNCE: // 暂且使用EaseOut
        {
            if (t < d/2) return [self easeIn:t*2 b:0 c:c d:d] * .5 + b;
            else return [self easeOut:(t*2-d) b:0 c:c d:d] * .5 + c*.5 + b;
        } break;
            
        default:
        {
            
        } break;
    }
    
    return 1.0;
}

// 弹簧效果
- (CGFloat)easeOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d {
    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        t-=(1.5/2.75);
        return c*(7.5625*(t)*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        t-=(2.25/2.75);
        return c*(7.5625*(t)*t + .9375) + b;
    } else {
        t-=(2.625/2.75);
        return c*(7.5625*(t)*t + .984375) + b;
    }
}

-(CGFloat)easeIn:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d {
    return (c - [self easeOut:(d-t) b:0 c:c d:d] + b);
}

@end










