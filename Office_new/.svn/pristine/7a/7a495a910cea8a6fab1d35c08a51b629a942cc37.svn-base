//
//  CSBaseSessionContentConfig.m
//  CSKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "CSBaseSessionContentConfig.h"
#import "CSTextContentConfig.h"
#import "CSImageContentConfig.h"
#import "CSAudioContentConfig.h"
#import "CSVideoContentConfig.h"
#import "CSFileContentConfig.h"
#import "CSNotificationContentConfig.h"
#import "CSLocationContentConfig.h"
#import "CSUnsupportContentConfig.h"
#import "CSTipContentConfig.h"

@implementation CSBaseSessionContentConfig
@end


@interface CSSessionContentConfigFactory ()
@property (nonatomic,strong)    NSDictionary                *dict;
@end

@implementation CSSessionContentConfigFactory

+ (instancetype)sharedFacotry
{
    static CSSessionContentConfigFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSSessionContentConfigFactory alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _dict = @{@(NIMMessageTypeText)         :       [CSTextContentConfig new],
                  @(NIMMessageTypeImage)        :       [CSImageContentConfig new],
                  @(NIMMessageTypeAudio)        :       [CSAudioContentConfig new],
                  @(NIMMessageTypeVideo)        :       [CSVideoContentConfig new],
                  @(NIMMessageTypeFile)         :       [CSFileContentConfig new],
                  @(NIMMessageTypeLocation)     :       [CSLocationContentConfig new],
                  @(NIMMessageTypeNotification) :       [CSNotificationContentConfig new],
                  @(NIMMessageTypeTip)          :       [CSTipContentConfig new]};
    }
    return self;
}

- (id<CSSessionContentConfig>)configBy:(NIMMessage *)message
{
    NIMMessageType type = message.messageType;
    id<CSSessionContentConfig>config = [_dict objectForKey:@(type)];
    if (config == nil)
    {
        config = [CSUnsupportContentConfig sharedConfig];
    }
    if ([config isKindOfClass:[CSBaseSessionContentConfig class]])
    {
        [(CSBaseSessionContentConfig *)config setMessage:message];
    }
    return config;
}

@end
