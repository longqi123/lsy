//
//  CSInputEmoticonContainerView.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSPageView.h"
#import "CSSessionConfig.h"

@class CSInputEmoticonCatalog;
@class CSInputEmoticonTabView;

@protocol CSInputEmoticonProtocol <NSObject>

- (void)didPressSend:(id)sender;

- (void)selectedEmoticon:(NSString*)emoticonID catalog:(NSString*)emotCatalogID description:(NSString *)description;

@end


@interface CSInputEmoticonContainerView : UIView<CSPageViewDataSource,CSPageViewDelegate>

@property (nonatomic, strong)  CSPageView *emoticonPageView;
@property (nonatomic, strong)  UIPageControl  *emotPageController;
@property (nonatomic, strong)  CSInputEmoticonCatalog    *currentCatalogData;
@property (nonatomic, readonly)CSInputEmoticonCatalog    *nextCatalogData;
@property (nonatomic, readonly)NSArray            *allEmoticons;
@property (nonatomic, strong)  CSInputEmoticonTabView   *tabView;
@property (nonatomic, weak)    id<CSInputEmoticonProtocol>  delegate;
@property (nonatomic, weak)    id<CSSessionConfig> config;

@end

