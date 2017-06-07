//
//  NIMChatroomMessageDataProvider.m
//  NIM
//
//  Created by chris on 15/12/14.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "CSSChatroomMessageDataProvider.h"

@interface CSSChatroomMessageDataProvider()

@property (nonatomic,copy)   NSString *roomId;

@end

@implementation CSSChatroomMessageDataProvider

- (instancetype)initWithChatroom:(NSString *)roomId
{
    self = [super init];
    if (self)
    {
        _roomId = roomId;
    }
    return self;
}

- (void)pullDown:(NIMMessage *)firstMessage handler:(CSKitDataProvideHandler)handler
{
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.startTime = firstMessage.timestamp;
    option.limit = 10;
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError *error, NSArray *messages) {
        if (handler) {
            handler(error,messages.reverseObjectEnumerator.allObjects);
        }
    }];
}


- (BOOL)needTimetag{
    return NO;
}

@end
