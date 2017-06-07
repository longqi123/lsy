//
//  CSSMeetingRolesManager.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/17.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSMeetingRole.h"
#import "CSSService.h"

@protocol CSSMeetingRolesManagerDelegate <NSObject>

@required

- (void)meetingRolesUpdate;

- (void)meetingMemberRaiseHand;

- (void)meetingActorBeenEnabled;

- (void)meetingActorBeenDisabled;

- (void)meetingActorsNumberExceedMax;

- (void)meetingVolumesUpdate;

- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered;

- (void)meetingRolesShowFullScreen:(NSString*)notifyExt;

@end


@interface CSSMeetingRolesManager : CSSService

@property(nonatomic, weak) id<CSSMeetingRolesManagerDelegate> delegate;

- (void)startNewMeeting:(NIMChatroomMember *)me
           withChatroom:(NIMChatroom *)chatroom
             newCreated:(BOOL)newCreated;

- (BOOL)kick:(NSString *)user;

- (BOOL)isActorMemberReachFour;

- (CSSMeetingRole *)role:(NSString *)user;

- (CSSMeetingRole *)memberRole:(NIMChatroomMember *)member;

- (CSSMeetingRole *)myRole;

- (void)setMyVideo:(BOOL)on;

- (void)setMyAudio:(BOOL)on;

- (void)setMyWhiteBoard:(BOOL)on;

- (NSArray *)allActors;

- (void)changeRaiseHand;

- (void)changeMemberActorRole:(NSString *)user;

- (void)updateMeetingUser:(NSString *)user isJoined:(BOOL)joined;

- (void)updateVolumes:(NSDictionary<NSString *, NSNumber *> *)volumes;

@end
