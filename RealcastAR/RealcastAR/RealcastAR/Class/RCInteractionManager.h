//
//  RCARInteractionManager.h
//  tianyanAR
//
//  Created by weily on 16/5/12.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCEvent.h"
#import "RCARElement.h"
#import "RCARProject.h"

@interface RCInteractionManager : NSObject

/**
 *  使用项目配置来初始化交互信息
 *
 *  @param arproject RCARProject Model
 *
 *  @return 
 */
- (instancetype)initWithARProject:(RCARProject *)arproject;

/**
 *  通过trackId和media id来查找对应的ar名称
 *
 *  @param trackID
 *  @param mediaID
 *
 *  @return the AR name
 */
- (NSString *)mediaIDWithTrackID:(NSInteger)trackID mediaIndex:(NSInteger)mediaIndex;

/**
 *  通过ar名称来查找id
 *
 *  @param trackID
 *  @param mediaID
 *  @param name
 */
- (void)getTrackID:(int *)trackID mediaID:(int *)mediaID withName:(NSString *)name;


/**
 *  查找对应事件
 *
 *  @param trackID
 *  @param mediaID
 *
 *  @return id对应的ar的事件
 */
- (NSArray *)eventsWithTrackID:(NSInteger)trackID mediaID:(NSInteger)mediaID;
- (RCEvent *)eventWithTrackID:(NSInteger)trackID mediaID:(NSInteger)mediaID eventType:(RCEventType)eventType;

/**
 *  该识别图下的共有事件，与某个模型无关，仅于识别图相关
 *
 *  @param trackID 识别图id
 *
 *  @return 
 */
- (NSArray *)commonEventsWithTrackID:(NSInteger)trackID;

/**
 *  某识别图下的所有ar
 *
 *  @param trackID 识别图id
 *
 *  @return ars
 */
- (NSArray<RCARElement *> *)ARsWithTrackID:(NSInteger)trackID;

- (RCARElement *)arElementWithTrackID:(NSInteger)trackID modelIndex:(NSInteger)modelIdx;



//  -----   新增便利方法
- (void)trigerEvent:(int)trackid
               type:(RCEventType)type
         withAction:(void (^)(RCAction *action))trigger;
- (void)triggerEvent:(int)trackid
          mediaIndex:(int)mindex
                type:(RCEventType)type
          withAction:(void (^)(RCAction *action))trigger;

@end
