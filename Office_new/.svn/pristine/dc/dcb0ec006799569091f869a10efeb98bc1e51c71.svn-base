//
//  CSSMeetingMessageHandler.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/17.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSSMeetingControlAttachment;

@protocol CSSMeetingMessageHandlerDelegate <NSObject>

- (void)onMembersEnterRoom:(NSArray *)members;

- (void)onMembersExitRoom:(NSArray *)members;

- (void)onMembersShowFullScreen:(NSString *)notifyExt;

- (void)onReceiveMeetingCommand:(CSSMeetingControlAttachment *)attachment from:(NSString *)userId;

@end


@interface CSSMeetingMessageHandler : NSObject

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom delegate:(id<CSSMeetingMessageHandlerDelegate>)delegate;

- (void)sendMeetingP2PCommand:(CSSMeetingControlAttachment *)attachment
                           to:(NSString *)uid;

- (void)sendMeetingBroadcastCommand:(CSSMeetingControlAttachment *)attachment;


@end
