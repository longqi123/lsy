//
//  RCARVideoViewController.h
//  RealcastAR
//
//  Created by lsy on 16/5/24.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCARVideoViewController : UIViewController

@property (nonatomic,strong) NSURL *videoUrl;

@property (nonatomic,strong) NSURL *mscUrl;

@property (nonatomic,assign) CGFloat latitude;

@property (nonatomic,assign) CGFloat longitude;

@end
