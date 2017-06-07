//
//  CSDefaultValueMaker.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSCellConfig.h"
#import "CSCellLayoutDefaultConfig.h"
@interface CSDefaultValueMaker : NSObject

@property (nonatomic,readonly) CSCellLayoutDefaultConfig *cellLayoutDefaultConfig;

+ (instancetype)sharedMaker;

- (CGFloat)maxNotificationTipPadding;

@end
