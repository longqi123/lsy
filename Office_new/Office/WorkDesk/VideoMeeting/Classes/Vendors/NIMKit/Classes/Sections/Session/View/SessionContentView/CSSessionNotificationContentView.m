//
//  CSSessionNotificationContentView.m
//  CSKit
//
//  Created by chris on 15/3/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSessionNotificationContentView.h"
#import "CSMessageModel.h"
#import "UIView+CS.h"
#import "CSKitUtil.h"
#import "CSDefaultValueMaker.h"
#import "UIImage+CS.h"

@implementation CSSessionNotificationContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont boldSystemFontOfSize:CSKit_Notification_Font_Size];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
        [self addSubview:_label];
        self.bubbleType = CSKitBubbleTypeNotify;
    }
    return self;
}

- (void)refresh:(CSMessageModel *)model{
    [super refresh:model];
    id<CSCellLayoutConfig> config = model.layoutConfig;
    if ([config respondsToSelector:@selector(formatedMessage:)]) {
        _label.text = [model.layoutConfig formatedMessage:model];;
        [_label sizeToFit];
    }
}

- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing{
    return [[UIImage cs_imageInKit:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8,20,8,20) resizingMode:UIImageResizingModeStretch];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat padding = [CSDefaultValueMaker sharedMaker].maxNotificationTipPadding;
    self.label.nim_size = [self.label sizeThatFits:CGSizeMake(self.nim_width - 2 * padding, CGFLOAT_MAX)];
    self.label.nim_left = 20;
//    self.label.nim_centerX = self.nim_width * .5f;
    self.label.nim_centerY = self.nim_height * .5f;
    self.bubbleImageView.frame = CGRectInset(self.label.frame, -8, -4);
}


@end