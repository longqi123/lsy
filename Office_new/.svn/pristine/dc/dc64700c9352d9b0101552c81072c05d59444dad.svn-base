//
//  CSSCADisplayLinkHolder.h
//  NIM
//
//  Created by Netease on 15/8/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CSSCADisplayLinkHolder;

@protocol CSSCADisplayLinkHolderDelegate <NSObject>

- (void)onDisplayLinkFire:(CSSCADisplayLinkHolder *)holder
                 duration:(NSTimeInterval)duration
              displayLink:(CADisplayLink *)displayLink;

@end


@interface CSSCADisplayLinkHolder : NSObject

@property (nonatomic,weak  ) id<CSSCADisplayLinkHolderDelegate> delegate;
@property (nonatomic,assign) NSInteger frameInterval;

- (void)startCADisplayLinkWithDelegate: (id<CSSCADisplayLinkHolderDelegate>)delegate;

- (void)stop;

@end
