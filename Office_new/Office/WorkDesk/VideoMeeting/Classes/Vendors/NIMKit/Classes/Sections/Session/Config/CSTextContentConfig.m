//
//  CSTextContentConfig.m
//  CSKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "CSTextContentConfig.h"
#import "CSAttributedLabel+CSKit.h"
@interface CSTextContentConfig()

@property (nonatomic,strong) CSAttributedLabel *label;

@end


@implementation CSTextContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth
{
    NSString *text = self.message.text;
    [self.label cs_setText:text];
    
    CGFloat msgBubbleMaxWidth    = (cellWidth - 130);
    CGFloat bubbleLeftToContent  = 14;
    CGFloat contentRightToBubble = 14;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    return [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
}

- (NSString *)cellContent
{
    return @"CSSessionTextContentView";
}

- (UIEdgeInsets)contentViewInsets
{
    return self.message.isOutgoingMsg ? UIEdgeInsetsMake(11,11,9,15) : UIEdgeInsetsMake(11,15,9,9);
}


- (CSAttributedLabel *)label
{
    if (_label) {
        return _label;
    }
    _label = [[CSAttributedLabel alloc] initWithFrame:CGRectZero];
    _label.font = [UIFont systemFontOfSize:CSKit_Message_Font_Size];
    return _label;
}

@end
