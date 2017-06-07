//
//  CSSDemoCloseMeetingTask.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/22.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSDemoServiceTask.h"

typedef void (^NTESCloseMeetingHandler)(NSError *error, NSString *roomId);

@interface CSSDemoCloseMeetingTask : NSObject<CSSDemoServiceTask>

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *creator;

@property (nonatomic,copy) NTESCloseMeetingHandler handler;

@end
