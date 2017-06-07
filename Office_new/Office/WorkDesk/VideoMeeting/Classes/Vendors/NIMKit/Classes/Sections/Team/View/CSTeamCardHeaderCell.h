//
//  TeamCardHeaderCell.h
//  NIM
//
//  Created by chris on 15/3/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCardDataSourceProtocol.h"
@class CSAvatarImageView;
@protocol CSTeamCardHeaderCellDelegate;



@interface CSTeamCardHeaderCell : UICollectionViewCell

@property (nonatomic,strong) CSAvatarImageView *imageView;

@property (nonatomic,strong) UIImageView *roleImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *removeBtn;

@property (nonatomic,weak) id<CSTeamCardHeaderCellDelegate>delegate;

@property (nonatomic,readonly) id<CSKitCardHeaderData> data;

- (void)refreshData:(id<CSKitCardHeaderData>)data;

@end


@protocol CSTeamCardHeaderCellDelegate <NSObject>

- (void)cellDidSelected:(CSTeamCardHeaderCell*)cell;


@optional
- (void)cellShouldBeRemoved:(CSTeamCardHeaderCell*)cell;

@end
