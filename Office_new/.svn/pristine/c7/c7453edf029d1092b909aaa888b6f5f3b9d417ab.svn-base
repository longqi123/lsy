//
//  CreatSessionCell.m
//  Office
//
//  Created by roger on 2017/6/3.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "CreatSessionCell.h"
#import <CoreFramework/CoreFramework-umbrella.h>

@implementation CreatSessionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _creatTitle.textColor = UIColor.T2;
    _creatTitle.font = UIFont.H3;
    
    _creatTextField.textColor = UIColor.T3;
    _creatTextField.font = UIFont.H5;
    
    _bottomLine.backgroundColor = UIColor.L1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder{
    _creatTitle.text = title;
    _creatTextField.placeholder = placeholder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
