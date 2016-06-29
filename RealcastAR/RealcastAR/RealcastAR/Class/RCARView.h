//
//  RCARView.h
//  RealcastAR
//
//  Created by Steven2761 on 16/6/1.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol arcViewBtnDelegate <NSObject>

- (void)btnclick:(int)tag;

@end

@interface RCARView : UIView

@property(nonatomic,weak)id<arcViewBtnDelegate>tagDelegate;

@end
