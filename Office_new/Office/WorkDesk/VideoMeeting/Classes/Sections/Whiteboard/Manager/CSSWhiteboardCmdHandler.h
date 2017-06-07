//
//  CSSWhiteboardCmdHandler.h
//  NIMEducationDemo
//
//  Created by fenric on 16/10/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSWhiteboardPoint.h"
#import "CSSWhiteboardCommand.h"
#import "CSSMeetingRTSManager.h"

@protocol CSSWhiteboardCmdHandlerDelegate <NSObject>

- (void)onReceivePoint:(CSSWhiteboardPoint *)point from:(NSString *)sender;

- (void)onReceiveCmd:(NTESWhiteBoardCmdType)type from:(NSString *)sender;

- (void)onReceiveSyncRequestFrom:(NSString *)sender;

- (void)onReceiveSyncPoints:(NSMutableArray *)points owner:(NSString *)owner;

- (void)onReceiveLaserPoint:(CSSWhiteboardPoint *)point from:(NSString *)sender;

- (void)onReceiveHiddenLaserfrom:(NSString *)sender;

- (void)onReceiveDocShareInfo:(CSSDocumentShareInfo *)shareInfo from:(NSString *)sender;



@end

@interface CSSWhiteboardCmdHandler : NSObject<NTESMeetingRTSDataHandler>

- (instancetype)initWithDelegate:(id<CSSWhiteboardCmdHandlerDelegate>)delegate;

- (void)sendMyPoint:(CSSWhiteboardPoint *)point;

- (void)sendPureCmd:(NTESWhiteBoardCmdType)type to:(NSString *)uid;

- (void)sync:(NSDictionary *)allLines toUser:(NSString *)targetUid;

- (void)sendDocShareInfo:(CSSDocumentShareInfo *)shareInfo toUser:(NSString*)targetUid;

@end
