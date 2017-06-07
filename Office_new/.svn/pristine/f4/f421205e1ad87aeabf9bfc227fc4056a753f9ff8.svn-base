//
//  CSSChatroomTextContentConfig.m
//  NIM
//
//  Created by chris on 16/1/13.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSChatroomTextContentConfig.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSGlobalMacro.h"

@interface CSSChatroomTextContentConfig()

@property (nonatomic, strong) CSAttributedLabel *label;

@end

@implementation CSSChatroomTextContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth
{
    NSString *text = self.message.text;
    [self.label cs_setText:text];
    CGFloat msgBubbleMaxWidth    = (cellWidth - 130);
    CGFloat bubbleLeftToContent  = 15;
    CGFloat contentRightToBubble = 0;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    return [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
}

- (NSString *)cellContent
{
    return @"CSSChatroomTextContentView";
}

- (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(20,15,10,0);
}

- (CSAttributedLabel *)label
{
    if (!_label) {
        _label = [[CSAttributedLabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:Chatroom_Message_Font_Size];
    }
    return _label;
}

@end
