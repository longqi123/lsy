//
//  CSMessageCellMaker.m
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSMessageCellMaker.h"
#import "CSMessageModel.h"
#import "CSTimestampModel.h"

@implementation CSMessageCellMaker

+ (CSMessageCell *)cellInTable:(UITableView*)tableView
                 forMessageMode:(CSMessageModel *)model
{
    id<CSCellLayoutConfig> config = model.layoutConfig;
    NSString *identity = [config cellContent:model];
    CSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        NSString *clz = @"CSMessageCell";
        [tableView registerClass:NSClassFromString(clz) forCellReuseIdentifier:identity];
        cell = [tableView dequeueReusableCellWithIdentifier:identity];
    }
    [cell refreshData:model];
    return (CSMessageCell *)cell;
}

+ (CSSessionTimestampCell *)cellInTable:(UITableView *)tableView
                            forTimeModel:(CSTimestampModel *)model
{
    NSString *identity = @"time";
    CSSessionTimestampCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        NSString *clz = @"CSSessionTimestampCell";
        [tableView registerClass:NSClassFromString(clz) forCellReuseIdentifier:identity];
        cell = [tableView dequeueReusableCellWithIdentifier:identity];
    }
    [cell refreshData:model];
    return (CSSessionTimestampCell *)cell;
    
    
}

@end
