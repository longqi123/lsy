//
//  CSSessionNetChatNotifyContentView.m
//  CSKit
//
//  Created by chris on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSessionNetChatNotifyContentView.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSMessageModel.h"
#import "CSKitUtil.h"

@implementation CSSessionNetChatNotifyContentView

-(instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[CSAttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.font = [UIFont systemFontOfSize:14.f];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)refresh:(CSMessageModel *)data{
    [super refresh:data];
    NSString *text = [CSKitUtil formatedMessage:data.message];
    [_textLabel cs_setText:text];
    if (!self.model.message.isOutgoingMsg) {
        _textLabel.textColor = [UIColor blackColor];
    }else{
        _textLabel.textColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentsize = self.model.contentSize;
    CGRect labelFrame = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    self.textLabel.frame = labelFrame;
}


@end
