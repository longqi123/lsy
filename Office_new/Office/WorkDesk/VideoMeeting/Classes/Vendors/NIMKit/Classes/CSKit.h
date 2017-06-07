//
//  CSKit.h
//  CSKit
//
//  Created by amao on 8/14/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>


//! Project version number for CSKit.
FOUNDATION_EXPORT double CSKitVersionNumber;

//! Project version string for CSKit.
FOUNDATION_EXPORT const unsigned char CSKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CSKit/PublicHeader.h>


#import <NIMSDK/NIMSDK.h>

/**
 *  基础Model
 */
#import "CSMediaItem.h"            //多媒体面板对象
#import "CSMessageModel.h"         //message Wrapper


/**
 *  协议
 */
#import "CSKitMessageProvider.h"
#import "CSCellConfig.h"           //message cell配置协议
#import "CSInputProtocol.h"        //输入框回调
#import "CSKitDataProvider.h"      //APP内容提供器
#import "CSMessageCellProtocol.h"  //message cell事件回调
#import "CSSessionConfig.h"        //会话页面配置
#import "CSKitEvent.h"             //点击事件封装类

/**
 *  消息cell的视觉模板
 */
#import "CSSessionMessageContentView.h"

/**
 *  会话页
 */
#import "CSSessionViewController.h"

/**
 *  会话列表页
 */
#import "CSSessionListViewController.h"


@class CSKitInfo;

@interface CSKit : NSObject

+ (instancetype)sharedKit;

/**
 *  内容提供者，由上层开发者注入。
 */
@property (nonatomic,strong)    id<CSKitDataProvider> provider;


/**
 *  CSKit资源所在的bundle名称。
 */
@property (nonatomic,copy)      NSString *bundleName;


/**
 *  用户信息变更通知接口
 *
 *  @param userId 用户id
 */
- (void)notfiyUserInfoChanged:(NSArray *)userIds;

/**
 *  群信息变更通知接口
 *
 *  @param teamId 群id
 */
- (void)notfiyTeamInfoChanged:(NSArray *)teamIds;

@end

@interface CSKit(Private)
- (CSKitInfo *)infoByUser:(NSString *)userId;

- (CSKitInfo *)infoByUser:(NSString *)userId
                 inSession:(NIMSession *)session;

- (CSKitInfo *)infoByTeam:(NSString *)teamId;

- (CSKitInfo *)infoByUser:(NSString *)userId
               withMessage:(NIMMessage *)message;

@end



@interface CSKitInfo : NSObject
/**
 *   id,如果是用户信息，为用户id；如果是群信息，为群id
 */
@property (nonatomic,copy) NSString *infoId;

/**
 *  显示名
 */
@property (nonatomic,copy)   NSString *showName;


//如果avatarUrlString为nil，则显示头像图片
//如果avatarUrlString不为nil,则将头像图片当做占位图，当下载完成后显示头像url指定的图片。

/**
 *  头像url
 */
@property (nonatomic,copy)   NSString *avatarUrlString;

/**
 *  头像图片
 */
@property (nonatomic,strong) UIImage  *avatarImage;

@end

extern NSString *const CSKitUserInfoHasUpdatedNotification;
extern NSString *const CSKitTeamInfoHasUpdatedNotification;
extern NSString *const CSKitChatroomMemberInfoHasUpdatedNotification;

extern NSString *const CSKitInfoKey;
extern NSString *const CSKitChatroomMembersKey;
