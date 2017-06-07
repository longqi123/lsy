//
//  NIMSessionDefaultConfig.m
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSCellLayoutDefaultConfig.h"
#import "CSSessionMessageContentView.h"
#import "CSSessionUnknowContentView.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSKitUtil.h"
#import "UIImage+CS.h"
#import "CSMessageModel.h"
#import "CSBaseSessionContentConfig.h"

@implementation CSCellLayoutDefaultConfig

- (CGSize)contentSize:(CSMessageModel *)model cellWidth:(CGFloat)cellWidth{
    
    id<CSSessionContentConfig>config = [[CSSessionContentConfigFactory sharedFacotry] configBy:model.message];
    return [config contentSize:cellWidth];
}

- (NSString *)cellContent:(CSMessageModel *)model{
    
    id<CSSessionContentConfig>config = [[CSSessionContentConfigFactory sharedFacotry] configBy:model.message];
    NSString *cellContent = [config cellContent];
    return cellContent ? : @"CSSessionUnknowContentView";
}


- (UIEdgeInsets)contentViewInsets:(CSMessageModel *)model{
    id<CSSessionContentConfig>config = [[CSSessionContentConfigFactory sharedFacotry] configBy:model.message];
    return [config contentViewInsets];
}


- (UIEdgeInsets)cellInsets:(CSMessageModel *)model
{
    if ([[model.layoutConfig cellContent:model] isEqualToString:@"CSSessionNotificationContentView"]) {
        return UIEdgeInsetsZero;
    }
    CGFloat cellTopToBubbleTop           = 3;
    CGFloat otherNickNameHeight          = 20;
    CGFloat otherBubbleOriginX           = [self shouldShowAvatar:model]? 55 : 0;
    CGFloat cellBubbleButtomToCellButtom = 13;
    if ([self shouldShowNickName:model])
    {
        //要显示名字
        return UIEdgeInsetsMake(cellTopToBubbleTop + otherNickNameHeight ,otherBubbleOriginX,cellBubbleButtomToCellButtom, 0);
    }
    else
    {
        return UIEdgeInsetsMake(cellTopToBubbleTop,otherBubbleOriginX,cellBubbleButtomToCellButtom, 0);
    }

}

- (BOOL)shouldShowAvatar:(CSMessageModel *)model
{
    if ([[model.layoutConfig cellContent:model] isEqualToString:@"CSSessionNotificationContentView"]) {
        return NO;
    }
    return YES;
}


- (BOOL)shouldShowNickName:(CSMessageModel *)model{
    NIMMessage *message = model.message;
    if (message.messageType == NIMMessageTypeNotification)
    {
        NIMNotificationType type = [(NIMNotificationObject *)message.messageObject notificationType];
        if (type == NIMNotificationTypeTeam) {
            return NO;
        }
    }
    return (!message.isOutgoingMsg && message.session.sessionType == NIMSessionTypeTeam);
}


- (BOOL)shouldShowLeft:(CSMessageModel *)model
{
    return !model.message.isOutgoingMsg;
}

- (CGFloat)avatarMargin:(CSMessageModel *)model
{
    return 8.f;
}

- (CGFloat)nickNameMargin:(CSMessageModel *)model
{
    return [self shouldShowAvatar:model] ? 57.f : 10.f;
}


- (NSString *)formatedMessage:(CSMessageModel *)model{
    return [CSKitUtil formatedMessage:model.message];
}

- (NSArray *)customViews:(CSMessageModel *)model
{
    return nil;
}


@end
