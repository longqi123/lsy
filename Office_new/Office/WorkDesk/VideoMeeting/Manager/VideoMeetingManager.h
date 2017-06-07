//
//  VideoMeetingManager.h
//  Office
//
//  Created by roger on 2017/6/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoMeetingManager : NSObject

@property (nonatomic, strong) NSString *initiator;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSArray *meettingPersons;

+ (VideoMeetingManager *)shareInstance;


@end
