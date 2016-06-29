//
//  RCARInteractionManager.m
//  tianyanAR
//
//  Created by weily on 16/5/12.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import "RCInteractionManager.h"
//#import "DDXML.h"
#import "RCARPath.h"
#import "RCARScene.h"

@interface RCInteractionManager ()

@property (nonatomic, strong) RCARProject *arProject;
@property (nonatomic, strong) NSArray *arScenes;
@property (nonatomic, strong) NSDictionary *arNameToPathMapping;

@end

@implementation RCInteractionManager


- (instancetype)initWithARProject:(RCARProject *)arproject
{
    if (self = [super init]) {
        
        self.arProject = arproject;
        self.arScenes = arproject.arScenes;
        
        ///	添加由ar name 到 path的映射
        NSMutableDictionary *arMapping = [NSMutableDictionary dictionary];
        for (int i = 0; i < self.arScenes.count; i++) {
            RCARScene *scene = self.arScenes[i];
            
            for (int j = 0; j < scene.arElements.count; j++) {
                RCARElement *ar = scene.arElements[j];
                
                RCARPath *path = [[RCARPath alloc] init];
                path.trackID = i;
                path.mediaIndex = j;
                [arMapping setObject:path forKey:ar.name];
            }
        }
        self.arNameToPathMapping = [arMapping copy];
    }
    return self;
}

- (NSString *)mediaIDWithTrackID:(NSInteger)trackID mediaIndex:(NSInteger)mediaIndex
{
    if (trackID < self.arScenes.count) {
        RCARScene *scene = self.arScenes[trackID];
        if (mediaIndex < scene.arElements.count) {
            return [scene.arElements[mediaIndex] name];
        }
    }
    return nil;
}

- (void)getTrackID:(int *)trackID mediaID:(int *)mediaID withName:(NSString *)name
{
    RCARPath *path = self.arNameToPathMapping[name];
    if (path) {
        *trackID = path.trackID;
        *mediaID = path.mediaIndex;
    }
}

- (RCARElement *)ARWithTrackID:(NSInteger)trackID mediaID:(NSInteger)mediaID
{
    if (trackID < self.arScenes.count) {
        RCARScene *channel = self.arScenes[trackID];
        if (mediaID < channel.arElements.count) {
            return channel.arElements[mediaID];
        }
    }
    return nil;
}


- (NSArray *)eventsWithTrackID:(NSInteger)trackID mediaID:(NSInteger)mediaID
{
    RCARElement *ar = [self ARWithTrackID:trackID mediaID:mediaID];
    if (ar) {
        return ar.events;
    }
    return nil;
}

- (RCEvent *)eventWithTrackID:(NSInteger)trackID mediaID:(NSInteger)mediaID eventType:(RCEventType)eventType
{
    NSArray *events = [self eventsWithTrackID:trackID mediaID:mediaID];
    if (events.count > 0)
    {
        for (RCEvent *event in events)
        {
            if (event.eventType == eventType)
            {
                return event;
            }
        }
    }
    return nil;
}

- (NSArray *)commonEventsWithTrackID:(NSInteger)trackID
{
    if (trackID < self.arScenes.count) {
        RCARScene *scene = self.arScenes[trackID];
        for (RCARElement *element in scene.arElements) {
            if ([element.name isEqualToString:@"nothing"]) {
                return element.events;
            }
        }
    }
    return nil;
}

- (NSArray<RCARElement *> *)ARsWithTrackID:(NSInteger)trackID
{
    if (trackID < self.arScenes.count)
    {
        return [self.arScenes[trackID] arElements];
    }
    return nil;
}

- (RCARElement *)arElementWithTrackID:(NSInteger)trackID modelIndex:(NSInteger)modelIdx {
    if (trackID < self.arScenes.count) {
        RCARScene *infor = self.arScenes[trackID];
        if (modelIdx < infor.arElements.count) {
            return infor.arElements[modelIdx];
        }
    }
    return nil;
}

- (void)trigerEvent:(int)trackid
               type:(RCEventType)type
         withAction:(void (^)(RCAction *action))trigger {
    NSArray *events = [self commonEventsWithTrackID:trackid];
    for (RCEvent *event in events) {
        if (event.eventType == type) {
            for (RCAction *action in event.actions) {
                if (trigger) {
                    trigger(action);
                }
            }
        }
    }
}

- (void)triggerEvent:(int)trackid
          mediaIndex:(int)mindex
                type:(RCEventType)type
          withAction:(void (^)(RCAction *action))trigger {
    RCEvent *event = [self eventWithTrackID:trackid mediaID:mindex eventType:type];
    for (RCAction *action in event.actions) {
        if (trigger) {
            trigger(action);
        }
    }
}



@end
