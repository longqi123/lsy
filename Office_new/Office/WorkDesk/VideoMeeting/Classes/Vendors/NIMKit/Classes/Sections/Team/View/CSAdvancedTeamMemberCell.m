//
//  CSAdvancedTeamMemberCell.m
//  NIM
//
//  Created by chris on 15/3/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSAdvancedTeamMemberCell.h"
#import "UIView+CS.h"
#import "CSUsrInfoData.h"
#import "CSAvatarImageView.h"
#import "CSKitUtil.h"
#import "CSKit.h"

typedef NS_ENUM(NSInteger, CSAdvancedTeamMemberType) {
    AdvancedTeamMemberTypeInvalid,
    AdvancedTeamMemberTypeAdd,
    AdvancedTeamMemberTypeMember,
};

@interface CSAdvancedTeamMemberView : UIView{

}

@property(nonatomic,strong) CSAvatarImageView *imageView;

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) CSKitInfo *member;

@property(nonatomic,assign) CSAdvancedTeamMemberType type;

@end

#define RegularTeamMemberViewHeight 53
#define RegularTeamMemberViewWidth  38
@implementation CSAdvancedTeamMemberView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_titleLabel];
        _imageView   = [[CSAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setMember:(CSKitInfo *)member{
    _member = member;
    NSURL *avatarURL;
    if (member.avatarUrlString.length) {
        avatarURL = [NSURL URLWithString:member.avatarUrlString];
    }
    [_imageView nim_setImageWithURL:avatarURL placeholderImage:member.avatarImage];
}


- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(RegularTeamMemberViewWidth, RegularTeamMemberViewHeight);
}


#define RegularTeamMemberInvite
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.nim_width = _titleLabel.nim_width > self.nim_width ? self.nim_width : _titleLabel.nim_width;
    self.imageView.nim_centerX = self.nim_width * .5f;
    self.titleLabel.nim_centerX = self.nim_width * .5f;
    self.titleLabel.nim_bottom = self.nim_height;
}
@end


@interface CSAdvancedTeamMemberCell()

@property(nonatomic,strong) NSMutableArray *icons;

@property(nonatomic,strong) NIMTeam *team;

@property(nonatomic,copy)   NSArray *teamMembers;

@property(nonatomic,strong) UIButton *addBtn;

@end

@implementation CSAdvancedTeamMemberCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icons = [[NSMutableArray alloc] init];
        _addBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_addBtn addTarget:self action:@selector(onPress:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.userInteractionEnabled = NO;
        [self addSubview:_addBtn];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)rereshWithTeam:(NIMTeam*)team
               members:(NSArray*)members
                 width:(CGFloat)width{
    _team = team;
    _teamMembers = members;
    NIMTeamMember *myTeamInfo;
    for (NIMTeamMember *member in members) {
        if ([member.userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            myTeamInfo = member;
            break;
        }
    }
    NSInteger count = 0;
    if (myTeamInfo.type == NIMTeamMemberTypeOwner || myTeamInfo.type == NIMTeamMemberTypeManager) {
        CSAdvancedTeamMemberView *view = [self fetchMemeberView:0];
        UIImage *addImage = [UIImage imageNamed:@"icon_add_normal"];
        [view.imageView nim_setImageWithURL:nil placeholderImage:addImage];
        view.titleLabel.text = @"邀请";
        view.type  = AdvancedTeamMemberTypeAdd;
        count = 1;
        self.addBtn.userInteractionEnabled = YES;
    }else{
        self.addBtn.userInteractionEnabled = NO;
    }
    
    CGFloat padding = 44.f;
    CGFloat itemWidth = 49.f;
    NSInteger maxIconCount = (width - padding) / itemWidth;
    NSInteger iconCount = members.count > maxIconCount-count ? maxIconCount : members.count + count;
    NIMSession *session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
    for (UIView *view in _icons) {
        [view removeFromSuperview];
    }
    for (NSInteger i = 0; i < iconCount; i++) {
        CSAdvancedTeamMemberView *view = [self fetchMemeberView:i];
        if (!count || i != 0) {
            NSInteger memberIndex       = i - count;
            NIMTeamMember *member       = members[memberIndex];
            CSKitInfo *info            = [[CSKit sharedKit] infoByUser:member.userId];
            view.member                 = info;
            view.titleLabel.text        = [CSKitUtil showNick:member.userId inSession:session];
            view.type                   = AdvancedTeamMemberTypeMember;
        }
        [self addSubview:view];
        [view setNeedsLayout];
    }
    [self bringSubviewToFront:self.addBtn];
}

- (void)onPress:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectAddOpeartor)]) {
        [self.delegate didSelectAddOpeartor];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect hitRect = self.addBtn.frame;
    return CGRectContainsPoint(hitRect, point) ? self.addBtn : [super hitTest:point withEvent:event];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _addBtn.frame = CGRectMake(0, 0, self.nim_width *.20f, self.nim_height);
    CGFloat left = 20.f;
    CGFloat top  = 17.f;
    self.textLabel.nim_left = left;
    self.textLabel.nim_top  = top;
    self.detailTextLabel.nim_top = top;
    self.accessoryView.nim_top = top;
    
    CGFloat spacing = 12.f;
    CGFloat bottom  = 10.f;
    for (CSAdvancedTeamMemberView *view in _icons) {
        view.nim_left = left;
        left += view.nim_width;
        left += spacing;
        view.nim_bottom = self.nim_height - bottom;
    }
}


#pragma mark - Private

- (CSAdvancedTeamMemberView *)fetchMemeberView:(NSInteger)index{
    if (_icons.count <= index) {
        for (int i = 0; i < index - _icons.count + 1 ; i++) {
            CSAdvancedTeamMemberView *view = [[CSAdvancedTeamMemberView alloc]initWithFrame:CGRectZero];
            view.userInteractionEnabled = NO;
            [view sizeToFit];
            [_icons addObject:view];
        }
    }
    return _icons[index];
}


@end
