//
//  CSSessionMsgDatasource.m
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSSessionMsgDatasource.h"
#import "UITableView+CSScrollToBottom.h"
#import "CSMessageModel.h"
#import "CSTimestampModel.h"
#import "CSGlobalMacro.h"

@interface CSSessionMsgDatasource()

@property (nonatomic,strong) id<CSKitMessageProvider> dataProvider;

@property (nonatomic,strong) NSMutableDictionary *msgIdDict;

//因为插入消息之后，消息到发送完毕后会改成服务器时间，所以不能简单和前一条消息对比时间戳去插时间
//这里记下来插消息时的本地时间，按这个去比
@property (nonatomic,assign) NSTimeInterval firstTimeInterval;

@property (nonatomic,assign) NSTimeInterval lastTimeInterval;

@end

@implementation CSSessionMsgDatasource
{
    NIMSession *_currentSession;
    dispatch_queue_t _messageQueue;
}

- (instancetype)initWithSession:(NIMSession*)session
                   dataProvider:(id<CSKitMessageProvider>)dataProvider
               showTimeInterval:(NSTimeInterval)timeInterval
                          limit:(NSInteger)limit
{
    if (self = [self init]) {
        _currentSession    = session;
        _dataProvider      = dataProvider;
        _messageLimit      = limit;
        _showTimeInterval  = timeInterval;
        _firstTimeInterval = 0;
        _lastTimeInterval  = 0;
        _modelArray        = [NSMutableArray array];
        _msgIdDict         = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)resetMessages:(void(^)(NSError *error)) handler
{
    self.modelArray        = [NSMutableArray array];
    self.msgIdDict         = [NSMutableDictionary dictionary];
    self.firstTimeInterval = 0;
    self.lastTimeInterval  = 0;
    if ([self.dataProvider respondsToSelector:@selector(pullDown:handler:)])
    {
        __weak typeof(self) wself = self;
        [self.dataProvider pullDown:nil handler:^(NSError *error, NSArray<NIMMessage *> *messages) {
            CSKit_Dispatch_Async_Main(^{
                [wself appendMessageModels:[self modelsWithMessages:messages]];
                wself.firstTimeInterval = [messages.firstObject timestamp];
                wself.lastTimeInterval  = [messages.lastObject timestamp];
                if ([self.delegate respondsToSelector:@selector(messageDataIsReady)]) {
                    [self.delegate messageDataIsReady];
                }
            });
        }];
    }
    else
    {
        NSArray<NIMMessage *> *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:_currentSession
                                                                                   message:nil
                                                                                     limit:_messageLimit];
        [self appendMessageModels:[self modelsWithMessages:messages]];
        self.firstTimeInterval = [messages.firstObject timestamp];
        self.lastTimeInterval  = [messages.lastObject timestamp];
        if ([self.delegate respondsToSelector:@selector(messageDataIsReady)]) {
            [self.delegate messageDataIsReady];
        }
    }
}


/**
 *  从头插入消息
 *
 *  @param messages 消息
 *
 *  @return 插入后table要滑动到的位置
 */
- (NSInteger)insertMessages:(NSArray *)messages{
    NSInteger count = self.modelArray.count;
    for (NIMMessage *message in messages.reverseObjectEnumerator.allObjects) {
        [self insertMessage:message];
    }
    NSInteger currentIndex = self.modelArray.count - 1;
    return currentIndex - count;
}


/**
 *  从后插入消息
 *
 *  @param messages 消息集合
 *
 *  @return 插入的消息的index
 */
- (NSArray *)appendMessageModels:(NSArray *)models{
    if (!models.count) {
        return @[];
    }
    NSInteger count = self.modelArray.count;
    for (CSMessageModel *model in models) {
        [self appendMessageModel:model];
    }
    NSMutableArray *append = [[NSMutableArray alloc] init];
    for (NSInteger i = count; i < self.modelArray.count; i++) {
        [append addObject:@(i)];
    }
    return append;
}


- (NSInteger)indexAtModelArray:(CSMessageModel *)model
{
    __block NSInteger index = -1;
    if (![_msgIdDict objectForKey:model.message.messageId]) {
        return index;
    }
    [_modelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CSMessageModel class]]) {
            if ([model isEqual:obj]) {
                index = idx;
                *stop = YES;
            }
        }
    }];
    return index;
}

#pragma mark - msg

- (NSArray<NSNumber *> *)addMessageModels:(NSArray*)models
{
    return [self appendMessageModels:models];
}

- (BOOL)modelIsExist:(CSMessageModel *)model
{
    return [_msgIdDict objectForKey:model.message.messageId] != nil;
}


- (void)loadHistoryMessagesWithComplete:(void(^)(NSInteger index, NSArray *messages , NSError *error))handler
{
    __block CSMessageModel *currentOldestMsg = nil;
    [_modelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CSMessageModel class]]) {
            currentOldestMsg = (CSMessageModel*)obj;
            *stop = YES;
        }
    }];
    NSInteger index = 0;
    if ([self.dataProvider respondsToSelector:@selector(pullDown:handler:)])
    {
        __weak typeof(self) wself = self;
        [self.dataProvider pullDown:currentOldestMsg.message handler:^(NSError *error, NSArray *messages) {
            CSKit_Dispatch_Async_Main(^{
                NSInteger index = [wself insertMessages:messages];
                if (handler) {
                    handler(index,messages,error);
                }
            });
        }];
        return;
    }
    else
    {
        NSArray *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:_currentSession
                                                                                message:currentOldestMsg.message
                                                                                  limit:self.messageLimit];
        index = [self insertMessages:messages];
        if (handler) {
            CSKit_Dispatch_Async_Main(^{
                handler(index,messages,nil);
            });
        }
    }
}

- (NSArray*)deleteMessageModel:(CSMessageModel *)msgModel
{
    NSMutableArray *dels = [NSMutableArray array];
    NSInteger delTimeIndex = -1;
    NSInteger delMsgIndex = [_modelArray indexOfObject:msgModel];
    if (delMsgIndex > 0) {
        BOOL delMsgIsSingle = (delMsgIndex == _modelArray.count-1 || [_modelArray[delMsgIndex+1] isKindOfClass:[CSTimestampModel class]]);
        if ([_modelArray[delMsgIndex-1] isKindOfClass:[CSTimestampModel class]] && delMsgIsSingle) {
            delTimeIndex = delMsgIndex-1;
            [_modelArray removeObjectAtIndex:delTimeIndex];
            [dels addObject:@(delTimeIndex)];
        }
    }
    if (delMsgIndex > -1) {
        [_modelArray removeObject:msgModel];
        [_msgIdDict removeObjectForKey:msgModel.message.messageId];
        [dels addObject:@(delMsgIndex)];
    }
    return dels;
}

- (void)cleanCache
{
    for (id item in _modelArray)
    {
        if ([item isKindOfClass:[CSMessageModel class]])
        {
            CSMessageModel *model = (CSMessageModel *)item;
            [model cleanCache];
        }
    }
}

#pragma mark - private methods
- (void)insertMessage:(NIMMessage *)message{
    CSMessageModel *model = [[CSMessageModel alloc] initWithMessage:message];
    if ([self modelIsExist:model]) {
        return;
    }
    if (self.firstTimeInterval && self.firstTimeInterval - model.message.timestamp < self.showTimeInterval) {
        //此时至少有一条消息和时间戳（如果有的话）
        //干掉时间戳（如果有的话）
        if ([self.modelArray.firstObject isKindOfClass:[CSTimestampModel class]]) {
            [self.modelArray removeObjectAtIndex:0];
        }
    }
    [self.modelArray insertObject:model atIndex:0];
    if (![self.dataProvider respondsToSelector:@selector(needTimetag)] || self.dataProvider.needTimetag) {
        CSTimestampModel *timeModel = [[CSTimestampModel alloc] init];
        timeModel.messageTime = model.message.timestamp;
        [self.modelArray insertObject:timeModel atIndex:0];
    }
    self.firstTimeInterval = model.message.timestamp;
    [self.msgIdDict setObject:model forKey:model.message.messageId];
}


- (void)appendMessageModel:(CSMessageModel *)model{
    if ([self modelIsExist:model]) {
        return;
    }

    if (![self.dataProvider respondsToSelector:@selector(needTimetag)] || self.dataProvider.needTimetag)
    {
        if (model.message.timestamp - self.lastTimeInterval > self.showTimeInterval) {
            CSTimestampModel *timeModel = [[CSTimestampModel alloc] init];
            timeModel.messageTime = model.message.timestamp;
            [self.modelArray addObject:timeModel];
        }
    }
    [self.modelArray addObject:model];
    self.lastTimeInterval = model.message.timestamp;
    [self.msgIdDict setObject:model forKey:model.message.messageId];
}

- (void)subHeadMessages:(NSInteger)count
{
    NSInteger catch = 0;
    NSArray *modelArray = [NSArray arrayWithArray:self.modelArray];
    for (CSMessageModel *model in modelArray) {
        if ([model isKindOfClass:[CSMessageModel class]]) {
            catch++;
            [self deleteMessageModel:model];
        }
        if (catch == count) {
            break;
        }
    }
}

- (NSArray<CSMessageModel *> *)modelsWithMessages:(NSArray<NIMMessage *> *)messages
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NIMMessage *message in messages) {
        CSMessageModel *model = [[CSMessageModel alloc] initWithMessage:message];
        [array addObject:model];
    }
    return array;
}


@end