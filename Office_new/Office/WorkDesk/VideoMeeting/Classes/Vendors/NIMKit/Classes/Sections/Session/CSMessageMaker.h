//
//  CSMessageMaker.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@interface CSMessageMaker : NSObject

+ (NIMMessage*)msgWithText:(NSString*)text;

+ (NIMMessage*)msgWithAudio:(NSString*)filePath;

@end
