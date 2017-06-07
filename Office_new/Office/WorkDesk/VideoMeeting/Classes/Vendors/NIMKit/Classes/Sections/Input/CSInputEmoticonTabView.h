//
//  CSInputEmoticonTabView.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSInputEmoticonTabView;

@protocol CSInputEmoticonTabDelegate <NSObject>

- (void)tabView:(CSInputEmoticonTabView *)tabView didSelectTabIndex:(NSInteger) index;

@end

@interface CSInputEmoticonTabView : UIControl

@property (nonatomic,strong) NSArray *emoticonCatalogs;

@property (nonatomic,strong) UIButton * sendButton;

@property (nonatomic,weak)   id<CSInputEmoticonTabDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame catalogs:(NSArray*)emoticonCatalogs;

- (void)selectTabIndex:(NSInteger)index;

@end






