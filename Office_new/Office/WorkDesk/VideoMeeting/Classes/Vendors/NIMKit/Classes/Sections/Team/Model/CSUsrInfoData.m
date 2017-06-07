//
//  UsrInfoData.m
//  NIM
//
//  Created by Xuhui on 15/3/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSUsrInfoData.h"
#import "CSGroupedDataCollection.h"
#import "CSSpellingCenter.h"
#import "CSKit.h"

@implementation CSUsrInfo

- (BOOL)isFriend {
    NSArray *friends = [NIMSDK sharedSDK].userManager.myFriends;
    for (NIMUser *user in friends) {
        if ([user.userId isEqualToString:self.info.infoId]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)groupTitle {
    NSString *title = [[CSSpellingCenter sharedCenter] firstLetter:self.info.showName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z') {
        return title;
    }else{
        return @"#";
    }
}

- (NSString *)memberId{
    return self.info.infoId;
}

- (NSString *)showName{
    return self.info.showName;
}

- (id)sortKey {
    return [[CSSpellingCenter sharedCenter] spellingForString:self.info.showName].shortSpelling;
}

@end

