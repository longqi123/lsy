//
//  CSSDemoService.h
//  NIM
//
//  Created by amao on 1/20/16.
//  Copyright © 2016 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSDemoRegisterTask.h"
#import "CSSDemoCreateMeetingTask.h"
#import "CSSDemoCloseMeetingTask.h"


@interface CSSDemoService : NSObject
+ (instancetype)sharedService;

- (void)registerUser:(CSSRegisterData *)data
          completion:(CSSRegisterHandler)completion;


- (void)requestChatRoom:(NSString *)name
             completion:(NTESCreateMeetingHandler)completion;

- (void)closeChatRoom:(NSString *)roomId
              creator:(NSString *)creator
           completion:(NTESCloseMeetingHandler)completion;

@end
