//
//  CSSMeetingNetCallManager.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/24.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSService.h"

@protocol CSSMeetingNetCallManagerDelegate <NSObject>

@required

- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error;

- (void)onMeetingConntectStatus:(BOOL)connected;

@end

@interface CSSMeetingNetCallManager : CSSService

@property(nonatomic, readonly) BOOL isInMeeting;

- (void)joinMeeting:(NSString *)name delegate:(id<CSSMeetingNetCallManagerDelegate>)delegate;

- (void)leaveMeeting;

@end
