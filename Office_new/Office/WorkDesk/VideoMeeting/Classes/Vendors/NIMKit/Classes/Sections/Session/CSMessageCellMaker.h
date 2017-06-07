//
//  CSMessageCellMaker.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMessageCell.h"
#import "CSSessionTimestampCell.h"
#import "CSCellConfig.h"
#import "CSMessageCellProtocol.h"

@interface CSMessageCellMaker : NSObject

+ (CSMessageCell *)cellInTable:(UITableView*)tableView
                 forMessageMode:(CSMessageModel *)model;

+ (CSSessionTimestampCell *)cellInTable:(UITableView *)tableView
                            forTimeModel:(CSTimestampModel *)model;

@end
