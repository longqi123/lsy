//
//  CSCellConfig.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSSessionMessageContentView;
@class CSMessageModel;

@protocol CSCellLayoutConfig <NSObject>

@optional

/**
 * @return 返回message的内容大小
 */
- (CGSize)contentSize:(CSMessageModel *)model cellWidth:(CGFloat)width;


/**
 *  需要构造的cellContent类名
 */
- (NSString *)cellContent:(CSMessageModel *)model;

/**
 *  左对齐的气泡，cell气泡距离整个cell的内间距
 */
- (UIEdgeInsets)cellInsets:(CSMessageModel *)model;

/**
 *  左对齐的气泡，cell内容距离气泡的内间距，
 */
- (UIEdgeInsets)contentViewInsets:(CSMessageModel *)model;

/**
 *  是否显示头像
 */
- (BOOL)shouldShowAvatar:(CSMessageModel *)model;


/**
 *  左对齐的气泡，头像到左边的距离
 */
- (CGFloat)avatarMargin:(CSMessageModel *)model;

/**
 *  是否显示姓名
 */
- (BOOL)shouldShowNickName:(CSMessageModel *)model;

/**
 *  左对齐的气泡，昵称到左边的距离
 */
- (CGFloat)nickNameMargin:(CSMessageModel *)model;


/**
 *  消息显示在左边
 */
- (BOOL)shouldShowLeft:(CSMessageModel *)model;


/**
 *  需要添加到Cell上的自定义视图
 */
- (NSArray *)customViews:(CSMessageModel *)model;


/**
 *  格式化消息文本
 *  @discussion ，仅当cellContent为CSSessionNotificationContentView时会调用.如果是CSSessionNotificationContentView的子类,需要继承refresh:方法。
 */
- (NSString *)formatedMessage:(CSMessageModel *)model;

@end
