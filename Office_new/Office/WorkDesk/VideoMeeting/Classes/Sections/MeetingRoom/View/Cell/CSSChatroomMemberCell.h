//
//  CSSChatroomMemberCell.h
//  NIM
//
//  Created by chris on 15/12/18.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSAvatarImageView;

@interface CSSChatroomMemberCell : UITableViewCell

@property (nonatomic, strong) CSAvatarImageView *avatarImageView;

- (void)refresh:(NIMChatroomMember *)member;

@end
