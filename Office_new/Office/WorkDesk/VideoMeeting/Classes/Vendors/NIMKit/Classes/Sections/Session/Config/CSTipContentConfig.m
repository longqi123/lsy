//
//  CSTipContentConfig.m
//  CSKit
//
//  Created by chris on 16/1/21.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "CSTipContentConfig.h"
#import "CSKitUtil.h"
#import "CSDefaultValueMaker.h"

@implementation CSTipContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth
{
    CGFloat TeamNotificationMessageWidth  = cellWidth;
    UILabel *label = [[UILabel alloc] init];
    label.text  = [CSKitUtil formatedMessage:self.message];
    label.font = [UIFont boldSystemFontOfSize:CSKit_Notification_Font_Size];
    label.numberOfLines = 0;
    CGFloat padding = [CSDefaultValueMaker sharedMaker].maxNotificationTipPadding;
    CGSize size = [label sizeThatFits:CGSizeMake(cellWidth - 2 * padding, CGFLOAT_MAX)];
    CGFloat cellPadding = 11.f;
    CGSize contentSize = CGSizeMake(TeamNotificationMessageWidth, size.height + 2 * cellPadding);;
    return contentSize;
}


- (NSString *)cellContent
{
    return @"CSSessionNotificationContentView";
}


- (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsZero;
}

@end
