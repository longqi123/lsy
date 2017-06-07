//
//  NTESInputMoreContainerView.h
//  NIMDemo
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSessionConfig.h"
#import "CSInputProtocol.h"


@interface CSInputMoreContainerView : UIView

@property (nonatomic,weak)  id<CSSessionConfig> config;
@property (nonatomic,weak)  id<CSInputActionDelegate> actionDelegate;

@end
