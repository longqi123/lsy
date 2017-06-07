//
//  CSKit.m
//  CSKit
//
//  Created by amao on 8/14/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "CSKit.h"
#import "CSKitTimerHolder.h"

NSString *const CSKitUserInfoHasUpdatedNotification = @"CSKitUserInfoHasUpdatedNotification";
NSString *const CSKitTeamInfoHasUpdatedNotification = @"CSKitTeamInfoHasUpdatedNotification";
NSString *const CSKitChatroomMemberInfoHasUpdatedNotification = @"CSKitChatroomMemberInfoHasUpdatedNotification";

NSString *const CSKitInfoKey                        = @"InfoId";
NSString *const CSKitChatroomMembersKey              = @"CSKitChatroomMembersKey";

@interface CSKitNotificationFirer : NSObject<CSKitTimerHolderDelegate>

@property (nonatomic,strong) NSMutableDictionary *cachedInfo;

@property (nonatomic,strong) CSKitTimerHolder *timer;

@property (nonatomic,assign) NSTimeInterval timeInterval;

- (void)addFireInfo:(NIMSession *)info;

@end

@implementation CSKitInfo

@end

@interface CSKit()

@property (nonatomic,strong) CSKitNotificationFirer *firer;

@end

@implementation CSKit
- (instancetype)init
{
    if (self = [super init]) {
        _bundleName = @"NIMKitResouce.bundle";
        _firer = [[CSKitNotificationFirer alloc] init];
    }
    return self;
}

+ (instancetype)sharedKit
{
    static CSKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSKit alloc] init];
    });
    return instance;
}

- (void)notfiyUserInfoChanged:(NSArray *)userIds{
    if (!userIds.count) {
        return;
    }
    for (NSString *userId in userIds) {
        NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
        [self.firer addFireInfo:session];
    }
}

- (void)notfiyTeamInfoChanged:(NSArray *)teamIds{
    if (!teamIds.count) {
        return;
    }
    for (NSString *teamId in teamIds) {
        NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
        [self.firer addFireInfo:session];
    }
}

@end

@implementation CSKit(Private)

- (CSKitInfo *)infoByUser:(NSString *)userId
{
    return [self infoByUser:userId
                  inSession:nil];
}


- (CSKitInfo *)infoByUser:(NSString *)userId
                 inSession:(NIMSession *)session
{
    CSKitInfo *info = nil;
    if (_provider && [_provider respondsToSelector:@selector(infoByUser:inSession:)]) {
        info = [_provider infoByUser:userId inSession:session];
    }
    return info;
}

- (CSKitInfo *)infoByTeam:(NSString *)teamId
{
    CSKitInfo *info = nil;
    if (_provider && [_provider respondsToSelector:@selector(infoByTeam:)]) {
        info = [_provider infoByTeam:teamId];
    }
    return info;

}

- (CSKitInfo *)infoByUser:(NSString *)userId
               withMessage:(NIMMessage *)message
{
    NSAssert([userId isEqualToString:message.from], @"user id should be same with message from");
    
    CSKitInfo *info = nil;
    if (_provider && [_provider respondsToSelector:@selector(infoByUser:withMessage:)]) {
        info = [_provider infoByUser:userId
                         withMessage:message];
    }
    return info;
}

@end



@implementation CSKitNotificationFirer

- (instancetype)init{
    self = [super init];
    if (self) {
        _timer = [[CSKitTimerHolder alloc] init];
        _timeInterval = 1.0f;
        _cachedInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addFireInfo:(NIMSession *)info{
    if (!self.cachedInfo.count) {
        [self.timer startTimer:self.timeInterval delegate:self repeats:NO];
    }
    NSString *identity = [NSString stringWithFormat:@"%@-%zd",info.sessionId,info.sessionType];
    [self.cachedInfo setObject:info forKey:identity];
}

#pragma mark - CSKitTimerHolderDelegate
- (void)onNIMKitTimerFired:(CSKitTimerHolder *)holder{
    NSMutableArray *uinfo = [[NSMutableArray alloc] init];
    NSMutableArray *tinfo = [[NSMutableArray alloc] init];
    for (NIMSession *info in self.cachedInfo.allValues) {
        if (info.sessionType == NIMSessionTypeP2P)
        {
            [uinfo addObject:info.sessionId];
        }
        else if(info.sessionType == NIMSessionTypeTeam)
        {
            [tinfo addObject:info.sessionId];
        }
    }
    if (uinfo.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CSKitUserInfoHasUpdatedNotification object:nil userInfo:@{CSKitInfoKey:uinfo}];
    }
    if (tinfo.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CSKitTeamInfoHasUpdatedNotification object:nil userInfo:@{CSKitInfoKey:tinfo}];
    }
    [self.cachedInfo removeAllObjects];
}

@end

