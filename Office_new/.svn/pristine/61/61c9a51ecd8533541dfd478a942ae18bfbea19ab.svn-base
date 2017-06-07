//
//  CSKitDataProvider.h
//  CSKit
//
//  Created by amao on 8/13/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIMSession;
@class CSKitInfo;

@protocol CSKitDataProvider <NSObject>

@optional

- (CSKitInfo *)infoByUser:(NSString *)userId
                 inSession:(NIMSession *)session;

- (CSKitInfo *)infoByTeam:(NSString *)teamId;

- (CSKitInfo *)infoByUser:(NSString *)userId
               withMessage:(NIMMessage *)message;


@end
