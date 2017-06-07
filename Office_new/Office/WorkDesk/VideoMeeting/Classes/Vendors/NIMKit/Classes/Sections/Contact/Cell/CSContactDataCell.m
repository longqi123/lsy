//
//  NTESContactInfoCell.m
//  NIM
//
//  Created by chris on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSContactDataCell.h"
#import "CSAvatarImageView.h"
#import "UIView+CS.h"
#import "CSKit.h"

@interface CSContactDataCell()

@property (nonatomic,copy) NSString *memberId;

@end

@implementation CSContactDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[CSAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_avatarImageView addTarget:self action:@selector(onPressAvatar:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarImageView];
        _accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accessoryBtn setImage:[UIImage imageNamed:@"icon_accessory_normal"] forState:UIControlStateNormal];
        [_accessoryBtn setImage:[UIImage imageNamed:@"icon_accessory_pressed"] forState:UIControlStateHighlighted];
        [_accessoryBtn setImage:[UIImage imageNamed:@"icon_accessory_selected"] forState:UIControlStateSelected];
        [_accessoryBtn sizeToFit];
        _accessoryBtn.hidden = YES;
        _accessoryBtn.userInteractionEnabled = NO;
        [self addSubview:_accessoryBtn];
    }
    return self;
}

- (void)refreshUser:(id<CSGroupMemberProtocol>)member{
    [self refreshTitle:member.showName];
    self.memberId = [member memberId];
    CSKitInfo *info = [[CSKit sharedKit] infoByUser:self.memberId];
    [self refreshAvatar:info];
}

- (void)refreshTeam:(id<CSGroupMemberProtocol>)member{
    [self refreshTitle:member.showName];
    self.memberId = [member memberId];
    CSKitInfo *info = [[CSKit sharedKit] infoByTeam:self.memberId];
    [self refreshAvatar:info];
}

- (void)refreshTitle:(NSString *)title{
    self.textLabel.text = title;
}

- (void)refreshAvatar:(CSKitInfo *)info{
    NSURL *url = info.avatarUrlString ? [NSURL URLWithString:info.avatarUrlString] : nil;
    [_avatarImageView nim_setImageWithURL:url placeholderImage:info.avatarImage options:NIMWebImageRetryFailed];
}


- (void)onPressAvatar:(id)sender{
    if ([self.delegate respondsToSelector:@selector(onPressAvatar:)]) {
        [self.delegate onPressAvatar:self.memberId];
    }
}

- (void)addDelegate:(id)delegate{
    self.delegate = delegate;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [self.accessoryBtn setHighlighted:highlighted];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat scale = self.nim_width / 320;
    CGFloat maxTextLabelWidth = 210 * scale;
    self.textLabel.nim_width = MIN(self.textLabel.nim_width, maxTextLabelWidth);
    self.accessoryBtn.nim_left = NIMContactAccessoryLeft;
    self.accessoryBtn.nim_centerY = self.nim_height * .5f;
    self.avatarImageView.nim_left = self.accessoryBtn.hidden ? NIMContactAvatarLeft : NIMContactAvatarAndAccessorySpacing + self.accessoryBtn.nim_right;
    self.avatarImageView.nim_centerY = self.nim_height * .5f;
    self.textLabel.nim_left = self.avatarImageView.nim_right + NIMContactAvatarAndTitleSpacing;
}

@end
