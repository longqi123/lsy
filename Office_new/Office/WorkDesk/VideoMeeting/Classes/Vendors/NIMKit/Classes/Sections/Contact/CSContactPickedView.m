//
//  ContactPickedView.m
//  NIM
//
//  Created by ios on 10/23/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import "CSContactPickedView.h"
#import "CSKit.h"
#import "CSAvatarImageView.h"

#define avatarWidth 35
#define blank 10
#define topBlank 7

enum CSRefreshType
{
    RefreshType_Remove,
    RefreshType_Add
};

@interface CSContactSelectAvatarView : CSAvatarImageView

@property (nonatomic, strong) NSString *userId;

@end

@implementation CSContactSelectAvatarView

@end


@interface CSContactPickedView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger currentPos;
@property (nonatomic, strong) CSContactSelectAvatarView *blankView;

@end

@implementation CSContactPickedView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    scrollView.autoresizingMask =   UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;
    
    [scrollView setContentSize:self.frame.size];
    [scrollView setScrollEnabled:YES];
    [scrollView setScrollsToTop:NO];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.array = [NSMutableArray array];
    self.currentPos = blank;
    [self addBlankAvatarView];
}

- (void)addBlankAvatarView
{
    self.blankView = [[CSContactSelectAvatarView alloc]init];
    [self.blankView setImage:[UIImage imageNamed:@"contact_head_selected.png"]];
    [self.blankView setFrame:CGRectMake(self.currentPos, topBlank, avatarWidth, avatarWidth)];
    self.blankView.userId = @"";
    [self.scrollView addSubview:self.blankView];
}

- (void)moveBlankAvatarView
{
    CGRect frame = self.blankView.frame;
    frame.origin.x = self.currentPos;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.blankView setFrame:frame];
    }];
}

- (void)addAvatarView:(CSContactSelectAvatarView *)view
{
    [view addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [self.array addObject:view];
    [self refreshView:RefreshType_Add];
    [view setFrame:CGRectMake(self.currentPos, topBlank, avatarWidth, avatarWidth)];
    [self.scrollView addSubview:view];
    self.currentPos = self.currentPos + blank + avatarWidth;
    [self moveBlankAvatarView];
}

- (void)removeAvatarView:(CSContactSelectAvatarView *)view
{
    NSInteger i = [self.array indexOfObject:view];
    [self.array removeObject:view];
    [self refreshView:RefreshType_Remove];
    [view removeFromSuperview];
    
    for (NSInteger j = i; j < [self.array count]; j++) {
        CSContactSelectAvatarView *view = [self.array objectAtIndex:j];
        CGRect frame = view.frame;
        frame.origin.x = frame.origin.x - avatarWidth - blank;
        [view setFrame:frame];
    }
    self.currentPos = self.currentPos - blank - avatarWidth;
    [self moveBlankAvatarView];
}


- (void)addMemberInfo:(CSKitInfo *)info
{

    CSContactSelectAvatarView *avatar = [[CSContactSelectAvatarView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    NSURL *url = info.avatarUrlString ? [NSURL URLWithString:info.avatarUrlString] : nil;
    [avatar nim_setImageWithURL:url placeholderImage:info.avatarImage options:NIMWebImageRetryFailed];
    avatar.userId = info.infoId;
    [self addAvatarView:avatar];
}

- (void)removeMemberInfo:(CSKitInfo *)info
{
    NSInteger i = 0;
    for (i = 0;i<[self.array count];i++) {
        CSContactSelectAvatarView *view = [self.array objectAtIndex:i];
        if ([view.userId isEqualToString:info.infoId]) {
            [self removeAvatarView:view];
            break;
        }
    }
}

- (void)refreshView:(enum CSRefreshType)refreshType
{
    NSInteger width = ([self.array count]+1)*(avatarWidth+blank)+blank;
    CGSize size = self.scrollView.contentSize;
    size.width = width;
    [self.scrollView setContentSize:size];
    
    CGPoint offset = self.scrollView.contentOffset;
    if (width> self.scrollView.frame.size.width) {
        int offsetX = width - self.scrollView.frame.size.width;
        if (!(refreshType == RefreshType_Remove && offsetX > offset.x)) {
            offset.x = offsetX;
        }
    }
    else {
        offset.x = 0;
    }
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - action
- (IBAction)remove:(id)sender
{
    CSContactSelectAvatarView *view = (CSContactSelectAvatarView *)sender;
    [self.delegate removeUser:view.userId];
    [self removeAvatarView:view];
}

@end
