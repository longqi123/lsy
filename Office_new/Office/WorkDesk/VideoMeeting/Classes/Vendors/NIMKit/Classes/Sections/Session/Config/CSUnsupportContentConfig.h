//
//  CSUnsupportContentConfig.h
//  CSKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseSessionContentConfig.h"


@interface CSUnsupportContentConfig : CSBaseSessionContentConfig<CSSessionContentConfig>
+ (instancetype)sharedConfig;
@end