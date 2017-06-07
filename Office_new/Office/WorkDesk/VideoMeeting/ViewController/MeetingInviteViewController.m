//
//  MeetingInviteViewController.m
//  Office
//
//  Created by roger on 2017/6/6.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MeetingInviteViewController.h"
#import <CoreFramework/CoreFramework-Swift.h>
#import "Office-Swift.h"
#import "VideoMeetingManager.h"

#import "SVProgressHUD.h"
#import "CSSMeetingViewController.h"
#import "CSSMeetingManager.h"
#import "CSSMeetingRolesManager.h"
#import "UIView+Toast.h"
#import "MeetingInviteViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface MeetingInviteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UIView *fistLineView;
@property (weak, nonatomic) IBOutlet UILabel *initiator;
@property (weak, nonatomic) IBOutlet UILabel *initiatorDesc;
@property (weak, nonatomic) IBOutlet UILabel *meetingTitle;
@property (weak, nonatomic) IBOutlet UILabel *meetingTitleDesc;
@property (weak, nonatomic) IBOutlet UILabel *meetingTime;
@property (weak, nonatomic) IBOutlet UILabel *meetingTimeDesc;
@property (weak, nonatomic) IBOutlet UILabel *meetingNumber;
@property (weak, nonatomic) IBOutlet UILabel *meetingNumberDesc;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondLineView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UILabel *meettingPerson;
@property (weak, nonatomic) IBOutlet UIScrollView *csrollview;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *OkBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomMidLine;

@end

@implementation MeetingInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频会议邀请";
    //set color
    _messageTitle.textColor = UIColor.T2;
    _messageTitle.font = UIFont.H3;
    _fistLineView.backgroundColor = UIColor.L1;
    _secondLineView.backgroundColor = UIColor.L1;

    _initiator.textColor = UIColor.T2;
    _initiator.font = UIFont.H3;
    
    _initiatorDesc.textColor = UIColor.T3;
    _initiatorDesc.font = UIFont.H5;
    
    _meetingTitle.textColor = UIColor.T2;
    _meetingTitle.font = UIFont.H3;
    
    _meetingTitleDesc.textColor = UIColor.T3;
    _meetingTitleDesc.font = UIFont.H5;
    
    _meetingTime.textColor = UIColor.T2;
    _meetingTime.font = UIFont.H3;
    
    _meetingTimeDesc.textColor = UIColor.T3;
    _meetingTimeDesc.font = UIFont.H5;
    
    _meetingNumber.textColor = UIColor.T2;
    _meetingNumber.font = UIFont.H3;
    
    _meetingNumberDesc.textColor = UIColor.T3;
    _meetingNumberDesc.font = UIFont.H5;
    
    _meettingPerson.textColor = UIColor.T2;
    _meettingPerson.font = UIFont.H3;
    
    _bottomLineView.backgroundColor = UIColor.L1;
    _bottomMidLine.backgroundColor =  UIColor.L1;
    
    [_cancelBtn setTitleColor:UIColor.T7 forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:UIFont.H2];
    
    [_OkBtn setTitleColor:UIColor.T7 forState:UIControlStateNormal];
    [_OkBtn.titleLabel setFont:UIFont.H2];
    
    //set tableview
    CGFloat height;
    NSInteger num = VideoMeetingManager.shareInstance.meettingPersons.count/6;
    if (num < 1){
        height = 60;
    }else if (num == 1){
        height = 120;
    }else if (num == 2){
        height = 180;
    }else{
        height = 240;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _firstView.bounds.size.height + _secondView.bounds.size.height + _thirdView.bounds.size.height, UIScreenWidth, height)];
    [_tableView registerClass:[NotificationPersonCell self] forCellReuseIdentifier:@"NotificationPersonCell"];
    _tableView.estimatedRowHeight = 80;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_csrollview addSubview:_tableView];
    
    //set data
    _initiatorDesc.text = [self.message.remoteExt objectForKey:@"initiator"];
    _meetingTitleDesc.text = [self.message.remoteExt objectForKey:@"title"];
    _meetingTimeDesc.text = [self.message.remoteExt objectForKey:@"time"];
    NSArray *array = [self.message.remoteExt objectForKey:@"person"];
    
    _dataSource = [[NSMutableArray alloc]init];
    for (NSString *str in array) {
        TxlModel1_oc *data = [[TxlModel1_oc alloc]init];
        data.ryxm = str;
        data.jsrydm = @"1";
        [self.dataSource addObject:data];
    }
}

- (void)setDataSource:(NIMMessage *)dataSource{
    self.message = dataSource;
    NSLog(@"%@",[dataSource.remoteExt objectForKey:@"initiator"]);
}

#pragma mark -action
- (IBAction)cancelBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)okBtnClicked:(id)sender {
    
        NSString *ID = [self.message.remoteExt objectForKey:@"ID"];
        if (ID == nil) {
            return;
        }else{
            [SVProgressHUD show];
            __weak typeof(self) wself = self;
    
            NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
            request.roomId = ID;
            [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"cachedRoom"];
            [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *chatroom, NIMChatroomMember *me) {
                [SVProgressHUD dismiss];
                if (!error) {
                    [[CSSMeetingManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
                    [[CSSMeetingRolesManager sharedInstance] startNewMeeting:me withChatroom:chatroom newCreated:NO];
                    UINavigationController *nav = wself.navigationController;
                    CSSMeetingViewController *vc = [[CSSMeetingViewController alloc] initWithChatroom:chatroom];
                    [nav pushViewController:vc animated:YES];
                    NSMutableArray *vcs = [nav.viewControllers mutableCopy];
                    [vcs removeObject:self];
                    nav.viewControllers = vcs;
                }else {
                    [self.view makeToast:@"进入房间失败，请确认ID是否正确" duration:2.0 position:CSToastPositionCenter];
                }
            }];
        }
}
#pragma makr - delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger num = VideoMeetingManager.shareInstance.meettingPersons.count/6;
    if (num < 1){
        return 60;
    }else if (num == 1){
        return 120;
    }else if (num == 2){
        return 180;
    }else{
        return 240;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationPersonCell" forIndexPath:indexPath];
    [cell setViewHidden];
    [cell changeClassWithArray:_dataSource];
    [cell.mycolectionView reloadData];
    return cell;
}


@end
