//
//  CSSLogManager.h
//  NIM
//
//  Created by Xuhui on 15/4/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//


@interface CSSLogManager : NSObject

+ (instancetype)sharedManager;

- (void)start;

- (UIViewController *)demoLogViewController;

- (UIViewController *)sdkLogViewController;

- (NSString *)currentLogPath;

@end
