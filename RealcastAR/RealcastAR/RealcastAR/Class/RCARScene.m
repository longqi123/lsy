//
//  RCARInfomation.m
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "RCARScene.h"
#import "RealcastInteraction.h"

@implementation RCARScene

+ (instancetype)sceneWithJson:(NSString *)json
{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (!err) {
        return [self sceneWithDictionary:jsonDict];
    }
    return nil;
}

+ (instancetype)sceneWithDictionary:(NSDictionary *)dict
{
    RCARScene *info = [[RCARScene alloc] initWithDictionary:dict];
    return info;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
    if (self = [super init]) {
        self.channel = [otherDictionary objectForKey:@"channel"];
        self.cloud = [[otherDictionary objectForKey:@"cloud"] boolValue];
        self.desc = [otherDictionary objectForKey:@"description"];
        self.name = [otherDictionary objectForKey:@"name"];
        self.status = [[otherDictionary objectForKey:@"status"] boolValue];
        
        ///	trackings识别图信息
        NSDictionary *trackingInfo = RC_SAFE_OBJFORKEY(otherDictionary, @"trackings", NSDictionary);
        if (trackingInfo) {
            self.trackings = [[RCTrackingInfo alloc] initWithDictionary:trackingInfo];
        }
        
        //  ar元素
        //  考虑到后台的数据十分多变，这里有验证需要多一点
        NSArray *ardatas = RC_SAFE_OBJFORKEY(otherDictionary, @"ars", NSArray);
        if (ardatas) {
            NSMutableArray *armodels = [[NSMutableArray alloc] init];
            for (NSDictionary *ardata in ardatas) {
                if ([ardata isKindOfClass:[NSDictionary class]]) {
                    RCARElement *ar = [[RCARElement alloc] initWithDictionary:ardata];
                    [armodels addObject:ar];
                }
            }
            self.arElements = (id)armodels;
        }
    }
    return self;
}

+ (NSArray *)scenesWithJsonArray:(NSArray *)jsonArray
{
    NSMutableArray *infos = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [infos addObject:[RCARScene sceneWithDictionary:dict]];
        }
    }
    return infos;
}

@end
