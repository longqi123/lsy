//
//  CSSessionViewLayoutManager.m
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSSessionViewLayoutManager.h"
#import "UIView+CS.h"
#import "UITableView+CSScrollToBottom.h"
#import "CSMessageCellProtocol.h"
#import "CSMessageModel.h"
#import "CSMessageCell.h"

@interface CSSessionViewLayoutManager()<NIMInputDelegate>

@property (nonatomic,weak) CSInputView *inputView;

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSIndexPath *scrollToIndexPath;

@end

@implementation CSSessionViewLayoutManager


-(instancetype)initWithInputView:(CSInputView*)inputView tableView:(UITableView*)tableview
{
    if (self = [self init]) {
        _inputView = inputView;
        _inputView.inputDelegate = self;
        _tableView = tableview;
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _tableView.nim_height -= _inputView.nim_height;
    }
    return self;
}

- (void)dealloc
{
    _inputView.inputDelegate = nil;
}

- (void)insertTableViewCellAtRows:(NSArray*)addIndexs animated:(BOOL)animated
{
    if (!addIndexs.count) {
        return;
    }
    NSMutableArray *addIndexPathes = [NSMutableArray array];
    [addIndexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [addIndexPathes addObject:[NSIndexPath indexPathForRow:[obj integerValue] inSection:0]];
    }];
    [_tableView insertRowsAtIndexPaths:addIndexPathes withRowAnimation:UITableViewRowAnimationFade];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView scrollToRowAtIndexPath:[addIndexPathes lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    });
}

- (void)checkScroll
{
    if (self.scrollToIndexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView scrollToRowAtIndexPath:self.scrollToIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            self.scrollToIndexPath = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkScroll];
            });
        });
    }
}

- (void)updateCellAtIndex:(NSInteger)index model:(CSMessageModel *)model
{
    if (index > -1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

        CSMessageCell *cell = (CSMessageCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [cell refreshData:model];
    }
}

-(void)deleteCellAtIndexs:(NSArray*)delIndexs
{
    if (!delIndexs.count) {
        return;
    }
    NSMutableArray *delIndexPathes = [NSMutableArray array];
    [delIndexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [delIndexPathes addObject:[NSIndexPath indexPathForRow:[obj integerValue] inSection:0]];
    }];
    [_tableView deleteRowsAtIndexPaths:delIndexPathes withRowAnimation:UITableViewRowAnimationNone];
}

-(void)reloadDataToIndex:(NSInteger)index
        atScrollPosition:(UITableViewScrollPosition)scrollPosition
           withAnimation:(BOOL)animated
{
    [_tableView reloadData];
    if (index > 0) {
        NSTimeInterval scrollDelay = .01f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(scrollDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:scrollPosition animated:YES];
        });
    }
}

#pragma mark - NTESInputViewDelegate
//更改tableview布局
- (void)showInputView
{
    if ([self.delegate respondsToSelector:@selector(showInputView)]) {
        [self.delegate showInputView];
    }
    [_tableView setUserInteractionEnabled:NO];
}

- (void)hideInputView
{
    if ([self.delegate respondsToSelector:@selector(hideInputView)]) {
        [self.delegate hideInputView];
    }
    [_tableView setUserInteractionEnabled:YES];
}

- (void)inputViewSizeToHeight:(CGFloat)toHeight showInputView:(BOOL)show
{
    [_tableView setUserInteractionEnabled:!show];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = [_tableView frame];
        rect.origin.y = 0;
        rect.size.height = self.viewRect.size.height - toHeight;
        [_tableView setFrame:rect];
        [_tableView cs_scrollToBottom:NO];
    }];
}

@end
