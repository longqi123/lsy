//
//  ContactPickedView.h
//  NIM
//
//  Created by ios on 10/23/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSKitInfo;

@protocol CSContactPickedViewDelegate <NSObject>

- (void)removeUser:(NSString *)userId;

@end

@interface CSContactPickedView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<CSContactPickedViewDelegate> delegate;

- (void)removeMemberInfo:(CSKitInfo *)info;

- (void)addMemberInfo:(CSKitInfo *)info;

@end
