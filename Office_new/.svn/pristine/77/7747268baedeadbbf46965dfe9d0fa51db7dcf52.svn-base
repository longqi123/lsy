//
//  TeamMemberCardViewController.h
//  NIM
//
//  Created by Xuhui on 15/3/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSTeamCardMemberItem;

@protocol CSTeamMemberCardActionDelegate <NSObject>
@optional

- (void)onTeamMemberKicked:(CSTeamCardMemberItem *)member;
- (void)onTeamMemberInfoChaneged:(CSTeamCardMemberItem *)member;

@end

@interface CSTeamMemberCardViewController : UIViewController

@property (nonatomic, strong) id<CSTeamMemberCardActionDelegate> delegate;
@property (nonatomic, strong) CSTeamCardMemberItem *member;
@property (nonatomic, strong) CSTeamCardMemberItem *viewer;

@end
