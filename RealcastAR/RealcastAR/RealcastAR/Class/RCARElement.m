//
//  RCARInterface.m
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCARElement.h"
#import "RealcastInteraction.h"
#import "RCTransform.h"

@implementation RCARElement

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        /// TODO: 属性赋值
        self.name = RC_SAFE_OBJFORKEY(dictionary, @"name", NSString);
        self.arID = RC_SAFE_OBJFORKEY(dictionary, @"id", NSNumber);
        NSString *baseType = [dictionary objectForKey:@"baseType"];
        if ([baseType isEqualToString:@"image"]) {
            self.baseType = RCBaseARElementTypeImage;
        }
        else if ([baseType isEqualToString:@"Video"]) {
            self.baseType = RCBaseARElementTypeVideo;
        }
        else if ([baseType isEqualToString:@"Model"]) {
            self.baseType = RCBaseARElementTypeModel;
        }
//        self.loadType = dictionary objectForKey:@""
        self.status = [[dictionary objectForKey:@"status"] boolValue];
        self.transparency = [[dictionary objectForKey:@"transparency"] integerValue];
        self.visibility = [[dictionary objectForKey:@"view"] boolValue];
        
        /// transformers!
        NSDictionary *rotationData = [dictionary objectForKey:@"rotation"];
        self.rotation = [[RCTransform alloc] initWithDictionary:rotationData];
        NSDictionary *scaleData = [dictionary objectForKey:@"scale"];
        self.scale = [[RCTransform alloc] initWithDictionary:scaleData];
        NSDictionary *translateData = [dictionary objectForKey:@"translate"];
        self.translate = [[RCTransform alloc] initWithDictionary:translateData];
        
        ///	guesture allowed
        NSDictionary *gestureInfo = RC_SAFE_OBJFORKEY(dictionary, @"gesture", NSDictionary);
        self.gesture = [[RCGestureConfig alloc] initWithDictionary:gestureInfo];
        
        /// 这里也是， 后台数据变化比较多，验证多次
        NSArray *eventDatas = [dictionary objectForKey:@"events"];
        if (eventDatas)
        {
            NSMutableArray *events = [[NSMutableArray alloc] init];
            for (NSDictionary *eventData in eventDatas)
            {
                if ([eventData isKindOfClass:[NSDictionary class]])
                {
                    RCEvent *ar = [[RCEvent alloc] initWithDictionary:eventData];
                    [events addObject:ar];
                }
            }
            self.events = (id)events;
        }
    }
    return self;
}

@end
