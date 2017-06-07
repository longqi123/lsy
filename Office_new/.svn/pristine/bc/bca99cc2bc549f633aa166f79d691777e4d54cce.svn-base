//
//  UIScrollView+CSSPullToRefresh.h
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class CSSPullToRefreshView;

@interface UIScrollView (CSSPullToRefresh)

typedef NS_ENUM(NSUInteger, CSSPullToRefreshPosition) {
    CSSPullToRefreshPositionTop = 0,
    CSSPullToRefreshPositionBottom,
};

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(CSSPullToRefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) CSSPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end


typedef NS_ENUM(NSUInteger, CSSPullToRefreshState) {
    CSSPullToRefreshStateStopped = 0,
    CSSPullToRefreshStateTriggered,
    CSSPullToRefreshStateLoading,
    CSSPullToRefreshStateAll = 10
};

@interface CSSPullToRefreshView : UIView

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UIColor *activityIndicatorViewColor;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, readonly) CSSPullToRefreshState state;
@property (nonatomic, readonly) CSSPullToRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(CSSPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(CSSPullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(CSSPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;


@end

