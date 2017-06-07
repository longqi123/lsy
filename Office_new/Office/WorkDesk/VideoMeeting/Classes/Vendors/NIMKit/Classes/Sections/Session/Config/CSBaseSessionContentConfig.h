//
//  CSBaseSessionContentConfig.h
//  CSKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "CSGlobalMacro.h"

@protocol CSSessionContentConfig <NSObject>
- (CGSize)contentSize:(CGFloat)cellWidth;

- (NSString *)cellContent;

- (UIEdgeInsets)contentViewInsets;

@end

@interface CSBaseSessionContentConfig : NSObject
@property (nonatomic,strong)    NIMMessage  *message;
@end


@interface CSSessionContentConfigFactory : NSObject
+ (instancetype)sharedFacotry;
- (id<CSSessionContentConfig>)configBy:(NIMMessage *)message;
@end
