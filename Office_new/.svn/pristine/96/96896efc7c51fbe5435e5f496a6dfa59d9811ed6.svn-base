//
//  CSSessionMessageContentView.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSKitEvent.h"

typedef NS_ENUM(NSInteger,CSKitBubbleType){
    CSKitBubbleTypeChat,
    CSKitBubbleTypeNotify,
};

@protocol NIMMessageContentViewDelegate <NSObject>

- (void)onCatchEvent:(CSKitEvent *)event;

@end

@class CSMessageModel;

@interface CSSessionMessageContentView : UIControl

@property (nonatomic,strong,readonly)  CSMessageModel   *model;

@property (nonatomic,strong) UIImageView * bubbleImageView;

@property (nonatomic,assign) CSKitBubbleType bubbleType;

@property (nonatomic,weak) id<NIMMessageContentViewDelegate> delegate;

/**
 *  contentView初始化方法
 *
 *  @return content实例
 */
- (instancetype)initSessionMessageContentView;

/**
 *  刷新方法
 *
 *  @param data 刷新数据
 */
- (void)refresh:(CSMessageModel*)data;


/**
 *  手指从contentView内部抬起
 */
- (void)onTouchUpInside:(id)sender;


/**
 *  手指从contentView外部抬起
 */
- (void)onTouchUpOutside:(id)sender;

/**
 *  手指按下contentView
 */
- (void)onTouchDown:(id)sender;


/**
 *  聊天气泡图
 *
 *  @param state    目前的按压状态
 *  @param outgoing 是否是发出去的消息
 *
 */
- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing;

@end
