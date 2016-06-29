//
//  RCARInterface.h
//  功能开发
//
//  Created by Ray on 16/5/4.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTransform.h"
#import "RCEvent.h"
#import "RCGestureConfig.h"

//  ar基本类型
typedef NS_ENUM(NSUInteger, RCBaseARElementType) {
    RCBaseARElementTypeImage,
    RCBaseARElementTypeVideo,
    RCBaseARElementTypeModel
};

//  加载类型
typedef NS_ENUM(NSUInteger, RCARLoadType) {
    RCARLoadTypePreloaded,
    RCARLoadTypeDynamicLoading
};

/**
 *  @brief AR元素，如模型、图片等，对应单个ar识别图,下有多个ar事件
 */
@interface RCARElement : NSObject

///	元素类型
@property (nonatomic, assign) RCBaseARElementType baseType;
///	id
@property (nonatomic, copy  ) NSString            *arID;
///	加载类型
@property (nonatomic, assign) RCARLoadType        loadType;
///	ar名称， 如 ARModel1，由后台配置
@property (nonatomic, copy  ) NSString            *name;

///	状态
@property (nonatomic, assign) BOOL      status;
///	不知道干啥的, 取值0 - 100
@property (nonatomic, assign) NSInteger transparency;
///	是否可见
@property (nonatomic, assign) BOOL      visibility;

///	当前变换
@property (nonatomic, strong) RCTransform *rotation;
@property (nonatomic, strong) RCTransform *scale;
@property (nonatomic, strong) RCTransform *translate;

///	手势配置，如：是否支持平移，为转等
@property (nonatomic, strong) RCGestureConfig *gesture;

/// unkown...
@property (nonatomic, strong) id parameters;

/// the ar datas, example: {imageUrl: "the url..."}
@property (nonatomic, strong) NSDictionary *data;

///	事件
@property (nonatomic, strong) NSArray<RCEvent *> *events;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@end
