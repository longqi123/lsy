//
//  CSSEnterRoomViewController.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/6.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSEnterRoomViewController.h"
#import "CSSLoginManager.h"
#import "CSSLoginViewController.h"
#import "CSSMeetingRoomSearchViewController.h"
#import "CSSMeetingRoomCreateViewController.h"
#import "CSSPageContext.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import "CSSLogManager.h"
#import "CSSBundleSetting.h"
#import <CoreFramework/CoreFramework-umbrella.h>
#import "CreatSessionViewController.h"

@interface CSSEnterRoomViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong) IBOutlet UIButton *createRoomButton;

@property (nonatomic,strong) IBOutlet UIButton *searchRoomButton;

@property (weak, nonatomic) IBOutlet UILabel *accidLabel;

@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@property (weak, nonatomic) IBOutlet UIView *testerToolView;


@end

@implementation CSSEnterRoomViewController

NTES_USE_CLEAR_BAR

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImage *backgroundImageNormal = [[UIImage imageNamed:@"btn_round_rect_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
//    UIImage *backgroundImageHighlighted = [[UIImage imageNamed:@"btn_round_rect_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
//    
//    [self.createRoomButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
//    [self.createRoomButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
//    [self.searchRoomButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
//    [self.searchRoomButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
//    
//    CGFloat spacing = 7;
//    self.createRoomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
//    self.createRoomButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
//    
//    self.searchRoomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
//    self.searchRoomButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    self.createRoomButton.backgroundColor = UIColor.B1;
    self.createRoomButton.titleLabel.textColor = UIColor.T6;
    self.createRoomButton.titleLabel.font = UIFont.H2;

    self.searchRoomButton.backgroundColor = UIColor.B1;
    self.searchRoomButton.titleLabel.textColor = UIColor.T6;
    self.searchRoomButton.titleLabel.font = UIFont.H2;
    
    self.accidLabel.text = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    [self configTesterToolUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configNav];
    [self configStatusBar];
}

- (IBAction)onCreateMeetingRoom:(id)sender {
//    CSSMeetingRoomCreateViewController *vc = [[CSSMeetingRoomCreateViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    CreatSessionViewController *vc = [[CreatSessionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)onSearchMeetingRoom:(id)sender {
    CSSMeetingRoomSearchViewController *vc = [[CSSMeetingRoomSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchLogout:(id)sender
{
    [[NIMSDK sharedSDK].loginManager logout:^(NSError *error) {
        [[CSSLoginManager sharedManager] setCurrentNTESLoginData:nil];
        [[CSSPageContext sharedInstance] setupMainViewController];
    }];
}

- (IBAction)onShareIMLog:(id)sender {
    [self openDocumentController:[[NIMSDK sharedSDK] currentLogFilepath]];
}

- (IBAction)onShareDemoLog:(id)sender {
    [self openDocumentController:[[CSSLogManager sharedManager] currentLogPath]];
}
- (IBAction)onShareRTCLog:(id)sender {
    [self openDocumentController:[[NIMAVChatSDK sharedSDK].netCallManager netCallLogFilepath]];
}

- (void)openDocumentController:(NSString *)filePath
{
    self.documentController =  [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    self.documentController.delegate = self;
    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller
          didEndSendingToApplication:(NSString *)application

{
    self.documentController = nil;
}


- (void)configNav{
    self.navigationItem.title = @"视频会议";
    self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.view.backgroundColor = UIColor.B2;
//    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
//    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    [logoutBtn setTitleColor:UIColorFromRGB(0x2294ff) forState:UIControlStateNormal];
//    
//    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_round_rect_normal"] forState:UIControlStateNormal];
//    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_round_rect_pressed"] forState:UIControlStateHighlighted];
//    [logoutBtn addTarget:self action:@selector(onTouchLogout:) forControlEvents:UIControlEventTouchUpInside];
//    [logoutBtn sizeToFit];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    
//    NSShadow *shadow = [[NSShadow alloc]init];
//    shadow.shadowOffset = CGSizeMake(0, 0);
}

- (void)configStatusBar{
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}

- (void)configTesterToolUI
{
    _testerToolView.hidden = ![[CSSBundleSetting sharedConfig] testerToolUI];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
