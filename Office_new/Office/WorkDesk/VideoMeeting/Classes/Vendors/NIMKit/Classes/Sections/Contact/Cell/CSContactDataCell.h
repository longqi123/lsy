//
//  NTESContactInfoCell.h
//  NIM
//
//  Created by chris on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSContactDefines.h"

@protocol CSContactDataCellDelegate <NSObject>

- (void)onPressAvatar:(NSString *)memberId;

@end

@class CSAvatarImageView;

@interface CSContactDataCell : UITableViewCell

@property (nonatomic,strong) CSAvatarImageView * avatarImageView;

@property (nonatomic,strong) UIButton *accessoryBtn;

@property (nonatomic,weak) id<CSContactDataCellDelegate> delegate;

- (void)refreshUser:(id<CSGroupMemberProtocol>)member;

- (void)refreshTeam:(id<CSGroupMemberProtocol>)member;

@end
