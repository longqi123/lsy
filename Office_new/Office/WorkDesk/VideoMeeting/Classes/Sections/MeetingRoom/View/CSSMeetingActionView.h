//
//  CSSMeetingActionView.h
//  NIM
//
//  Created by chris on 16/1/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSChatroomSegmentedControl.h"
#import "CSSPageView.h"

@protocol CSSMeetingActionViewDataSource <NSObject>

@required
- (NSInteger)numberOfPages;

- (UIView *)viewInPage:(NSInteger)index;

- (CGFloat)actorsViewHeight;


@end


@protocol CSSMeetingActionViewDelegate <NSObject>

@optional

- (void)onSegmentControlChanged:(CSSChatroomSegmentedControl *)control;

- (void)onTouchActionBackground:(UITapGestureRecognizer *)gesture;

@end

@interface CSSMeetingActionView : UIView

@property (nonatomic, strong) CSSPageView *pageView;

@property (nonatomic, strong) CSSChatroomSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIImageView *unreadRedTip;

@property (nonatomic,weak) id<CSSMeetingActionViewDataSource> datasource;

@property (nonatomic,weak) id<CSSMeetingActionViewDelegate> delegate;

- (instancetype)initWithDataSource:(id<CSSMeetingActionViewDataSource>) datasource;

- (void)reloadData;

@end
