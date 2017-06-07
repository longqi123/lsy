//
//  NTESCardMemberItem.m
//  NIM
//
//  Created by chris on 15/3/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSCardMemberItem.h"
#import "CSUsrInfoData.h"
#import "CSKitUtil.h"
#import "CSKit.h"

@interface CSTeamCardMemberItem()
@property (nonatomic,readwrite,strong) NIMTeamMember *member;
@property (nonatomic,copy)   NSString      *userId;
@end;

@implementation CSTeamCardMemberItem

- (instancetype)initWithMember:(NIMTeamMember*)member{
    self = [self init];
    if (self) {
        _member  = member;
        _userId  = member.userId;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[CSTeamCardMemberItem class]]) {
        return NO;
    }
    CSTeamCardMemberItem *obj = (CSTeamCardMemberItem*)object;
    return [obj.memberId isEqualToString:self.memberId];
}

- (NSString *)imageUrl{
    return [[CSKit sharedKit] infoByUser:_member.userId].avatarUrlString;
}

- (NIMTeamMemberType)type {
    return _member.type;
}

- (void)setType:(NIMTeamMemberType)type {
    _member.type = type;
}

- (NSString *)title {
    NIMSession *session = [NIMSession session:self.member.teamId type:NIMSessionTypeTeam];
    return [CSKitUtil showNick:self.member.userId inSession:session];
}

- (NIMTeam *)team {
    return [[NIMSDK sharedSDK].teamManager teamById:_member.teamId];
}

#pragma mark - TeamCardHeaderData

- (UIImage*)imageNormal{
     CSKitInfo *info = [[CSKit sharedKit] infoByUser:self.member.userId];
    return info.avatarImage;
}

- (UIImage*)imageHighLight{
    CSKitInfo *info = [[CSKit sharedKit] infoByUser:self.member.userId];
    return info.avatarImage;
}

- (NSString*)memberId{
    return self.member.userId;
}

- (CSKitCardHeaderOpeator)opera{
    return CardHeaderOpeatorNone;
}

@end



@interface CSUserCardMemberItem()
@property (nonatomic,strong) CSKitInfo *info;
@end;

@implementation CSUserCardMemberItem

- (instancetype)initWithUserId:(NSString*)userId{
    self = [self init];
    if (self) {
        _info = [[CSKit sharedKit] infoByUser:userId];
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[CSUserCardMemberItem class]]) {
        return NO;
    }
    CSUserCardMemberItem *obj = (CSUserCardMemberItem*)object;
    return [obj.memberId isEqualToString:self.memberId];
}

#pragma mark - TeamCardHeaderData

- (UIImage*)imageNormal{
    return self.info.avatarImage;
}

- (NSString *)imageUrl{
    return self.info.avatarUrlString;
}

- (NSString*)title{
    return self.info.showName;
}

- (NSString*)memberId{
    return self.info.infoId;
}

- (CSKitCardHeaderOpeator)opera{
    return CardHeaderOpeatorNone;
}

@end
