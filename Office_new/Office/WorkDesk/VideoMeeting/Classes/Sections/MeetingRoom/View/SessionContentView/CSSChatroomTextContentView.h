//
//  CSSChatroomTextContentView.h
//  NIM
//
//  Created by chris on 16/1/13.
//  Copyright © 2016年 Netease. All rights reserved.
//


#import "CSSessionMessageContentView.h"

@class CSAttributedLabel;

@interface CSSChatroomTextContentView : CSSessionMessageContentView

@property (nonatomic, strong) CSAttributedLabel *textLabel;

@end
