//
//  NTESChatroomKnowMessageConfig.m
//  NIMEducationDemo
//
//  Created by chris on 16/3/10.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSChatroomUnknowMessageConfig.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSGlobalMacro.h"

@interface CSSChatroomUnknowMessageConfig ()

@property (nonatomic, strong) CSAttributedLabel *label;

@end

@implementation CSSChatroomUnknowMessageConfig

- (CGSize)contentSize:(CGFloat)cellWidth
{
    NSString *text = CSKit_Unknow_Message_Tip;
    [self.label cs_setText:text];
    CGFloat msgBubbleMaxWidth    = (cellWidth - 130);
    CGFloat bubbleLeftToContent  = 15;
    CGFloat contentRightToBubble = 0;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    return [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
}

- (NSString *)cellContent
{
    return @"CSSChatroomUnknowContentView";
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
