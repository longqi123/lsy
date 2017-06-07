//
//  CSSessionViewLayoutManager.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSInputView.h"

@class CSMessageModel;

@interface CSSessionViewLayoutManager : NSObject

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic, weak) id<NIMInputDelegate> delegate;

- (instancetype)initWithInputView:(CSInputView*)inputView tableView:(UITableView*)tableview;

- (void)insertTableViewCellAtRows:(NSArray*)addIndexs animated:(BOOL)animated;

- (void)updateCellAtIndex:(NSInteger)index model:(CSMessageModel *)model;

-(void)deleteCellAtIndexs:(NSArray*)delIndexs;

-(void)reloadDataToIndex:(NSInteger)index
        atScrollPosition:(UITableViewScrollPosition)scrollPosition
           withAnimation:(BOOL)animated;

@end
