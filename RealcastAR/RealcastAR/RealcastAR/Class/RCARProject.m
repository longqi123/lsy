//
//  RCARProject.m
//  RealcastAR
//
//  Created by weily on 16/6/7.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import "RCARProject.h"

@implementation RCARProject

- (instancetype)initWithDictionary:(NSDictionary *)areditor
{
    if (self = [super init]) {
        
        NSArray *informations = [RCARScene scenesWithJsonArray:areditor[@"arEditor"]];
        self.arScenes = informations;
    }
    return self;
}

- (RCARScene *)sceneWithID:(int)trackid {
    for (RCARScene *secne in self.arScenes) {
        if (secne.sceneID.intValue == trackid) {
            return secne;
        }
    }
    return nil;
}

- (RCARScene *)sceneWithName:(NSString *)name {
    for (RCARScene *scene in self.arScenes) {
        if ([scene.name isEqualToString:name]) {
            return scene;
        }
    }
    return nil;
}

@end
