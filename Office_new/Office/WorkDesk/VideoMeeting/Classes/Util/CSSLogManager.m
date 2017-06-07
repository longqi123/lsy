//
//  CSSLogManager.m
//  NIM
//
//  Created by Xuhui on 15/4/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSLogManager.h"
#import "CSSLogViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "CSSBundleSetting.h"

@interface CSSLogManager () {
    DDFileLogger *_fileLogger;
}

@end

@implementation CSSLogManager

+ (instancetype)sharedManager
{
    static CSSLogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSSLogManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagDebug];
        _fileLogger = [[DDFileLogger alloc] init];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
    }
    return self;
}

- (void)start
{
    DDLogInfo(@"App Started SDK Version %@\nBundle Setting: %@",[[NIMSDK sharedSDK] sdkVersion],[CSSBundleSetting sharedConfig]);
}

- (UIViewController *)demoLogViewController {
    NSString *filepath = _fileLogger.currentLogFileInfo.filePath;
    CSSLogViewController *vc = [[CSSLogViewController alloc] initWithFilepath:filepath];
    vc.title = @"Demo Log";
    return vc;
}

- (UIViewController *)sdkLogViewController
{
    NSString *filepath = [[NIMSDK sharedSDK] currentLogFilepath];
    CSSLogViewController *vc = [[CSSLogViewController alloc] initWithFilepath:filepath];
    vc.title = @"SDK Log";
    return vc;
}

- (NSString *)currentLogPath
{
    return _fileLogger.currentLogFileInfo.filePath;
}

@end
