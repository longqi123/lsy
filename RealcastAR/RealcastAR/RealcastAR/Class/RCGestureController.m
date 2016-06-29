//
//  RCAREventGesture.m
//  功能开发
//
//  Created by fish on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCGestureController.h"

@interface RCGestureController()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) RCTransform *transformBegin; // 对象触发时矩阵状态

@property(nonatomic, strong) id target; // 手势添加目标对象

@property(nonatomic, strong) eventGestureBegin eventBegin;  // 手势触发时回调

@property(nonatomic, strong) eventGestureCallback eventCallback; // 手势执行时回调

@end

@implementation RCGestureController

-(instancetype)initWithTarget:(id)target {
    self = [super init];
    if (self) {
        _target = target;
        
        _rate = 1.0;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target eventBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback {
    self = [super init];
    if (self) {
        _target = target;
        _eventBegin = begin;
        _eventCallback = callback;
        
        _rate = 1.0;
    }
    return self;
}

+ (instancetype)arEventGestureWithTarget:(id)target {
    return [[RCGestureController alloc] initWithTarget:target];
}

+ (instancetype)arEventGestureWithTarget:(id)target eventBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback {
    return [[RCGestureController alloc] initWithTarget:target eventBegin:begin eventCallback:callback];
}

#pragma mark -- 长按拖动事件
- (void)arEventPanGesture {
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//    panGesture.delegate = self;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    [longPress addTarget:self action:@selector(panGesture:)];
    longPress.minimumPressDuration = 1;
    longPress.delegate = self;
    [self.target addGestureRecognizer:longPress];
}

- (void)arEventPanGestureWithBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback {
    self.eventBegin = begin;
    self.eventCallback = callback;
    
    [self arEventPanGesture];
}

- (void)panGesture:(UILongPressGestureRecognizer*)sender {
    UIView *view = sender.view;
    static CGPoint _startPoint;
    if (sender.state == UIGestureRecognizerStateBegan) {
        _startPoint = [sender locationInView:view.superview];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [sender locationInView:view.superview];
        CGPoint translation = CGPointMake(current.x - _startPoint.x, current.y - _startPoint.y);
        CGFloat x = self.transformBegin.x + translation.x * self.rate;
        CGFloat y = self.transformBegin.y - translation.y * self.rate;
        CGFloat z = self.transformBegin.z + 0;
        RCTransform *transform = [RCTransform transformWithX:x y:y z:z];
        
        if (self.eventCallback) {
            self.eventCallback(self.transformBegin ,transform);
        }
//        _startPoint = current;
    }
}

#pragma mark -- 旋转事件
// 3D旋转手势通过拖放手势实现
- (void)arEventRotationGesture {
    UIPanGestureRecognizer *rotationGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
    rotationGesture.delegate = self;
    [self.target addGestureRecognizer:rotationGesture];
}

- (void)rotationGesture:(UIPanGestureRecognizer*)sender {
    UIView *view = sender.view;
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:view.superview];
    
        // 根据距离分别算出x,y方向的旋转角度
        CGFloat L360 = 1.0 ; //多少距离＝360度
        
        float x = (translation.x / L360) * self.rate;
        float y = (translation.y / L360) * self.rate;
        RCTransform *transform = [RCTransform transformWithX:self.transformBegin.x + y y:self.transformBegin.y + x z:0];
        
        
        if (self.eventCallback) {
            self.eventCallback(self.transformBegin ,transform);
        }
    }
}

#pragma mark -- 缩放事件
- (void)arEventScaleGesture {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    pinchGesture.delegate = self;
    [self.target addGestureRecognizer:pinchGesture];
}

- (void)arEventScaleGestureWithBegin:(eventGestureBegin)begin eventCallback:(eventGestureCallback)callback {
    self.eventBegin = begin;
    self.eventCallback = callback;
    
    [self arEventScaleGesture];
}

- (void)pinchGesture:(UIPinchGestureRecognizer*)sender {
    // 缩放比例 * 原有比例 * 自定义rate
    
    if (self.transformBegin) {
        CGFloat scale = sender.scale *  self.transformBegin.x * self.rate;
        RCTransform *transform = [RCTransform transformWithX:scale y:scale z:scale];
        
        if (self.eventCallback) {
            self.eventCallback(self.transformBegin ,transform);
        }
    }
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.eventBegin) {
        self.transformBegin = self.eventBegin();
    }
    
    return YES;
}

@end
