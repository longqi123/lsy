//
//  CSSMeetingActorsView.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSMeetingActorsView.h"
#import "CSSMeetingRolesManager.h"
#import "UIView+CSS.h"
#import "CSSGLView.h"
#import <NIMAVChat/NIMAVChat.h>
#import "CSSVideoFSViewController.h"
#import "CSSBundleSetting.h"
#define NTESMeetingMaxActors 4

@interface CSSMeetingActorsView()<NIMNetCallManagerDelegate>
{
    NSMutableArray *_actorViews;
    NSMutableArray *_actors;
    NSMutableArray *_backgroundViews;
}

@property (nonatomic, weak) CALayer *localVideoLayer;
@property (nonatomic, strong) CSSVideoFSViewController *videoVc;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic) BOOL fullBtnClick;
@property (nonatomic) NSInteger fullScreenIndex;
@property (nonatomic) BOOL firstLoad;


@end

@implementation CSSMeetingActorsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _firstLoad = NO;
        _actorViews = [NSMutableArray array];
        _backgroundViews = [NSMutableArray array];
        _videoVc = [[CSSVideoFSViewController alloc]init];
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImage = [UIImage imageNamed:@"meeting_background"];
        //_fullScreenBtn.hidden = YES;
        _fullScreenIndex = 0;
        for (int i = 0; i < NTESMeetingMaxActors; i++) {
            UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
            [self addSubview:background];
            [_backgroundViews addObject:background];
            CSSGLView *view = [[CSSGLView alloc] initWithFrame:self.bounds];
            view.contentMode = [[CSSBundleSetting sharedConfig] videochatRemoteVideoContentMode];
            view.backgroundColor = [UIColor clearColor];
            [view render:nil width:0 height:0];
            view.tag = i;
            [self addSubview:view];
            [_actorViews addObject:view];

        }
        [self updateActors];
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    }
    return self;
}


- (void)dealloc
{
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}

- (void)onLocalPreviewReady:(CALayer *)layer
{
    if ([CSSMeetingRolesManager sharedInstance].myRole.isActor) {
        [self startLocalPreview:layer];
    }
    else {
        _localVideoLayer = layer;
    }
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    if (_actors.count == 0) {
        return;
    }
    NSUInteger viewIndex = [_actors indexOfObject:user];

    //判断是否全屏
    if(_isFullScreen)
    {
        if(viewIndex == 0)
        {
            [_videoVc onRemoteYUVReady:yuvData width:width height:height from:user];
        }
    }
    else
    {
        if (viewIndex != NSNotFound && viewIndex < NTESMeetingMaxActors) {
            CSSGLView *view = _actorViews[viewIndex];
            [view render:yuvData width:width height:height];
            if(viewIndex == 0)
            {
                if(_showFullScreenBtn)
                {
                    _fullScreenBtn.hidden = NO;

                }
                else
                {
                    _fullScreenBtn.hidden = YES;
                }
            }
        }
    }
}

-(void)setShowFullScreenBtn:(BOOL)showFullScreenBtn
{
    _showFullScreenBtn = showFullScreenBtn;
    if(!showFullScreenBtn)
    {
        _fullScreenBtn.hidden = !showFullScreenBtn;
    }
    //退出全屏
    if (self.isFullScreen&&!showFullScreenBtn ) {
        [_videoVc onExitFullScreen];
    }
}

- (void)goFullScreen:(UIButton *)sender
{
    //1.获取到点击按钮的view
    CSSGLView *toBecomeView = _actorViews[sender.tag];

    //2.获取到大屏幕view
    CSSGLView *firstView = _actorViews[_fullScreenIndex];

    //3.获取两个view的size
    CGRect toBecomeViewRect = toBecomeView.frame;
    CGRect firstViewRect = firstView.frame;
    
    //本机是观众，小屏状态
    if (sender.tag == [self localViewIndex]  && [self localViewIndex] != 0) {
        CSSGLView *localView = _actorViews[[self localViewIndex]];
        
        localView.width = self.width;
        localView.height = self.height - 44;
        
        _localVideoLayer.frame = localView.bounds;
    }
    //本机是观众，大屏状态
    else if (sender.tag != [self localViewIndex]  && [self localViewIndex] != 0){
        CSSGLView *localView = _actorViews[[self localViewIndex]];
        
        localView.width = self.width / 3 - 5;
        localView.height = self.height / 3 - 44;
        
        _localVideoLayer.frame = localView.bounds;
    }
    //本机是房主，大屏状态被点击
    else if (_fullScreenIndex == 0 && [self localViewIndex] == 0) {
        CSSGLView *localView = _actorViews[[self localViewIndex]];
        
        localView.width = self.width / 3 - 5;
        localView.height = self.height / 3 - 44;

        _localVideoLayer.frame = localView.bounds;
    }
    //本机是房主，小屏状态被点击
    else if (sender.tag == 0 && [self localViewIndex] == 0){
        CSSGLView *localView = _actorViews[[self localViewIndex]];
        
        localView.width = self.width;
        localView.height = self.height - 44;
        
        _localVideoLayer.frame = localView.bounds;
    }

    //4.更新大屏幕的fullScreenIndex
    _fullScreenIndex = sender.tag;
    
    //5.标记全屏按钮已点击
    _fullBtnClick = YES;
    
    //6.获取层级
    NSInteger firstIndex = [self.subviews indexOfObject:firstView];
    NSInteger secondIndex = [self.subviews indexOfObject:toBecomeView];
    
    //7.修改全屏按钮可视
    UIButton *btn = toBecomeView.subviews[0];
    btn.alpha = 0;
    
    UIButton *btn2 = firstView.subviews[0];
    btn2.alpha = 1;
    
    //8.修改尺寸
    toBecomeView.frame = firstViewRect;
    firstView.frame = toBecomeViewRect;
    [firstView setClipsToBounds:YES];

    //9.交换层级
    _fullBtnClick = YES;
    [self exchangeSubviewAtIndex:firstIndex withSubviewAtIndex:secondIndex];
}

- (void)startLocalPreview:(CALayer *)layer
{
    [self stopLocalPreview];
    
    DDLogInfo(@"Start local preview");

    _localVideoLayer = layer;
    
    CSSGLView *localView = _actorViews[[self localViewIndex]];
    
    [localView render:nil width:0 height:0];
    
    [localView.layer addSublayer:_localVideoLayer];

    [self layoutLocalPreviewLayer];
}


-(void)stopLocalPreview
{
    DDLogInfo(@"Stop local preview");
    if (_localVideoLayer) {
        [_localVideoLayer removeFromSuperlayer];
    }
}

- (void)layoutLocalPreviewLayer
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat rotateDegree;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateDegree = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateDegree = M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateDegree = M_PI_2 * 3.0;
            break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:
            rotateDegree = 0;
            break;
    }
    
    [_localVideoLayer setAffineTransform:CGAffineTransformMakeRotation(rotateDegree)];
    
    UIView *localView = _actorViews[[self localViewIndex]];
    _localVideoLayer.frame = localView.bounds;
    
}

- (void)showActorsWithCount:(int)count{
    for (int i = 0; i <= count; i++){
        UIView *view = _actorViews[i];
        view.hidden = false;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_fullBtnClick) {
        _fullBtnClick = !_fullBtnClick;
        return;
    }
    
    for (int i = 0; i < NTESMeetingMaxActors; i ++) {
        _fullBtnClick = NO;
        //如果是主持人
        if (i == 0) {
            UIView *view = _actorViews[i];
            view.width = self.width;
            //预留底部输入框的高度，不一定对，可能需要修改
            view.height = self.height - 44;
            view.top = 0;
            view.left = 0;
    
            UIImageView *backgound = _backgroundViews[i];
            backgound.frame = CGRectMake(0, 0, self.width, self.height - 44);
            
            UIButton *fullScreenBtn = [[UIButton alloc]init];
            fullScreenBtn.frame = CGRectMake(0, 0, 30, 30);
            fullScreenBtn.tag = i;
            [fullScreenBtn setImage: [UIImage imageNamed:@"zhan_kai_quan_ping"] forState:UIControlStateNormal];
            fullScreenBtn.alpha = 0;
            [fullScreenBtn addTarget:self action:@selector(goFullScreen:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:fullScreenBtn];
        }
        //如果是听众
        else{
            UIView *view = _actorViews[i];
            view.width = self.width / 3 - 5;
            view.height = self.height / 3 - 44;
            view.top = self.height - view.height - 44;
            view.left = self.width - view.width - ((i-1) * view.width + (i-1) * 7.5);
            
            UIImageView *backgound = _backgroundViews[i];
            backgound.frame = view.frame;

            UIButton *fullScreenBtn = [[UIButton alloc]init];
            fullScreenBtn.frame = CGRectMake(0, 0, 30, 30);
            fullScreenBtn.tag = i;
            [fullScreenBtn setImage: [UIImage imageNamed:@"zhan_kai_quan_ping"] forState:UIControlStateNormal];
            [fullScreenBtn addTarget:self action:@selector(goFullScreen:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:fullScreenBtn];
        }
    }
}

- (void)updateActors
{
    NSMutableArray *actors = [NSMutableArray arrayWithArray:[[CSSMeetingRolesManager sharedInstance] allActors]];
    
    [actors sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *actor1  = obj1;
        NSString *actor2  = obj2;
        NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
        CSSMeetingRole *role1 = [[CSSMeetingRolesManager sharedInstance] role:actor1];
        CSSMeetingRole *role2 = [[CSSMeetingRolesManager sharedInstance] role:actor2];

        //Manager排第一
        if (role1.isManager) {
            return NSOrderedAscending;
        }
        else if (role2.isManager) {
            return NSOrderedDescending;
        }
        
        //自己排第二（如果自己不是Manager）
        if ([actor1 isEqualToString:myUid]) {
            return NSOrderedAscending;
        }
        else if ([actor2 isEqualToString:myUid]) {
            return NSOrderedDescending;
        }

        return NSOrderedAscending;

    }];

    if (actors.count != _actors.count) {
        for (CSSGLView *view in _actorViews) {
            [view render:nil width:0 height:0];
        }
    }
    
    _actors = actors;
    
    if (_localVideoLayer) {
        if ([CSSMeetingRolesManager sharedInstance].myRole.videoOn) {
            [self onLocalPreviewReady:_localVideoLayer];
        }
        else {
            [self stopLocalPreview];
        }
    }
}

-(NSUInteger)localViewIndex
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (_actors.count) {
        return [_actors indexOfObject:myUid];
    }
    else {
        return NSNotFound;
    }
}

@end
