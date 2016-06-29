//
//  RCARInfomation.h
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCARElement.h"
#import "RCTrackingInfo.h"

/**
 *  @brief RealCast模板封装
 *  代表编辑器上的一个ar场景，对应一个识别图，下面有多个模型
 *  AR信息
 */
@interface RCARScene : NSObject

/// 该ar场景下的ar
@property (nonatomic, strong)   NSArray<RCARElement *> *arElements;

/// The channel
@property (nonatomic, copy)     NSString *              channel;

///	Is cloud load or not
@property (nonatomic, assign)   BOOL                    cloud;

@property (nonatomic, copy)     NSString *              desc;

///	The name of the ars
@property (nonatomic, copy)     NSString *              name;

///	Status, yes or not.
@property (nonatomic, assign)   BOOL                    status;

///	The tracking infomation.
@property (nonatomic, strong)   RCTrackingInfo *        trackings;

@property (nonatomic, strong) NSNumber *sceneID;


///	Convenient methods
+ (instancetype)sceneWithJson:(NSString *)json;
+ (instancetype)sceneWithDictionary:(NSDictionary *)dict;

///	Initialized the infomation model with a dictionary, usually the dictionary is getted from a json!
- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

+ (NSArray *)scenesWithJsonArray:(NSArray *)jsonArray;

@end
