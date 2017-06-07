//
//  CSDefaultValueMaker.m
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSDefaultValueMaker.h"
#import "CSAttributedLabel+CSKit.h"
#import "CSKitUtil.h"
#import "UIImage+CS.h"

@implementation CSDefaultValueMaker

+ (instancetype)sharedMaker{
    static CSDefaultValueMaker *maker;
    if (!maker) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            maker = [[CSDefaultValueMaker alloc] init];
        });
    }
    return maker;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _cellLayoutDefaultConfig = [[CSCellLayoutDefaultConfig alloc] init];
    }
    return self;
}

- (CGFloat)maxNotificationTipPadding{
    return 20.f;
}


@end
