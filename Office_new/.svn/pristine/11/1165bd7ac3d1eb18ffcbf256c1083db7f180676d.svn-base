//
//  CSSMeetingViewController.m
//  NIM
//
//  Created by fenric on 16/4/7.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "CSSMeetingViewController.h"
#import "CSSChatroomSegmentedControl.h"
#import "UIView+CSS.h"
#import "CSSPageView.h"
#import "CSSChatroomViewController.h"
#import "CSSChatroomMemberListViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+CSS.h"
#import "SVProgressHUD.h"
#import "UIImage+NTESColor.h"
#import "CSSMeetingActionView.h"
#import "UIView+Toast.h"
#import "CSSMeetingManager.h"
#import "CSSMeetingActorsView.h"
#import "NSDictionary+CSSJson.h"
#import "UIAlertView+CSSBlock.h"
#import "CSSMeetingRolesManager.h"
#import "CSSDemoService.h"
#import "CSSMeetingNetCallManager.h"
#import "CSSActorSelectView.h"
#import "CSGlobalMacro.h"
#import "CSSMeetingRolesManager.h"
#import "CSSMeetingWhiteboardViewController.h"
#import <NIMAVChat/NIMAVChat.h>
#import "CSMessageMaker.h"
#import <CoreFramework/CoreFramework-umbrella.h>
#import "Office-Swift.h"
#import "SessionMoreViewController.h"
#import "VideoMeetingManager.h"

@interface CSSMeetingViewController ()<CSSMeetingActionViewDataSource,CSSMeetingActionViewDelegate,NIMInputDelegate,NIMChatroomManagerDelegate,CSSMeetingNetCallManagerDelegate,CSSActorSelectViewDelegate,CSSMeetingRolesManagerDelegate,NIMLoginManagerDelegate,CSInputActionDelegate,MessgeAddressListDelegate
>

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) CSSChatroomViewController *chatroomViewController;

//底部控件view
@property (nonatomic, strong) CSSMeetingActionView *actionView;

//视频承载view
@property (nonatomic, strong) CSSMeetingActorsView *actorsView;

@property (nonatomic, strong, readonly) CSInputView *inputView;

@property (nonatomic, assign) BOOL keyboradIsShown;

@property (nonatomic, weak)   UIViewController *currentChildViewController;

@property (nonatomic, strong) UIAlertView *actorEnabledAlert;

@property (nonatomic, strong) CSSActorSelectView *actorSelectView;

//成员列表
@property (nonatomic, strong) CSSChatroomMemberListViewController *memberListVC;

//白板
@property (nonatomic, strong) CSSMeetingWhiteboardViewController *whiteboardVC;

@property (nonatomic, assign) BOOL isPoped;

@property (nonatomic, assign) BOOL isRemainStdNav;

@property (nonatomic, assign) BOOL readyForFullScreen;

@property (nonatomic, assign) BOOL isMemberListHide;

@property (nonatomic, strong) UIButton *memberButton;



//@property (nonatomic, strong) CSSessionViewLayoutManager *layoutManager;

@end

@implementation CSSMeetingViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
        
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[CSSMeetingNetCallManager sharedInstance] leaveMeeting];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //创建底部子页面
    //[self setupChildViewController];
    
    //视频view
    [self.view addSubview:self.actorsView];
    
    //其他控件view
    //[self.view addSubview:self.actionView];
    //[self.actionView reloadData];
    
    //self.currentChildViewController = self.whiteboardVC;
    [self revertInputView];
    [self setupBarButtonItem];
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[CSSMeetingRolesManager sharedInstance] setDelegate:self];
    [[CSSMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
    
    //输入框
    _inputView = [[CSInputView alloc] initWithFrame:CGRectMake(0, UIScreenHeight - 44, UIScreenWidth, 44)];
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    //self._inputView.nim_bottom = self.view.nim_height;
    [self.inputView setInputConfig:nil];
    [self.inputView setInputActionDelegate:self];
    [self.view addSubview:self.inputView];
    
    //讨论
    //self.chatroomViewController = [[CSSChatroomViewController alloc] initWithChatroom:self.chatroom];
    self.chatroomViewController = [[CSSChatroomViewController alloc]initWithChatroom:self.chatroom InputView:_inputView];
    self.chatroomViewController.view.frame = CGRectMake(0, UIScreenHeight - 220 - 250, UIScreenWidth, 220);
    self.chatroomViewController.delegate = self;
    self.isMemberListHide = YES;
    [self addChildViewController:self.chatroomViewController];
    [self.view addSubview:self.chatroomViewController.view];
    
    //成员列表
    self.memberListVC = [[CSSChatroomMemberListViewController alloc] initWithChatroom:self.chatroom];
    
    self.memberListVC.view.frame = CGRectMake(UIScreenWidth, 0, UIScreenWidth *0.8, 300);
    [self addChildViewController:self.memberListVC];
    [self.view addSubview:self.memberListVC.view];
    
    
    //成员按钮
    CGFloat btnWidth = 30;
    self.memberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.memberButton.frame = CGRectMake(UIScreenWidth - btnWidth, 0, btnWidth, btnWidth);
    [self.memberButton setImage:[UIImage imageNamed:@"icon_back_left"] forState:UIControlStateNormal];
    
    [self.memberButton addTarget:self action:@selector(onSelfMemberPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.memberButton];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    self.chatroomViewController.delegate = self;
//    [self.currentChildViewController beginAppearanceTransition:YES animated:animated];
    
    self.actorsView.isFullScreen = NO;
    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];
    barBackgroundView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    self.chatroomViewController.delegate = nil; //避免view不再顶层仍受到键盘回调，导致改变状态栏样式。
//    [self revertInputView];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];
    barBackgroundView.alpha = 1;
//    [self.currentChildViewController beginAppearanceTransition:NO animated:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.currentChildViewController endAppearanceTransition];
}

- (void)viewDidLayoutSubviews{
//    BOOL isFirstLayout = CGRectEqualToRect(_layoutManager.viewRect, CGRectZero);
//    if (isFirstLayout) {
//        [self.chatroomViewController.tableView cs_scrollToBottom:NO];
//    }
//    [_layoutManager setViewRect:self.view.frame];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


//- (void)setupChildViewController
//{
//    NSArray *vcs = [self makeChildViewControllers];
//    for (UIViewController *vc in vcs) {
//        [self addChildViewController:vc];
//    }
//}

#pragma mark - CSSMeetingActionViewDataSource

- (NSInteger)numberOfPages
{
    return self.childViewControllers.count;
}

- (UIView *)viewInPage:(NSInteger)index
{
    UIView *view = self.childViewControllers[index].view;
    return view;
}

- (CGFloat)actorsViewHeight
{
    return self.actorsView.height;
}

#pragma mark - CSSMeetingActionViewDelegate

- (void)onSegmentControlChanged:(CSSChatroomSegmentedControl *)control
{
    UIViewController *lastChild = self.currentChildViewController;
    UIViewController *child = self.childViewControllers[self.actionView.segmentedControl.selectedSegmentIndex];
    
    if ([child isKindOfClass:[CSSChatroomMemberListViewController class]]) {
        self.actionView.unreadRedTip.hidden = YES;
    }
    
    [lastChild beginAppearanceTransition:NO animated:YES];
    [child beginAppearanceTransition:YES animated:YES];
    [self.actionView.pageView scrollToPage:self.actionView.segmentedControl.selectedSegmentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentChildViewController = child;
        [lastChild endAppearanceTransition];
        [child endAppearanceTransition];
        [self revertInputView];
    });
}

- (void)onTouchActionBackground:(UITapGestureRecognizer *)gesture
{
    CGPoint point  = [gesture locationInView:self.actorsView];
    UIView *view = [self.actorsView hitTest:point withEvent:nil];
    if (view) {
        self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    }
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)view;
        [control sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [self.chatroomViewController.sessionInputView endEditing:YES];
}

#pragma mark - Get

- (CGFloat)meetingActorsViewHeight
{
    return CSKit_UIScreenWidth * 220.f / 320.f;
}

- (CSSMeetingActorsView *)actorsView{
    if (!self.isViewLoaded) {
        return nil;
    }
    //设置视频view的尺寸
    if (!_actorsView) {
        //现需求
        _actorsView = [[CSSMeetingActorsView alloc] initWithFrame:CGRectMake(0, -64, UIScreenWidth, UIScreenHeight)];
        //原始
//        _actorsView = [[CSSMeetingActorsView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.meetingActorsViewHeight)];
//        _actorsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _actorsView;
}

- (CSSMeetingActionView *)actionView
{
    if (!self.isViewLoaded) {
        return nil;
    }
    //白板，讨论，成员
    if (!_actionView) {
        _actionView = [[CSSMeetingActionView alloc] initWithDataSource:self];
        _actionView.frame = self.view.bounds;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _actionView.delegate = self;
        _actionView.unreadRedTip.hidden = YES;
    }
    return _actionView;
}


#pragma mark - NIMInputDelegate
- (void)showInputView
{
    self.keyboradIsShown = YES;
}

- (void)hideInputView
{
    self.keyboradIsShown = NO;
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        
        NSString *toast;
        
        if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            toast = @"会议已结束";
        }
        else {
            switch (reason) {
                case NIMChatroomKickReasonByManager:
                    toast = @"你已被老师请出房间";
                    break;
                case NIMChatroomKickReasonInvalidRoom:
                    toast = @"老师已经结束了教学";
                    break;
                case NIMChatroomKickReasonByConflictLogin:
                    toast = @"你已被自己踢出了房间";
                    break;
                default:
                    toast = @"你已被踢出了房间";
                    break;
            }
        }
        
        
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        
        //判断 当前页面是document列表的情况
        if ([self.navigationController.visibleViewController isKindOfClass:[CSSDocumentViewController class]]) {
            [self.navigationController.visibleViewController.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            NSUInteger index = [self.navigationController.viewControllers indexOfObject:self.navigationController.visibleViewController]-2;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
        }
        else if(self.actorsView.isFullScreen)//正在全屏 先退出全屏
        {
            [self.presentedViewController.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            self.actorsView.showFullScreenBtn = NO;
            [self pop];
        }
        else{
            [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            [self pop];
        }
    }
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepLoginOK) {
        if (![[CSSMeetingNetCallManager sharedInstance] isInMeeting]) {
            [self.view makeToast:@"登录成功，重新进入房间"];
            [[CSSMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
        }
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connectionStateChanged roomId : %@  state:%zd",roomId,state);
    if(state==NIMChatroomConnectionStateEnterOK)
    {
        [self requestChatRoomInfo];
    }
}

#pragma mark - CSSMeetingNetCallManagerDelegate
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error
{
    [self.view.window makeToast:@"无法加入视频，退出房间" duration:3.0 position:CSToastPositionCenter];

    if ([[[CSSMeetingRolesManager sharedInstance] myRole] isManager]) {
        [self requestCloseChatRoom];
    }
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself pop];
    });
}

- (void)onMeetingConntectStatus:(BOOL)connected
{
    DDLogInfo(@"Meeting %@ ...", connected ? @"connected" : @"disconnected");
    if (connected) {
    }
    else {
        [self.view.window makeToast:@"音视频服务连接异常" duration:2.0 position:CSToastPositionCenter];
        [self.actorsView stopLocalPreview];
    }
}

#pragma mark - CSSMeetingRolesManagerDelegate

//成员更新
- (void)meetingRolesUpdate
{
    [self.actorsView updateActors];
    [self.memberListVC refresh];
    //[self.whiteboardVC checkPermission];
    [self setupBarButtonItem];
}

//音量更新
- (void)meetingVolumesUpdate
{
    [self.memberListVC refresh];
}

//人数更新
- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered
{
    [self.memberListVC updateMembers:members entered:entered];
}

#warning 当加入新成员时，应该有一个红点提示。
- (void)meetingMemberRaiseHand
{
    /*
    if (self.actionView.segmentedControl.selectedSegmentIndex != 2) {
        self.actionView.unreadRedTip.hidden = NO;
    }
     */
}

- (void)meetingActorBeenEnabled
{
    if (!self.actorSelectView) {
        _isRemainStdNav = YES;
        self.actorSelectView = [[CSSActorSelectView alloc] initWithFrame:self.view.bounds];
        self.actorSelectView.delegate = self;
        [self.actorSelectView setUserInteractionEnabled:YES];
        [self.view addSubview:self.actorSelectView];
    }
}

- (void)meetingActorBeenDisabled
{
    [self removeActorSelectView];
        
    [self.view.window makeToast:@"你已被老师取消互动" duration:2.0 position:CSToastPositionCenter];
}

- (void)meetingActorsNumberExceedMax
{
    [self.view makeToast:@"互动人数已满" duration:1 position:CSToastPositionCenter];
}

-(void)meetingRolesShowFullScreen:(NSString*)notifyExt
{
    if ([self showFullScreenBtn:notifyExt]) {
        self.actorsView.showFullScreenBtn = YES;
    }
    else
    {
        self.actorsView.showFullScreenBtn = NO;
    }
}

-(void)set{
    int a = [[CSSMeetingRolesManager sharedInstance] allActors].count;


}
#pragma mark - CSSActorSelectViewDelegate
//当学生点击确认用视频，音频时的回调方法
- (void)onSelectedAudio:(BOOL)audioOn video:(BOOL)videoOn whiteboard:(BOOL)whiteboardOn
{
    [self set];
    
    [self removeActorSelectView];
    _isRemainStdNav = NO;

    if (audioOn) {
        [[CSSMeetingRolesManager sharedInstance] setMyAudio:YES];
    }
    
    if (videoOn) {
        [[CSSMeetingRolesManager sharedInstance] setMyVideo:YES];
    }
    
    if (whiteboardOn) {
        [[CSSMeetingRolesManager sharedInstance] setMyWhiteBoard:YES];
    }    
}

#pragma mark - Private
//- (NSArray *)makeChildViewControllers{
//    //讨论
//    self.chatroomViewController = [[CSSChatroomViewController alloc] initWithChatroom:self.chatroom];
//    self.chatroomViewController.delegate = self;
//    //成员
//    self.memberListVC = [[CSSChatroomMemberListViewController alloc] initWithChatroom:self.chatroom];
//    //白板
//    self.whiteboardVC = [[CSSMeetingWhiteboardViewController alloc] initWithChatroom:self.chatroom];
//    
//
//        return @[self.whiteboardVC,self.chatroomViewController,self.memberListVC];
//}

-(BOOL)showFullScreenBtn:(NSString * )jsonString
{
    if(jsonString)
    {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        
        NSDictionary *dic = [NSJSONSerialization  JSONObjectWithData:jsonData
                             
                                                            options:NSJSONReadingAllowFragments
                             
                                                              error:&err];
        
        if ([dic objectForKey:@"fullScreenType"])
        {
            if([[dic objectForKey:@"fullScreenType"]integerValue] == 1)
            {
                return YES;
            }
        }
        return NO;
    }
    
    return NO;
}
- (void)revertInputView
{
    UIView *inputView  = self.chatroomViewController.sessionInputView;
    UIView *revertView;
    if ([self.currentChildViewController isKindOfClass:[CSSChatroomViewController class]]) {
        revertView = self.view;
    }else{
        revertView = self.chatroomViewController.view;
    }
    CGFloat height = revertView.height;
    [revertView addSubview:inputView];
    inputView.bottom = height;
}

- (void)setupBarButtonItem
{
    //根据用户角色判断导航栏rightBarButtonItem显示 老师右边三个btn
    if ([[[CSSMeetingRolesManager sharedInstance] myRole] isManager]) {
        [self refreshTecNavBar];
    }
    //学生端 互动前2个btn 互动后4个btn
    else
    {
        [self refreshStdNavBar];
    }
    
    //显示左边leftBarButtonItem
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    //左边返回button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"chatroom_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"chatroom_back_selected"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    //房间号label
    NSString * string =  [NSString stringWithFormat:@"房间号：%@", _chatroom.roomId];
    CGRect rectTitle = [string boundingRectWithSize:CGSizeMake(999, 30)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:UIFont.H10}
                                                                   context:nil];


    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, rectTitle.size.width+20, 30)];
    title.font = UIFont.H10;
    title.textColor = UIColor.T6;
    title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    title.text = string;
    title.textAlignment = NSTextAlignmentCenter;

    title.layer.cornerRadius = 15;
    title.layer.masksToBounds = YES;
    [leftView addSubview:leftButton];
    [leftView addSubview:title];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSMutableArray *arrayItems=[NSMutableArray array];
    [arrayItems addObject:negativeSpacer];
    [arrayItems addObject:leftItem];
    negativeSpacer.width = -7;

    self.navigationItem.leftBarButtonItems = arrayItems;
}
-(void)refreshTecNavBar
{
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 30;
    CGFloat btnMargin = 7;

    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4*btnMargin+4*btnWidth, 30)];
    CSSMeetingRole *myRole = [[CSSMeetingRolesManager sharedInstance] myRole];
    NSString *audioImage = myRole.audioOn ? @"yang_sheng_qi" : @"guan_bi_yang_sheng_qi";
//    NSString *audioImageSelected = myRole.audioOn ? @"chatroom_audio_selected" : @"chatroom_audio_off_selected";

    NSString *videoImage = myRole.videoOn ? @"she_xiang_tou" : @"guan_bi_she_xiang_tou";
//    NSString *videoImageSelected = myRole.audioOn ? @"chatroom_video_selected" : @"chatroom_video_off_selected";
    

    //音频按钮
    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioButton.frame = CGRectMake(2*btnMargin+btnWidth*2, 0, btnWidth, btnHeight);
    [audioButton setImage:[UIImage imageNamed:audioImage] forState:UIControlStateNormal];
//    [audioButton setImage:[UIImage imageNamed:audioImageSelected] forState:UIControlStateHighlighted];
    [audioButton addTarget:self action:@selector(onSelfAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
    //视频按钮
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = CGRectMake(btnMargin+btnWidth, 0, btnWidth, btnHeight);
    [videoButton setImage:[UIImage imageNamed:videoImage] forState:UIControlStateNormal];
//    [videoButton setImage:[UIImage imageNamed:videoImageSelected] forState:UIControlStateHighlighted];
    [videoButton addTarget:self action:@selector(onSelfVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //邀请按钮
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteButton.frame = CGRectMake(3*btnMargin+3*btnWidth, 0, btnWidth, btnHeight);
    [inviteButton setImage:[UIImage imageNamed:@"yao_qing"] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(onSelfInvitePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:audioButton];
    [rightView addSubview:videoButton];
    [rightView addSubview:inviteButton];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSMutableArray *arrayItems=[NSMutableArray array];
    [arrayItems addObject:negativeSpacer];
    [arrayItems addObject:rightItem];
    negativeSpacer.width = -btnMargin;
    self.navigationItem.rightBarButtonItems = arrayItems;

}
-(void)refreshStdNavBar
{
    CSSMeetingRole *myRole = [[CSSMeetingRolesManager sharedInstance] myRole];
    NSString *audioImage = myRole.audioOn ? @"chatroom_audio_on" : @"chatroom_audio_off";
    NSString *videoImage = myRole.videoOn ? @"chatroom_video_on" : @"chatroom_video_off";
    NSString *audioImageSelected = myRole.audioOn ? @"chatroom_audio_selected" : @"chatroom_audio_off_selected";
    NSString *videoImageSelected = myRole.audioOn ? @"chatroom_video_selected" : @"chatroom_video_off_selected";
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 30;
    CGFloat btnMargin = 7;
    if (myRole.isActor&&!_isRemainStdNav) {  //有发言权限，变成3个按钮
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,4*(btnWidth+btnMargin), btnHeight)];
        //视频按钮
        UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        videoButton.frame = CGRectMake(2*btnMargin+btnWidth, 0, btnWidth, btnHeight);
        [videoButton setImage:[UIImage imageNamed:videoImage] forState:UIControlStateNormal];
        [videoButton setImage:[UIImage imageNamed:videoImageSelected] forState:UIControlStateHighlighted];
        [videoButton addTarget:self action:@selector(onSelfVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
        //音频按钮
        UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        audioButton.frame = CGRectMake(3*btnMargin+2*btnWidth, 0, btnWidth, btnHeight);
        [audioButton setImage:[UIImage imageNamed:audioImage] forState:UIControlStateNormal];
        [audioButton setImage:[UIImage imageNamed:audioImageSelected] forState:UIControlStateHighlighted];
        [audioButton addTarget:self action:@selector(onSelfAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
        //结束按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(4*btnMargin+3*btnWidth, 0, btnWidth, btnHeight);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom_selected"] forState:UIControlStateHighlighted];

        cancelButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [cancelButton setTitle:@"结束" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onCancelInteraction:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = 10001;

        [rightView addSubview:audioButton];
        [rightView addSubview:videoButton];
        [rightView addSubview:cancelButton];

        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        NSMutableArray *arrayItems=[NSMutableArray array];
        [arrayItems addObject:negativeSpacer];
        [arrayItems addObject:rightItem];
        negativeSpacer.width = -btnMargin;
        self.navigationItem.rightBarButtonItems = arrayItems;

    }
    else
    {
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2*(btnWidth+btnMargin), btnHeight)];
        //互动按钮
        UIButton *raiseHandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        raiseHandButton.frame = CGRectMake(btnWidth+2*btnMargin, 0, btnWidth, btnHeight);
            
        if (!myRole.isRaisingHand) {
            [raiseHandButton setImage:[UIImage imageNamed:@"chatroom_interaction"] forState:UIControlStateNormal];
            [raiseHandButton setImage:[UIImage imageNamed:@"chatroom_interaction_selected"] forState:UIControlStateHighlighted];
        }
        else{
            [raiseHandButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom"] forState:UIControlStateNormal];
            [raiseHandButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom_selected"] forState:UIControlStateHighlighted];
            raiseHandButton.titleLabel.font = [UIFont systemFontOfSize:11];
            [raiseHandButton setTitle:@"取消" forState:UIControlStateNormal];
        }
        
        [raiseHandButton addTarget:self action:@selector(onRaiseHandPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:raiseHandButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];

        NSMutableArray *arrayItems=[NSMutableArray array];
        [arrayItems addObject:negativeSpacer];
        [arrayItems addObject:rightItem];
        negativeSpacer.width = -btnMargin;
        self.navigationItem.rightBarButtonItems = arrayItems;
    }
}

- (void)onBack:(id)sender
{
    CSSMeetingRole *myRole = [[CSSMeetingRolesManager sharedInstance] myRole];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出直播吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                if (myRole.isManager ) {
                    [self requestCloseChatRoom];
                }
                [self pop];
                break;
            }
                
            default:
                break;
        }
    }];
}
-(void)onCancelInteraction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出互动么？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                [self onRaiseHandPressed:sender];
                break;
            }
                
            default:
                break;
        }
    }];
}

- (void)onRaiseHandPressed:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    CSSMeetingRole *myRole = [[CSSMeetingRolesManager sharedInstance] myRole];
    if (btn.tag == 10001) {
        [[NIMAVChatSDK sharedSDK].netCallManager setMeetingRole:NO];
        myRole.isActor = NO;
        myRole.isRaisingHand = YES;
        myRole.videoOn = NO;
        myRole.audioOn = NO;
        myRole.whiteboardOn = NO;
    }
    [[CSSMeetingRolesManager sharedInstance] changeRaiseHand];
}

//右上角按钮点击事件
- (void)onSelfVideoPressed:(id)sender
{
    BOOL videoIsOn = [CSSMeetingRolesManager sharedInstance].myRole.videoOn;
    
    [[CSSMeetingRolesManager sharedInstance] setMyVideo:!videoIsOn];
}

- (void)onSelfAudioPressed:(id)sender
{
    BOOL audioIsOn = [CSSMeetingRolesManager sharedInstance].myRole.audioOn;
    
    [[CSSMeetingRolesManager sharedInstance] setMyAudio:!audioIsOn];
}

//成员列表划出动画
- (void)onSelfMemberPressed:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        if (_isMemberListHide) {
            self.memberListVC.view.frame = CGRectMake(UIScreenWidth - UIScreenWidth *0.8, 0, UIScreenWidth *0.8, 300);
            self.memberButton.frame = CGRectMake(UIScreenWidth - UIScreenWidth *0.8 - 30, 0, 30, 30);
        }else{
            self.memberListVC.view.frame = CGRectMake(UIScreenWidth, 0, UIScreenWidth *0.8, 300);
            self.memberButton.frame = CGRectMake(UIScreenWidth - 30, 0, 30, 30);
        }
    } completion:^(BOOL finished) {
        _isMemberListHide = !_isMemberListHide;
        [self.memberListVC refresh];
    }];
}

- (void)onSelfInvitePressed:(id)sender{
    MessgeAddressListViewController *vc = [[MessgeAddressListViewController alloc]init];
    vc.delegate = self;
    vc.isSingleSelect = false;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma makr -MessgeAddressListDelegate

- (void)addFriendWithDataSource:(NSArray<NSString *> *)dataSource{
#warning tyx
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (TxlModel1_oc *data in VideoMeetingManager.shareInstance.meettingPersons) {
        [array addObject:data.ryxm];
    }
    
    for (NSString *ID in dataSource) {
        
        
        NSString *initiator = VideoMeetingManager.shareInstance.initiator;
        NSString *title = VideoMeetingManager.shareInstance.title;
        NSString *time = VideoMeetingManager.shareInstance.time;
        
        //构造消息
        NIMMessage *message = [[NIMMessage alloc] init];
        message.text =  [NSString stringWithFormat:@"您收到一条视频会议邀请:\n会议发起人: %@\n会议标题:%@\n预计时长: %@\n会议房间号码: %@",initiator,title,time,_chatroom.roomId];
        message.remoteExt = @{@"ID":_chatroom.roomId,@"initiator":initiator,@"time":time,@"title":title,@"person":array};
        //构造会话
        NIMSession *session = [NIMSession session:ID type:NIMSessionTypeP2P];
        //发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    }
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    [self.navigationController popViewControllerAnimated:vc];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"会议邀请已发出" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)requestCloseChatRoom
{
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    
    [[CSSDemoService sharedService] closeChatRoom:_chatroom.roomId creator:_chatroom.creator completion:^(NSError *error, NSString *roomId) {
        [SVProgressHUD dismiss];
        if (error) {
            [wself.view makeToast:@"结束房间失败" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)requestChatRoomInfo
{
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:_chatroom.roomId completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom) {
        if (!error) {
            if([wself showFullScreenBtn:chatroom.ext])
            {
                wself.actorsView.showFullScreenBtn = YES;
            }
        }
        else
        {
            [wself.view makeToast:@"获取聊天室信息失败" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}


- (void)removeActorSelectView
{
    if (self.actorSelectView) {
        [self.actorSelectView removeFromSuperview];
        self.actorSelectView = nil;
    }
}

- (void)pop
{
    if (!self.isPoped) {
        self.isPoped = YES;
       [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Rotate supportedInterfaceOrientations
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - CSInputActionDelegate
- (void)onTapMediaItem:(CSMediaItem *)item{}

- (void)onTextChanged:(id)sender{}

- (void)onSendText:(NSString *)text
{
    NIMMessage *message = [CSMessageMaker msgWithText:text];
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:self.chatroomViewController.session error:nil];
}

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId{}

- (void)onCancelRecording
{
//    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (void)onStopRecording
{
//    [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (void)onStartRecording
{
    self.inputView.recording = YES;
//    [[[NIMSDK sharedSDK] mediaManager] addDelegate:self];
//    [[NIMSDK sharedSDK].mediaManager recordForDuration:60.f];
}

@end
