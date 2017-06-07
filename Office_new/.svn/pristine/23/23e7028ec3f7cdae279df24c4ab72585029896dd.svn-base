//
//  CSSessionTextContentView.m
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSessionTextContentView.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSMessageModel.h"
#import "CSGlobalMacro.h"

//NSString *const NIMTextMessageLabelLinkData = @"NIMTextMessageLabelLinkData";

@interface CSSessionTextContentView()<CSAttributedLabelDelegate>

@end

@implementation CSSessionTextContentView

-(instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[CSAttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.font = [UIFont systemFontOfSize:CSKit_Message_Font_Size];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)refresh:(CSMessageModel *)data{
    [super refresh:data];
    NSString *text = self.model.message.text;
    [_textLabel cs_setText:text];
    if (!self.model.message.isOutgoingMsg) {
        self.textLabel.textColor = [UIColor blackColor];
    }else{
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentsize         = self.model.contentSize;
    CGRect labelFrame = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    self.textLabel.frame = labelFrame;
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
