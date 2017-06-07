//
//  WhiteBoardDrawView.h
//  NIM
//
//  Created by 高峰 on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSSWhiteboardDrawViewDataSource <NSObject>

- (NSDictionary *)allLinesToDraw;

- (BOOL)hasUpdate;

@end

@interface CSSWhiteboardDrawView : UIView

@property(nonatomic, weak) id<CSSWhiteboardDrawViewDataSource> dataSource;


@end
