//
//  VideoMeetingManager.m
//  Office
//
//  Created by roger on 2017/6/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "VideoMeetingManager.h"

@implementation VideoMeetingManager

static VideoMeetingManager *instance;

+ (VideoMeetingManager *)shareInstance
{
    if (!instance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[VideoMeetingManager alloc]init];
        });
    }
    return instance;
}


@end
