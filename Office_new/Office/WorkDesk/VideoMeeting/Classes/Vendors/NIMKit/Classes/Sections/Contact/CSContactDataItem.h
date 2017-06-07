//
//  NTESContactDataItem.h
//  NIM
//
//  Created by chris on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSContactDefines.h"

@class CSUsrInfo;

@interface CSContactDataItem : NSObject<CSContactItemCollection>

@property (nonatomic,copy)   NSString *title;

@property (nonatomic,strong) NSArray  *members;

@end
