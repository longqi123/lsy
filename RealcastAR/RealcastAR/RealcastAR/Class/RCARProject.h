//
//  RCARProject.h
//  RealcastAR
//
//  Created by weily on 16/6/7.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCARScene.h"
#import "RCARElement.h"

@interface RCARProject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)areditor;

@property (nonatomic, strong) NSArray<RCARScene *> *arScenes;

- (RCARScene *)sceneWithID:(int)trackid;
- (RCARScene *)sceneWithName:(NSString *)name;

@end
