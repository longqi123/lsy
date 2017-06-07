//
//  CSInputTextView.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSInputTextView : UITextView

@property (nonatomic, strong) NSString *placeHolder;

- (void)setCustomUI;

@end
