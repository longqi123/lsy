//
//  CSSWhiteboardLines.h
//  NIMEducationDemo
//
//  Created by fenric on 16/10/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSWhiteboardPoint.h"
#import "CSSWhiteboardDrawView.h"

@interface CSSWhiteboardLines : NSObject<CSSWhiteboardDrawViewDataSource>

- (void)addPoint:(CSSWhiteboardPoint *)point uid:(NSString *)uid;

- (void)cancelLastLine:(NSString *)uid;

- (void)clear;

- (void)clearUser:(NSString *)uid;

- (NSDictionary *)allLines;

- (BOOL)hasLines;

@end
