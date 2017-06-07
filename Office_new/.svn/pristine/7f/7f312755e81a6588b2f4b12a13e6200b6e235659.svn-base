//
//  SessionMoreTableViewCell.m
//  Office
//
//  Created by roger on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "SessionMoreTableViewCell.h"
#import <CoreFramework/CoreFramework-umbrella.h>

@implementation SessionMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self.contentView addSubview:[[LineView alloc]init]];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.textColor = UIColor.T2;
    self.title.font = UIFont.H5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
