//
//  RCARPath.h
//  tianyanAR
//
//  Created by weily on 16/5/12.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  ar元素存在于xml中的path
 *  层级关系: 识别图->ar元素
 *
 */

@interface RCARPath : NSObject

///	识别图id/ 序号
@property (nonatomic, assign) int trackID;

///	元素序号/index
@property (nonatomic, assign) int mediaIndex;

///	ar id号
@property (nonatomic, strong) NSString *mediaID;

@end
