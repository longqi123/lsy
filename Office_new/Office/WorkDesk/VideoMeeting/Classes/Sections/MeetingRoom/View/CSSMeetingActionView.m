//
//  CSSMeetingActionView.m
//  NIM
//
//  Created by chris on 16/1/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSMeetingActionView.h"
#import "UIView+CSS.h"
#import "UIImage+NTESColor.h"


@interface CSSChatroomSegmentedItem : NSObject

@property (nonatomic, copy) NSString *showName;

@end

@interface CSSMeetingActionView()<CSSPageViewDelegate,CSSPageViewDataSource>

@property (nonatomic, copy)   NSArray<CSSChatroomSegmentedItem *> *segmentedItems;

@end

@implementation CSSMeetingActionView

- (instancetype)initWithDataSource:(id<CSSMeetingActionViewDataSource>)datasource
{
    self = [super init];
    if (self) {
        _datasource = datasource;
        //选择器
        [self addSubview:self.segmentedControl];
        //内容承载
        [self addSubview:self.pageView];
        [self addSubview:self.unreadRedTip];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)reloadData
{
    [self.pageView reloadData];
}


#pragma mark - Action Delegate

- (void)onSegmentControlChanged:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onSegmentControlChanged:)]) {
        [self.delegate onSegmentControlChanged:sender];
    }
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(onTouchActionBackground:)]) {
        [self.delegate onTouchActionBackground:gesture];
    }
}


- (NSInteger)numberOfPages:(CSSPageView *)pageView
{
    return [self.datasource numberOfPages];
}

- (UIView *)pageView:(CSSPageView *)pageView viewInPage: (NSInteger)index
{
    return [self.datasource viewInPage:index];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.segmentedControl.height = self.segmentedControlHeight;
    CGFloat actorsViewHeight     = [self.datasource actorsViewHeight];
    self.segmentedControl.top    = actorsViewHeight;
    CGFloat pageViewHeight       = self.height - actorsViewHeight - self.segmentedControl.height;
    self.pageView.height         = pageViewHeight;
    self.pageView.bottom         = self.height;
    
    self.unreadRedTip.centerY    = self.segmentedControl.top + self.segmentedControl.height * .5f;
    self.unreadRedTip.right      = self.width - 30.f;
}




#pragma mark - Get

#define SegmentDefaultHeight   40.f

- (CGFloat)roomIdLabelBottom
{
    return 10.f;
}

- (CGFloat)roomIdLabelLeft
{
    return 10.f;
}

- (CGFloat)segmentedControlHeight
{
    return SegmentDefaultHeight;
}

- (CSSPageView *)pageView{
    if (!_pageView) {
        _pageView = [[CSSPageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _pageView.dataSource = self;
        _pageView.pageViewDelegate = self;
        _pageView.scrollView.scrollEnabled = NO;
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _pageView;
}

- (CSSChatroomSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[CSSChatroomSegmentedControl alloc] initWithFrame:CGRectMake(-1.f, 0, self.width + 2.f ,0)];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIImage *imageSelected = [[UIImage imageNamed:@"icon_chatroom_seg_bkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
        UIImage *imageNormal   = [[UIImage imageWithColor:[UIColor whiteColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
        for (NSInteger index = 0; index < self.segmentedItems.count; index++) {
            CSSChatroomSegmentedItem *item = self.segmentedItems[index];
            [_segmentedControl insertSegmentWithTitle:item.showName];
            [_segmentedControl setBackgroundImage:imageNormal forState:UIControlStateNormal atIndex:index];
            [_segmentedControl setBackgroundImage:imageNormal forState:UIControlStateHighlighted atIndex:index];
            [_segmentedControl setBackgroundImage:imageSelected forState:UIControlStateSelected atIndex:index];
            [_segmentedControl setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal atIndex:index];
            [_segmentedControl setTitleColor:UIColorFromRGB(0x238efa) forState:UIControlStateSelected atIndex:index];
            [_segmentedControl setFont:[UIFont systemFontOfSize:17.f] atIndex:index];
            _segmentedControl.layer.borderWidth = 1;
            _segmentedControl.layer.borderColor = UIColorFromRGB(0xd7dade).CGColor;

        }
        [_segmentedControl addTarget:self action:@selector(onSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


- (NSArray<CSSChatroomSegmentedItem *> *)segmentedItems{
    if (!_segmentedItems) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSString *showNameKey = @"showName";
        NSArray *vcs = @[
                         @{
                             showNameKey : @"白板"
                             },
                         @{
                             showNameKey : @"讨论"
                             },
                         @{
                             showNameKey : @"成员"
                             },
                         @{
                             showNameKey : @"举手"
                             },

                         ];
        
        NSInteger numberOfPages = [self.datasource numberOfPages];
        
        for (int i = 0; i < numberOfPages; i ++) {
            NSDictionary *dict = vcs[i];
            CSSChatroomSegmentedItem *item = [[CSSChatroomSegmentedItem alloc] init];
            item.showName = dict[showNameKey];
            [items addObject:item];
        }
        _segmentedItems = [NSArray arrayWithArray:items];
    }
    return _segmentedItems;
}

- (UIImageView *)unreadRedTip
{
    if (!_unreadRedTip) {
        _unreadRedTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unread_tip"]];
        [_unreadRedTip sizeToFit];
    }
    return _unreadRedTip;
}

@end


@implementation CSSChatroomSegmentedItem
@end

