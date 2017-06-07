//
//  CSSWhiteboardCmdHandler.m
//  NIMEducationDemo
//
//  Created by fenric on 16/10/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSWhiteboardCmdHandler.h"
#import "CSSTimerHolder.h"
#import "CSSMeetingRTSManager.h"
#import "CSSWhiteboardCommand.h"

#define NTESSendCmdIntervalSeconds 0.06
#define NTESSendCmdMaxSize 30000


@interface CSSWhiteboardCmdHandler()<CSSTimerHolderDelegate>

@property (nonatomic, strong) CSSTimerHolder *sendCmdsTimer;

@property (nonatomic, strong) NSMutableString *cmdsSendBuffer;

@property (nonatomic, assign) UInt64 refPacketID;

@property (nonatomic, weak) id<CSSWhiteboardCmdHandlerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *syncPoints;
@end

@implementation CSSWhiteboardCmdHandler

- (instancetype)initWithDelegate:(id<CSSWhiteboardCmdHandlerDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _sendCmdsTimer = [[CSSTimerHolder alloc] init];
        _cmdsSendBuffer = [[NSMutableString alloc] init];
        _syncPoints = [[NSMutableDictionary alloc] init];
        [_sendCmdsTimer startTimer:NTESSendCmdIntervalSeconds delegate:self repeats:YES];
    }
    return self;
}

- (void)sendDocShareInfo:(CSSDocumentShareInfo *)shareInfo toUser:(NSString*)targetUid
{
    NSString *cmd = [CSSWhiteboardCommand docShareCommand:shareInfo];
    [_cmdsSendBuffer appendString:cmd];
    if (targetUid) {
        [[CSSMeetingRTSManager sharedInstance] sendRTSData:[cmd dataUsingEncoding:NSUTF8StringEncoding]
                                                     toUser:targetUid];
    }
    else{
        [self doSendCmds];
    }
    
}
- (void)sendMyPoint:(CSSWhiteboardPoint *)point
{
    NSString *cmd = [CSSWhiteboardCommand pointCommand:point];
    
    [_cmdsSendBuffer appendString:cmd];
    
    if (_cmdsSendBuffer.length > NTESSendCmdMaxSize) {
        [self doSendCmds];
    }
}

- (void)sendPureCmd:(NTESWhiteBoardCmdType)type to:(NSString *)uid
{
    NSString *cmd = [CSSWhiteboardCommand pureCommand:type];
    if (uid == nil) {
        [_cmdsSendBuffer appendString:cmd];
        [self doSendCmds];
    }
    else {
        [[CSSMeetingRTSManager sharedInstance] sendRTSData:[cmd dataUsingEncoding:NSUTF8StringEncoding]
                                                     toUser:uid];
    }
}

- (void)sync:(NSDictionary *)allLines toUser:(NSString *)targetUid
{
    for (NSString *uid in allLines.allKeys) {
        
        NSMutableString *pointsCmd = [[NSMutableString alloc] init];
        
        NSArray *lines = [allLines objectForKey:uid];
        for (NSArray *line in lines) {
            
            for (CSSWhiteboardPoint *point in line) {
                [pointsCmd appendString:[CSSWhiteboardCommand pointCommand:point]];
            }
            
            int end = [line isEqual:lines.lastObject] ? 1 : 0;

            if (pointsCmd.length > NTESSendCmdMaxSize || end) {
                
                NSString *syncHeadCmd = [CSSWhiteboardCommand syncCommand:uid end:end];
                
                NSString *syncCmds = [syncHeadCmd stringByAppendingString:pointsCmd];
                
                [[CSSMeetingRTSManager sharedInstance] sendRTSData:[syncCmds dataUsingEncoding:NSUTF8StringEncoding]
                                                             toUser:targetUid];
                
                [pointsCmd setString:@""];
            }
        }
    }
}


- (void)onNTESTimerFired:(CSSTimerHolder *)holder
{
    [self doSendCmds];
}

- (void)doSendCmds
{
    if (_cmdsSendBuffer.length) {
        NSString *cmd =  [CSSWhiteboardCommand packetIdCommand:_refPacketID++];
        [_cmdsSendBuffer appendString:cmd];
        
        [[CSSMeetingRTSManager sharedInstance] sendRTSData:[_cmdsSendBuffer dataUsingEncoding:NSUTF8StringEncoding] toUser:nil];
        
//        NSLog(@"send data %@", _cmdsSendBuffer);
        
        [_cmdsSendBuffer setString:@""];
    }
}

- (void)handleReceivedData:(NSData *)data sender:(NSString *)sender
{
    NSString *cmdsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *cmdsArray = [cmdsString componentsSeparatedByString:@";"];
    
    for (NSString *cmdString in cmdsArray) {

        if (cmdString.length == 0) {
            continue;
        }
        
        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];

        NSInteger type = [cmd[0] integerValue];
        switch (type) {
            case NTESWhiteBoardCmdTypePointStart:
            case NTESWhiteBoardCmdTypePointMove:
            case NTESWhiteBoardCmdTypePointEnd:
            {
                if (cmd.count == 4) {
                    CSSWhiteboardPoint *point = [[CSSWhiteboardPoint alloc] init];
                    point.type = type;
                    point.xScale = [cmd[1] floatValue];
                    point.yScale = [cmd[2] floatValue];
                    point.colorRGB = [cmd[3] intValue];
                    if (_delegate) {
                        [_delegate onReceivePoint:point from:sender];
                    }
                }
                else {
                    DDLogError(@"Invalid point cmd: %@", cmdString);
                }
                break;
            }
            case NTESWhiteBoardCmdTypeCancelLine:
            case NTESWhiteBoardCmdTypeClearLines:
            case NTESWhiteBoardCmdTypeClearLinesAck:
            case NTESWhiteBoardCmdTypeSyncPrepare:
            {
                if (_delegate) {
                    [_delegate onReceiveCmd:type from:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeSyncRequest:
            {
                if (_delegate) {
                    [_delegate onReceiveSyncRequestFrom:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeSync:
            {
                NSString *linesOwner = cmd[1];
                int end = [cmd[2] intValue];
                [self handleSync:cmdsArray linesOwner:linesOwner end:end sender:sender];
                return;
            }
            case NTESWhiteBoardCmdTypeLaserPenMove:
            {
                CSSWhiteboardPoint *point = [[CSSWhiteboardPoint alloc] init];
                point.type = type;
                point.xScale = [cmd[1] floatValue];
                point.yScale = [cmd[2] floatValue];
                point.colorRGB = [cmd[3] intValue];
                if (_delegate) {
                    [_delegate onReceiveLaserPoint:point from:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeLaserPenEnd:
            {
                if (_delegate) {
                    [_delegate onReceiveHiddenLaserfrom:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeDocShare:
            {
                [self handleReceivedDocShareData:cmd sender:sender];
                break;
            }

            default:
                break;
        }
    }

}

- (void)handleSync:(NSArray *)cmdsArray linesOwner:(NSString *)linesOwner end:(int)end sender:(NSString*)sender
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < cmdsArray.count; i ++) {
        NSString *cmdString = cmdsArray[i];
        
        if (cmdString.length == 0) {
            continue;
        }

        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
        NSInteger type = [cmd[0] integerValue];
        switch (type) {
            case NTESWhiteBoardCmdTypePointStart:
            case NTESWhiteBoardCmdTypePointMove:
            case NTESWhiteBoardCmdTypePointEnd:
            {
                if (cmd.count == 4) {
                    CSSWhiteboardPoint *point = [[CSSWhiteboardPoint alloc] init];
                    point.type = [cmd[0] integerValue];
                    point.xScale = [cmd[1] floatValue];
                    point.yScale = [cmd[2] floatValue];
                    point.colorRGB = [cmd[3] intValue];
                    [points addObject:point];
                }
                else {
                    DDLogError(@"Invalid point cmd in sync: %@", cmdString);
                }
                break;
            }
            case NTESWhiteBoardCmdTypePacketID:
                break;
                
            case NTESWhiteBoardCmdTypeDocShare:
            {
                [self handleReceivedDocShareData:cmd sender:sender];
                break;
            }

            default:
                DDLogError(@"Invalid cmd in sync: %@", cmdString);
                break;
        }
    }
    
    NSMutableArray *allPoints = [_syncPoints objectForKey:linesOwner];
    
    if (!allPoints) {
        allPoints = [[NSMutableArray alloc] init];
    }

    [allPoints addObjectsFromArray:points];
    
    if (end) {
        if (_delegate) {
            [_delegate onReceiveSyncPoints:allPoints owner:linesOwner];
        }
        
        [_syncPoints removeObjectForKey:linesOwner];
    }
    else {
        [_syncPoints setObject:allPoints forKey:linesOwner];
    }
}

-(void)handleReceivedDocShareData:(NSArray *)cmd sender:(NSString *)sender
{
    CSSDocumentShareInfo *shareInfo = [[CSSDocumentShareInfo alloc]init];
    shareInfo.docId = cmd[1];
    shareInfo.currentPage = [cmd[2]intValue];
    shareInfo.pageCount = [cmd[3]intValue];
    shareInfo.type = [cmd[4]intValue];
    if (_delegate) {
        [_delegate onReceiveDocShareInfo:shareInfo from:sender];
    }
}

@end