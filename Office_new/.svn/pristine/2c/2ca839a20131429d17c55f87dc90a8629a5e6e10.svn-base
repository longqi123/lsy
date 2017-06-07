//
//  CSSChatroomUnknowContentView.m
//  NIMEducationDemo
//
//  Created by chris on 16/3/10.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSChatroomUnknowContentView.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSMessageModel.h"
#import "CSGlobalMacro.h"

@implementation CSSChatroomUnknowContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[CSAttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.autoDetectLinks = NO;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.font = [UIFont systemFontOfSize:Chatroom_Message_Font_Size];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)refresh:(CSMessageModel *)model{
    [super refresh:model];
    [_textLabel cs_setText:CSKit_Unknow_Message_Tip];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentsize         = self.model.contentSize;
    CGRect labelFrame = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    self.textLabel.frame = labelFrame;
}


- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing{
    return nil;
}



@end
