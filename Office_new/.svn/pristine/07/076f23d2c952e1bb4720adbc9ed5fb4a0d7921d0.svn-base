//
//  CSSDemoCreateMeetingTask.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/12.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSDemoServiceTask.h"

typedef void (^NTESCreateMeetingHandler)(NSError *error, NSString *meetingRoomID);

@interface CSSDemoCreateMeetingTask : NSObject<CSSDemoServiceTask>

@property (nonatomic,copy) NSString *meetingName;

@property (nonatomic,copy) NTESCreateMeetingHandler handler;

@end
