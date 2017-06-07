//
//  CSSDemoRegisterTask.h
//  NIM
//
//  Created by amao on 1/20/16.
//  Copyright © 2016 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSDemoServiceTask.h"

typedef void(^CSSRegisterHandler)(NSError *error,NSString *errorMsg);

@interface CSSRegisterData : NSObject
@property (nonatomic,copy)      NSString    *account;

@property (nonatomic,copy)      NSString    *token;

@property (nonatomic,copy)      NSString    *nickname;
@end

@interface CSSDemoRegisterTask : NSObject<CSSDemoServiceTask>
@property (nonatomic,strong)    CSSRegisterData        *data;
@property (nonatomic,copy)      CSSRegisterHandler     handler;
@end
