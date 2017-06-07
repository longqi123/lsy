//
//  CSSChatroomTextContentView.m
//  NIM
//
//  Created by chris on 16/1/13.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSChatroomTextContentView.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSMessageModel.h"
#import "CSGlobalMacro.h"
#import <CoreFramework/CoreFramework-umbrella.h>

@interface CSSChatroomTextContentView()<CSAttributedLabelDelegate>

@end

@implementation CSSChatroomTextContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[CSAttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.autoDetectLinks = NO;
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.font = UIFont.H9;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = UIColor.T6;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)refresh:(CSMessageModel *)model{
    [super refresh:model];
    NSString *text = self.model.message.text;
    [_textLabel cs_setText:text];
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

#pragma mark - CSAttributedLabelDelegate
- (void)CSAttributedLabel:(CSAttributedLabel *)label
             clickedOnLink:(id)linkData{
    CSKitEvent *event = [[CSKitEvent alloc] init];
    event.eventName = CSKitEventNameTapLabelLink;
    event.message = self.model.message;
    event.data = linkData;
    [self.delegate onCatchEvent:event];
}


@end
