//
//  CSSChatroomCellLayoutConfig.m
//  NIM
//
//  Created by chris on 16/1/13.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSChatroomCellLayoutConfig.h"
#import "CSBaseSessionContentConfig.h"
#import "CSSChatroomTextContentConfig.h"
#import "CSSCustomAttachmentDefines.h"
#import "CSSSessionCustomContentConfig.h"
#import "CSSChatroomUnknowMessageConfig.h"
#import "CSSJanKenPonAttachment.h"

@interface CSSChatroomCellLayoutConfig()

@property (nonatomic,strong) CSSChatroomTextContentConfig   *textConfig;

@property (nonatomic,strong) CSSSessionCustomContentConfig  *customConfig;

@property (nonatomic,strong) CSSChatroomUnknowMessageConfig *unkownConfig;

@end

@implementation CSSChatroomCellLayoutConfig

- (instancetype)init{
    self = [super init];
    if (self) {
        _textConfig   = [CSSChatroomTextContentConfig new];
        _customConfig = [CSSSessionCustomContentConfig new];
        _unkownConfig = [CSSChatroomUnknowMessageConfig new];
    }
    return self;
}

- (BOOL)shouldShowAvatar:(CSMessageModel *)model{
    return NO;
}


- (CGSize)contentSize:(CSMessageModel *)model cellWidth:(CGFloat)cellWidth
{
    id<CSSessionContentConfig> config = [self chatroomContentConfig:model];
    if (config) {
        return [config contentSize:cellWidth];
    }
    return [super contentSize:model cellWidth:cellWidth];
}

- (NSString *)cellContent:(CSMessageModel *)model
{
    id<CSSessionContentConfig> config = [self chatroomContentConfig:model];
    if (config) {
        return [config cellContent];
    }
    return [super cellContent:model];
}

- (UIEdgeInsets)cellInsets:(CSMessageModel *)model
{
    id<CSSessionContentConfig> config = [self chatroomContentConfig:model];
    if (config) {
        return UIEdgeInsetsZero;
    }
    return [super cellInsets:model];
}

- (UIEdgeInsets)contentViewInsets:(CSMessageModel *)model
{
    id<CSSessionContentConfig> config = [self chatroomContentConfig:model];
    if (config) {
        return [config contentViewInsets];
    }
    return [super contentViewInsets:model];
}

- (BOOL)shouldShowLeft:(CSMessageModel *)model{
    if ([self chatroomContentConfig:model]) {
        return YES;
    }
    return [super shouldShowLeft:model];
}

- (BOOL)shouldShowNickName:(CSMessageModel *)model{
    if ([self chatroomContentConfig:model]) {
        return YES;
    }
    return [super shouldShowNickName:model];
}


- (CGFloat)nickNameMargin:(CSMessageModel *)model
{
    if ([self chatroomContentConfig:model]) {
        NSDictionary *ext = model.message.remoteExt;
        NIMChatroomMemberType type = [ext[@"type"] integerValue];
        switch (type) {
            case NIMChatroomMemberTypeManager:
            case NIMChatroomMemberTypeCreator:
                return 50.f;
            default:
                break;
        }
        return 15.f;
    }
    return [super shouldShowNickName:model];
}


- (NSArray *)customViews:(CSMessageModel *)model
{
   if ([self chatroomContentConfig:model]) {
        NSDictionary *ext = model.message.remoteExt;
        NIMChatroomMemberType type = [ext[@"type"] integerValue];
        NSString *imageName;
        switch (type) {
            case NIMChatroomMemberTypeManager:
                imageName = @"chatroom_role_manager";
                break;
            case NIMChatroomMemberTypeCreator:
                imageName = @"chatroom_role_master";
                break;
            default:
                break;
        }
        UIImageView *imageView;
        if (imageName.length) {
            UIImage *image = [UIImage imageNamed:imageName];
            imageView = [[UIImageView alloc] initWithImage:image];
            CGFloat leftMargin = 15.f;
            CGFloat topMatgin  = 0.f;
            CGRect frame = imageView.frame;
            frame.origin = CGPointMake(leftMargin, topMatgin);
            imageView.frame = frame;
        }
        return imageView ? @[imageView] : nil;
    }
    return [super customViews:model];
}

- (id<CSSessionContentConfig>)chatroomContentConfig:(CSMessageModel *)model
{
    switch (model.message.messageType) {
        case NIMMessageTypeText:
            self.textConfig.message = model.message;
            return self.textConfig;
        case NIMMessageTypeCustom:{
            NIMCustomObject *object = model.message.messageObject;
            if ([object.attachment isKindOfClass:[CSSJanKenPonAttachment class]]) {
                self.customConfig.message = model.message;
                return self.customConfig;
            }
        }
        case NIMMessageTypeNotification:{
            return nil;
        }
        default:
            return self.unkownConfig;
            break;
    }
}




@end
