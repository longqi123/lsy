//
//  CSSPageView.h
//  NIM
//
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSSPageView;

@protocol CSSPageViewDataSource <NSObject>
- (NSInteger)numberOfPages: (CSSPageView *)pageView;
- (UIView *)pageView: (CSSPageView *)pageView viewInPage: (NSInteger)index;

@end

@protocol CSSPageViewDelegate <NSObject>
@optional
- (void)pageViewScrollEnd: (CSSPageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages;

- (void)pageViewDidScroll: (CSSPageView *)pageView;
- (BOOL)needScrollAnimation;
@end


@interface CSSPageView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)    UIScrollView   *scrollView;
@property (nonatomic,weak)    id<CSSPageViewDataSource>  dataSource;
@property (nonatomic,weak)    id<CSSPageViewDelegate>    pageViewDelegate;
- (void)scrollToPage: (NSInteger)pages;
- (void)reloadData;
- (UIView *)viewAtIndex: (NSInteger)index;
- (NSInteger)currentPage;


//旋转相关方法,这两个方法必须配对调用,否则会有问题
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration;
@end
