//
//  CSMessageCell.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMessageCellProtocol.h"
#import "CSTimestampModel.h"

@class CSSessionMessageContentView;
@class CSAvatarImageView;
@class CSBadgeView;

@interface CSMessageCell : UITableViewCell

@property (nonatomic, strong) CSAvatarImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;                                 //姓名（群显示 个人不显示）
@property (nonatomic, strong) CSSessionMessageContentView *bubbleView;           //内容区域
@property (nonatomic, strong) UIActivityIndicatorView *traningActivityIndicator;  //发送loading
@property (nonatomic, strong) UIButton *retryButton;                              //重试
@property (nonatomic, strong) CSBadgeView *audioPlayedIcon;                      //语音未读红点

@property (nonatomic, weak)   id<CSMessageCellDelegate> messageDelegate;

- (void)refreshData:(CSMessageModel *)data;

@end
