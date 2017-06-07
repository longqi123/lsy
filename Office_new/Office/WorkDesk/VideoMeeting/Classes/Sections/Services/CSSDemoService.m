//
//  CSSDemoService.m
//  NIM
//
//  Created by amao on 1/20/16.
//  Copyright © 2016 Netease. All rights reserved.
//

#import "CSSDemoService.h"

@implementation CSSDemoService
+ (instancetype)sharedService
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


- (void)registerUser:(CSSRegisterData *)data
          completion:(CSSRegisterHandler)completion
{
    CSSDemoRegisterTask *task = [[CSSDemoRegisterTask alloc] init];
    task.data = data;
    task.handler = completion;
    [self runTask:task];
}

- (void)requestChatRoom:(NSString *)name
             completion:(NTESCreateMeetingHandler)completion
{
    CSSDemoCreateMeetingTask *task = [[CSSDemoCreateMeetingTask alloc] init];
    task.meetingName = name;
    task.handler = completion;
    [self runTask:task];
}

- (void)closeChatRoom:(NSString *)roomId
              creator:(NSString *)creator
           completion:(NTESCloseMeetingHandler)completion
{
    CSSDemoCloseMeetingTask *task = [[CSSDemoCloseMeetingTask alloc] init];
    task.roomId = roomId;
    task.creator = creator;
    task.handler = completion;
    [self runTask:task];
}


- (void)runTask:(id<CSSDemoServiceTask>)task
{
    NSURLRequest *request = [task taskRequest];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               id jsonObject = nil;
                               NSError *error = connectionError;
                               if (connectionError == nil &&
                                   [response isKindOfClass:[NSHTTPURLResponse class]] &&
                                   [(NSHTTPURLResponse *)response statusCode] == 200)
                               {
                                   if (data)
                                   {
                                       jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:0
                                                                                      error:&error];
                                   }
                                   else
                                   {
                                       error = [NSError errorWithDomain:@"ntes domain"
                                                                   code:-1
                                                               userInfo:@{@"description" : @"invalid data"}];
                                   }
                               }
                               [task onGetResponse:jsonObject
                                             error:error];
                               
                           }];
}
@end
