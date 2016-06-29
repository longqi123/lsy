//
//  RCARLoadDataView.h
//  RealcastAR
//
//  Created by lsy on 16/6/12.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RCARLoadDataViewDelegare <NSObject>

- (void)loadResourcesSuccessful:(NSString *)XMLaddress JSON:(NSString *)JSONaddress model:(NSDictionary *)modelData;

- (void)goBack;

- (void)refreshChanel;

@end
@interface RCARLoadDataView : UIView

@property (nonatomic,copy) NSString *channelID;
@property (nonatomic,weak) id <RCARLoadDataViewDelegare> delegate;

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame chanelID:(NSString *)channelID;

@end
