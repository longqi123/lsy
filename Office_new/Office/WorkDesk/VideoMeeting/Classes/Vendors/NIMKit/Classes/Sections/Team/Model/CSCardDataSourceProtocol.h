//
//  CSCardDataSourceProtocol.h
//  NIM
//
//  Created by chris on 15/3/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

typedef NS_ENUM(NSInteger, CSKitCardHeaderOpeator){
    CardHeaderOpeatorNone   = 0,
    CardHeaderOpeatorAdd    = (1UL << 0),
    CardHeaderOpeatorRemove = (1UL << 1),
};

typedef NS_ENUM(NSInteger, CSKitTeamCardRowItemType) {
    TeamCardRowItemTypeCommon,
    TeamCardRowItemTypeTeamMember,
    TeamCardRowItemTypeRedButton,
    TeamCardRowItemTypeBlueButton,
    TeamCardRowItemTypeSwitch,
};


@protocol CSKitCardHeaderData <NSObject>

- (UIImage*)imageNormal;

- (NSString*)title;

@optional
- (NSString*)imageUrl;

- (NSString*)memberId;

- (CSKitCardHeaderOpeator)opera;

@end



@protocol NTESCardBodyData <NSObject>

- (NSString*)title;

- (CSKitTeamCardRowItemType)type;

- (CGFloat)rowHeight;

@optional
- (NSString*)subTitle;

- (SEL)action;

- (BOOL)actionDisabled;

- (BOOL)switchOn;

@end
