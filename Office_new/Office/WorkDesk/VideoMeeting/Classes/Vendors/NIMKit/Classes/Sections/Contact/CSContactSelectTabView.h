//
//  CSContactSelectTabView.h
//  CSKit
//
//  Created by chris on 15/9/15.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSContactPickedView;

@interface CSContactSelectTabView : UIView

@property (nonatomic,strong) CSContactPickedView *pickedView;

@property (nonatomic,strong) UIButton *doneButton;

@end
