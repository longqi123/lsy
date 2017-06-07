//
//  CSPageView.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSPageView;

@protocol CSPageViewDataSource <NSObject>
- (NSInteger)numberOfPages: (CSPageView *)pageView;
- (UIView *)pageView: (CSPageView *)pageView viewInPage: (NSInteger)index;
@end

@protocol CSPageViewDelegate <NSObject>
@optional
- (void)pageViewScrollEnd: (CSPageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages;

- (void)pageViewDidScroll: (CSPageView *)pageView;
- (BOOL)needScrollAnimation;
@end


@interface CSPageView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)    UIScrollView   *scrollView;
@property (nonatomic,weak)    id<CSPageViewDataSource>  dataSource;
@property (nonatomic,weak)    id<CSPageViewDelegate>    pageViewDelegate;
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
