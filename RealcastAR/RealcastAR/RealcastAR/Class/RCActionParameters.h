//
//  RCARActionParameters.h
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 此为虚类，请注意子类实现
 *  如果没有子类实现，这个对象实现了一些字典的操作，可以直接作为字典使用
 *  如 action.paramaters["name"] = name....
 */
@interface RCActionParameters : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

- (id)objectForKey:(NSString *)aKey;
- (id)objectForKeyedSubscript:(NSString *)key;

@end

@interface RIVisibilityActionParameters : RCActionParameters

@property (nonatomic, strong) NSString *type;

@end
