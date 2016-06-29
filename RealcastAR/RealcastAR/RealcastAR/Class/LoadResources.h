//
//  LoadResources.h
//  tianyanAR
//
//  Created by Steven2761 on 16/5/11.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadResourcesDelegare <NSObject>

//下载成功
// {@"trackableId": [{@"mediaid": @"url"}, {@"mediaid2":@"url"}]}
//  
- (void)downloadResourcesSuccessful:(NSString *)XMLaddress JSON:(NSString *)JSONaddress model:(NSDictionary *)modelData;
//下载失败
- (void)downloadResourcesFailure:(NSString *)errorParameters;
//进度条
- (void)theProgressBar:(float)progressValue describe:(NSString *)progressDescribe;


@optional
@end

@interface LoadResources : NSObject

@property (nonatomic,weak) id <LoadResourcesDelegare> delegate;

- (void)DownloadResources:(NSString *)channel;

@end
