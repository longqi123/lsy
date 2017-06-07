//
//  CSMessageCellProtocol.h
//  CSKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSCellConfig.h"


@class CSMessageModel;
@class NIMMessage;
@class CSKitEvent;
@protocol CSMessageCellDelegate <NSObject>

@optional

- (void)onTapCell:(CSKitEvent *)event;

- (void)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view;

- (void)onRetryMessage:(NIMMessage *)message;

- (void)onTapAvatar:(NSString *)userId;

- (void)onTapLinkData:(id)linkData;

@end
