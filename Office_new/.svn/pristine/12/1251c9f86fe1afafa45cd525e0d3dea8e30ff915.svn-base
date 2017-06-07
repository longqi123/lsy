//
//  TeamCardTableViewCell.m
//  Office
//
//  Created by roger on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "TeamCardTableViewCell.h"
#import <CoreFramework/CoreFramework-umbrella.h>

@implementation TeamCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detail.textColor = UIColor.T3;
    self.detail.font = UIFont.H5;
    self.lineView.backgroundColor = UIColor.L1;
    self.editImageView.image = [UIImage imageNamed:@"xiu_gai_zi_liao"];
    [self.editImageView sizeToFit];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
