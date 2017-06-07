//
//  NTESInputMoreContainerView.m
//  NIMDemo
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSInputMoreContainerView.h"
#import "CSPageView.h"
#import "CSMediaItem.h"
#import "CSUIConfig.h"
#import "CSDefaultValueMaker.h"
#import "UIView+CS.h"

NSInteger CSMaxItemCountInPage = 8;
NSInteger CSButtonItemWidth = 74;
NSInteger CSButtonItemHeight = 85;
NSInteger CSPageRowCount     = 2;
NSInteger CSPageColumnCount  = 4;
NSInteger CSButtonBegintLeftX = 11;




@interface CSInputMoreContainerView() <CSPageViewDataSource,CSPageViewDelegate>
{
    NSArray                 *_mediaButtons;
    NSArray                 *_mediaItems;
    CSPageView             *_pageView;
}

@end

@implementation CSInputMoreContainerView

- (void)setConfig:(id<CSSessionConfig>)config
{
    _config = config;
    [self genMediaButtons];
}


- (void)genMediaButtons
{
    NSMutableArray *mediaButtons = [NSMutableArray array];
    NSMutableArray *mediaItems = [NSMutableArray array];
    
    if (self.config && [self.config respondsToSelector:@selector(mediaItems)]) {
        NSArray *items = [self.config mediaItems];
        
        [items enumerateObjectsUsingBlock:^(CSMediaItem *item, NSUInteger idx, BOOL *stop) {
            
            BOOL shouldHidden = NO;
            if ([self.config respondsToSelector:@selector(shouldHideItem:)]) {
                shouldHidden = [self.config shouldHideItem:item];
            }
            
            if (!shouldHidden) {
                
                [mediaItems addObject:item];
                
                UIButton *btn = [[UIButton alloc] init];
                [btn setImage:item.normalImage forState:UIControlStateNormal];
                [btn setImage:item.selectedImage forState:UIControlStateHighlighted];
                [btn setTitle:item.title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(76, -72, 0, 0)];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                btn.tag = item.tag;
                [mediaButtons addObject:btn];

            }
        }];
    }
    
    _mediaButtons = mediaButtons;
    _mediaItems = mediaItems;
    
    _pageView = [[CSPageView alloc] initWithFrame:self.bounds];
    _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _pageView.dataSource = self;
    [self addSubview:_pageView];
    [_pageView scrollToPage:0];
}

- (void)setFrame:(CGRect)frame{
    CGFloat originalWidth = self.frame.size.width;
    [super setFrame:frame];
    if (originalWidth != frame.size.width) {
        [_pageView reloadData];
    }
}



- (void)dealloc
{
    _pageView.dataSource = nil;
}


#pragma mark PageViewDataSource
- (NSInteger)numberOfPages: (CSPageView *)pageView
{
    NSInteger count = [_mediaButtons count] / CSMaxItemCountInPage;
    count = ([_mediaButtons count] % CSMaxItemCountInPage == 0) ? count: count + 1;
    return MAX(count, 1);
}

- (UIView*)mediaPageView:(CSPageView*)pageView beginItem:(NSInteger)begin endItem:(NSInteger)end
{
    UIView *subView = [[UIView alloc] init];
    NSInteger span = (self.nim_width - CSPageColumnCount * CSButtonItemWidth) / (CSPageColumnCount +1);
    CGFloat startY          = CSButtonBegintLeftX;
    NSInteger coloumnIndex = 0;
    NSInteger rowIndex = 0;
    NSInteger indexInPage = 0;
    for (NSInteger index = begin; index < end; index ++)
    {
        UIButton *button = [_mediaButtons objectAtIndex:index];
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        //计算位置
        rowIndex    = indexInPage / CSPageColumnCount;
        coloumnIndex= indexInPage % CSPageColumnCount;
        CGFloat x = span + (CSButtonItemWidth + span) * coloumnIndex;
        CGFloat y = 0.0;
        if (rowIndex > 0)
        {
            y = rowIndex * CSButtonItemHeight + startY + 15;
        }
        else
        {
            y = rowIndex * CSButtonItemHeight + startY;
        }
        [button setFrame:CGRectMake(x, y, CSButtonItemWidth, CSButtonItemHeight)];
        [subView addSubview:button];
        indexInPage ++;
    }
    return subView;
}

- (UIView*)oneLineMediaInPageView:(CSPageView *)pageView
                       viewInPage: (NSInteger)index
                            count:(NSInteger)count
{
    UIView *subView = [[UIView alloc] init];
    NSInteger span = (self.nim_width - count * CSButtonItemWidth) / (count +1);
    
    for (NSInteger btnIndex = 0; btnIndex < count; btnIndex ++)
    {
        UIButton *button = [_mediaButtons objectAtIndex:btnIndex];
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        CGRect iconRect = CGRectMake(span + (CSButtonItemWidth + span) * btnIndex, 58, CSButtonItemWidth, CSButtonItemHeight);
        [button setFrame:iconRect];
        [subView addSubview:button];
    }
    return subView;
}

- (UIView *)pageView: (CSPageView *)pageView viewInPage: (NSInteger)index
{
    if ([_mediaButtons count] == 2 || [_mediaButtons count] == 3) //一行显示2个或者3个
    {
        return [self oneLineMediaInPageView:pageView viewInPage:index count:[_mediaButtons count]];
    }
    
    if (index < 0)
    {
        assert(0);
        index = 0;
    }
    NSInteger begin = index * CSMaxItemCountInPage;
    NSInteger end = (index + 1) * CSMaxItemCountInPage;
    if (end > [_mediaButtons count])
    {
        end = [_mediaButtons count];
    }
    return [self mediaPageView:pageView beginItem:begin endItem:end];
}

#pragma mark - button actions
- (void)onTouchButton:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    for (CSMediaItem *item in _mediaItems) {
        if (item.tag == tag) {
            if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onTapMediaItem:)]) {
                [_actionDelegate onTapMediaItem:item];
            }
            break;
        }
    }
}

@end
