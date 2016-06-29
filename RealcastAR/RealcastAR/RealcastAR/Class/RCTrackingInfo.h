//
//  RCARTrackingInfo.h
//  功能开发
//
//  Created by weily on 16/5/10.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  AR Tracking information
 *  now all the information's type if unkown
 */
@interface RCTrackingInfo : NSObject

@property (nonatomic, strong) id trackingConfiguration;

@property (nonatomic, copy) NSString *trackingImage;

@property (nonatomic, copy) NSString *trackingType;

@property (nonatomic, strong) NSString *mid;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
