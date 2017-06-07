//
//  CSSessionMsgDatasource.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSKitMessageProvider.h"

@class CSMessageModel;

@protocol CSSessionMsgDatasourceDelegate <NSObject>

- (void)messageDataIsReady;

@end

@interface CSSessionMsgDatasource : NSObject

- (instancetype)initWithSession:(NIMSession*)session
                   dataProvider:(id<CSKitMessageProvider>)dataProvider
               showTimeInterval:(NSTimeInterval)timeInterval
                          limit:(NSInteger)limit;


@property (nonatomic, strong) NSMutableArray      *modelArray;
@property (nonatomic, readonly) NSInteger         messageLimit;                //每页消息显示条数
@property (nonatomic, readonly) NSInteger         showTimeInterval;            //两条消息相隔多久显示一条时间戳
@property (nonatomic, weak) id<CSSessionMsgDatasourceDelegate> delegate;


- (NSInteger)indexAtModelArray:(CSMessageModel*)model;

//复位消息
- (void)resetMessages:(void(^)(NSError *error)) handler;

//数据对外接口
- (void)loadHistoryMessagesWithComplete:(void(^)(NSInteger index , NSArray *messages ,NSError *error))handler;

- (NSArray<NSNumber *> *)addMessageModels:(NSArray*)models;

- (NSArray<NSNumber *> *)deleteMessageModel:(CSMessageModel*)model;

//清理缓存数据
- (void)cleanCache;
@end
