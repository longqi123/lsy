//
//  NIMGlobalMacro.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#ifndef CSKit_GlobalMacro_h
#define CSKit_GlobalMacro_h

#define CSKit_IOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define CSKit_UIScreenWidth   [UIScreen mainScreen].bounds.size.width
#define CSKit_UIScreenHeight  [UIScreen mainScreen].bounds.size.height


#define CSKit_Message_Font_Size   14           // 文字大小
#define CSKit_Notification_Font_Size   10      // 通知中文字大小
#define CSKit_Unknow_Message_Tip   @"未知类型消息"

#define CSKit_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - UIColor宏定义
#define CSKit_UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define CSKit_UIColorFromRGB(rgbValue) CSKit_UIColorFromRGBA(rgbValue, 1.0)

#define CSKit_Dispatch_Sync_Main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define CSKit_Dispatch_Async_Main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#endif
