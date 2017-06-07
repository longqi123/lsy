//
//  CSMessageMaker.m
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSMessageMaker.h"
#import "NSString+CS.h"

@implementation CSMessageMaker

+ (NIMMessage*)msgWithText:(NSString*)text
{
    NIMMessage *textMessage = [[NIMMessage alloc] init];
    textMessage.text        = text;
    return textMessage;
}

+ (NIMMessage*)msgWithAudio:(NSString*)filePath
{
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = audioObject;
    message.text = @"发来了一段语音";
    return message;
}

@end
