//
//  RCMediaDynamicLoader.m
//  RealcastAR
//
//  Created by weily on 16/6/7.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import "RCMediaDynamicLoader.h"

@interface RCMediaDynamicLoader ()

@property (nonatomic, strong) RCARProject *arProject;

@property (nonatomic, strong) NSDictionary *modelData;

@end

@implementation RCMediaDynamicLoader {
    NSDictionary *_modelData;
}

+ (instancetype)dynamicLoaderForProject:(RCARProject *)project {
    RCMediaDynamicLoader *loader = [[RCMediaDynamicLoader alloc] init];
    loader.arProject = project;
    return loader;
}

- (void)addDynamciLoadInfos:(NSDictionary *)modelInfos {
    self.modelData = modelInfos;
}

- (void)loadDatasetWithID:(int)trackId callback:(DatasetLoadCallback)callback {
    
    RCARScene *scene = [self.arProject sceneWithID:trackId];
    
    Dataset *dataset = [[Dataset alloc] init];
    dataset.trackableID = trackId;
    dataset.mediaCount = (int)scene.arElements.count;
    dataset.stability = 0.9;
    NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
    
    for (RCARElement *arelement in scene.arElements)
    {
        MediaData *media1 = [[MediaData alloc] init];
        media1.mediaName = @"media/RMX/owl/BarnOwl_land.rmx";
        media1.mediaStringID = arelement.name;
        media1.type = 0;
        media1.visibility = arelement.visibility;
        media1.lighting = 1;
        
        translate t;
        t.x = arelement.translate.x;
        t.y = arelement.translate.y;
        t.z = arelement.translate.z;
        media1.m_translate = t;
        
        scale s;
        s.x = arelement.scale.x;
        s.y = arelement.scale.y;
        s.z = arelement.scale.z;
        media1.m_scale = s;
        
        rotate_euler r;
        r.heading = arelement.rotation.x;
        r.attitude = arelement.rotation.y;
        r.bank = arelement.rotation.z;
        media1.m_rotate_e = r;
        
        [mediaArray addObject:media1];
    }
    
    dataset.mediaDataArray = mediaArray;
    
    if (callback) {
        callback(dataset);
    }
}

- (BOOL)trackableIsDynamicLoad:(int)trackid
{
    RCARScene *scene = [_arProject sceneWithID:trackid];
    for (RCARElement *element in scene.arElements) {
        
        if (element.loadType == RCARLoadTypeDynamicLoading) {
            return YES;
        }
    }
    
    return NO;
}




@end
