//
//  CSSTextSettingCell.h
//  NIM
//
//  Created by chris on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSCommonTableViewCell.h"

@interface CSSTextSettingCell : UITableViewCell<CSSCommonTableViewCell>

//textField的placeholder为NTESCommonTableRow.title
//textField的text为NTESCommonTableRow.extraData

@property (nonatomic ,strong) UITextField *textField;

@end
