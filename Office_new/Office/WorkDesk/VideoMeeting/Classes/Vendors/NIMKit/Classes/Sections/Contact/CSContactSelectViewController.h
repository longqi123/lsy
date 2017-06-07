//
//  CSContactSelectViewController.h
//  CSKit
//
//  Created by chris on 15/9/14.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSContactSelectConfig.h"

typedef void(^ContactSelectFinishBlock)(NSArray *);
typedef void(^ContactSelectCancelBlock)(void);

@protocol NIMContactSelectDelegate <NSObject>

@optional

- (void)didFinishedSelect:(NSArray *)selectedContacts; // 返回userID

- (void)didCancelledSelect;

@end


@interface CSContactSelectViewController : UIViewController

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong, readonly) id<CSContactSelectConfig> config;

//回调处理
@property (nonatomic, weak) id<NIMContactSelectDelegate> delegate;

@property (nonatomic, copy) ContactSelectFinishBlock finshBlock;

@property (nonatomic, copy) ContactSelectCancelBlock cancelBlock;

/**
 *  初始化方法
 *
 *  @param config 联系人选择器配置
 *
 *  @return 选择器
 */
- (instancetype)initWithConfig:(id<CSContactSelectConfig>) config;

/**
 *  弹出联系人选择器
 */
- (void)show;

@end