//
//  NTESSessionMsgHelper.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

@class CSSLocationPoint;
@class CSSJanKenPonAttachment;
@class CSSSnapchatAttachment;
@class CSSChartletAttachment;
@class NTESWhiteboardAttachment;
@class CSSMeetingControlAttachment;

@interface CSSSessionMsgConverter : NSObject

+ (NIMMessage *)msgWithText:(NSString*)text;

+ (NIMMessage *)msgWithImage:(UIImage*)image;

+ (NIMMessage *)msgWithAudio:(NSString*)filePath;

+ (NIMMessage *)msgWithVideo:(NSString*)filePath;

+ (NIMMessage *)msgWithLocation:(CSSLocationPoint*)locationPoint;

+ (NIMMessage *)msgWithJenKenPon:(CSSJanKenPonAttachment *)attachment;

+ (NIMMessage *)msgWithSnapchatAttachment:(CSSSnapchatAttachment *)attachment;

+ (NIMMessage *)msgWithChartletAttachment:(CSSChartletAttachment *)attachment;

+ (NIMMessage*)msgWithMeetingControlAttachment:(CSSMeetingControlAttachment *)attachment;

+ (NIMMessage *)msgWithFilePath:(NSString*)path;

+ (NIMMessage *)msgWithFileData:(NSData*)data extension:(NSString*)extension;

+ (NIMMessage *)msgWithTip:(NSString *)tip;

@end
