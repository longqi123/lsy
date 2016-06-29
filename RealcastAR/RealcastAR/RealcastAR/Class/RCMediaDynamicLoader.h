//
//  RCMediaDynamicLoader.h
//  RealcastAR
//
//  Created by weily on 16/6/7.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <realmaxARSDK/RXSDKInterface.h>
#import "RCARProject.h"

typedef void (^DatasetLoadCallback) (Dataset *dataset);

/**
 *  动态加载器
 */
@interface RCMediaDynamicLoader : NSObject

/// 使用json提供的ar数据创建loader
+ (instancetype)dynamicLoaderForProject:(RCARProject *)project;

/**
 *  加载动态加载数据
 *
 *  @param modelInfos   {"trackableId1":[{"mediaId1":"mediaurl"},{"mediaid2":"mediaurl2"}]}
 */
- (void)addDynamciLoadInfos:(NSDictionary *)modelInfos;


- (void)loadDatasetWithID:(int)trackId callback:(DatasetLoadCallback)callback;

- (BOOL)trackableIsDynamicLoad:(int)trackid;

@end
