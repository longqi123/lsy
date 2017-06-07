//
//  CSMemberGroupView.h
//  CSKit
//
//  Created by chris on 15/10/15.
//  Copyright © 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCardDataSourceProtocol.h"

@protocol CSMemberGroupViewDelegate <NSObject>
@optional

- (void)didSelectMemberId:(NSString *)uid;

- (void)didSelectRemoveButtonWithMemberId:(NSString *)uid;

- (void)didSelectOperator:(CSKitCardHeaderOpeator )opera;

@end

@interface CSMemberGroupView : UIView

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,readonly) BOOL showAddOperator;

@property (nonatomic,readonly) BOOL showRemoveOperator;

@property (nonatomic,assign) BOOL enableRemove;

@property (nonatomic,weak) id<CSMemberGroupViewDelegate> delegate;

- (void)refreshUids:(NSArray *)uids operators:(CSKitCardHeaderOpeator)operators;

- (void)setTitle:(NSString *)title forOperator:(CSKitCardHeaderOpeator)opera;

@end
