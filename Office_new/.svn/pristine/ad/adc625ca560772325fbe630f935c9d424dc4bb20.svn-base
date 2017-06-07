//
//  NTESGroupedUsrInfo.m
//  NIM
//
//  Created by Xuhui on 15/3/24.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSGroupedUsrInfo.h"
#import "CSKit.h"
#import "CSSpellingCenter.h"

@interface CSGroupUser()

@property (nonatomic,copy)   NSString *userId;

@property (nonatomic,strong) CSKitInfo *info;

@end

@implementation CSGroupUser

- (instancetype)initWithUserId:(NSString *)userId{
    self = [super init];
    if (self) {
        _userId = userId;
        _info = [[CSKit sharedKit] infoByUser:userId];
    }
    return self;
}

- (NSString *)groupTitle{
    NSString *title = [[CSSpellingCenter sharedCenter] firstLetter:self.info.showName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z') {
        return title;
    }else{
        return @"#";
    }
}

- (NSString *)showName{
    return self.info.showName;
}

- (NSString *)memberId{
    return self.userId;
}

- (id)sortKey{
    return [[CSSpellingCenter sharedCenter] spellingForString:self.info.showName].shortSpelling;
}

@end




@interface CSGroupTeamMember()

@property (nonatomic,strong) NIMTeamMember *member;

@end

@implementation CSGroupTeamMember

- (instancetype)initWithUserId:(NSString *)userId teamId:(NSString *)teamId{
    self = [super init];
    if (self) {
        _member = [[NIMSDK sharedSDK].teamManager teamMember:userId inTeam:teamId];
    }
    return self;
}

- (NSString *)groupTitle{
    NSString *title = [[CSSpellingCenter sharedCenter] firstLetter:self.showName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z') {
        return title;
    }else{
        return @"#";
    }
}

- (NSString *)memberId{
    return self.member.userId;
}

- (id)sortKey{
    return [[CSSpellingCenter sharedCenter] spellingForString:self.showName].shortSpelling;
}

- (NSString *)showName{
    if (self.member.nickname.length) {
        return self.member.nickname;
    }
    CSKitInfo *info = [[CSKit sharedKit] infoByUser:self.memberId];
    return info.showName;
}


@end

@interface CSGroupTeam()

@property (nonatomic,strong) NIMTeam *team;

@end

@implementation CSGroupTeam

- (instancetype)initWithTeam:(NSString *)teamId{
    self = [super init];
    if (self) {
        _team = [[NIMSDK sharedSDK].teamManager teamById:teamId];
    }
    return self;
}

- (NSString *)groupTitle{
    NSString *title = [[CSSpellingCenter sharedCenter] firstLetter:self.team.teamName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z') {
        return title;
    }else{
        return @"#";
    }
}

- (NSString *)memberId{
    return self.team.teamId;
}

- (id)sortKey{
    return [[CSSpellingCenter sharedCenter] spellingForString:self.team.teamName].shortSpelling;
}

- (NSString *)showName{
    return self.team.teamName;
}


@end


