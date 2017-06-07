//
//  CreatSessionViewController.m
//  Office
//
//  Created by roger on 2017/5/22.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "CreatSessionViewController.h"
#import "CreatSessionCell.h"
#import <CoreFramework/CoreFramework-umbrella.h>
#import "Office-Swift.h"
#import "VideoMeetingManager.h"


#import "CSSMeetingRoomCreateViewController.h"
#import "CSSCommonTableDelegate.h"
#import "CSSCommonTableData.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "CSSMeetingViewController.h"
#import "CSSMeetingManager.h"
#import "CSSDemoService.h"
#import "CSSTextSettingCell.h"
#import "CSSMeetingRolesManager.h"
#import <NIMAVChat/NIMAVChat.h>

@interface CreatSessionViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CreatSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.clearColor;
    self.title = @"创建视频会议";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 64)];
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor.B2;

    [_tableView registerNib:[UINib nibWithNibName:@"CreatSessionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreatSessionCell"];
    [_tableView registerClass:[NotificationPersonCell4 class] forCellReuseIdentifier:@"NotificationPersonCell4"];
    [_tableView registerClass:[NotificationPersonCell class] forCellReuseIdentifier:@"NotificationPersonCell"];

    _tableView.estimatedRowHeight = 90;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, UIScreenHeight - 49 - 64, UIScreenWidth, 49)];
    _bottomBtn.backgroundColor = UIColor.B1;
    _bottomBtn.titleLabel.font = UIFont.H2;
    [_bottomBtn setTitleColor:UIColor.T6 forState:UIControlStateNormal];
    [_bottomBtn setTitle:@"立即发起" forState:UIControlStateNormal];
    [_bottomBtn addTarget:self action:@selector(bottomBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
}

- (void)dealloc{
    NSLog(@"释放");
}

#pragma mark - Action
- (void)bottomBtnClicked{
    [self.view endEditing:YES];
    if ([self validate]) {
        [self requestChatRoom];
    }
}

#pragma mark - private

- (BOOL)validate
{
    if (!VideoMeetingManager.shareInstance.initiator.length) {
        [self.view makeToast:@"会议发起人不能为空" duration:2.0 position:CSToastPositionCenter];
        return NO;
    }
    if (VideoMeetingManager.shareInstance.title.length > 20) {
        [self.view makeToast:@"会议标题过长" duration:2.0 position:CSToastPositionCenter];
        return NO;
    }
    return YES;
}

- (void)requestChatRoom
{
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    
    [[CSSDemoService sharedService] requestChatRoom:VideoMeetingManager.shareInstance.title
                                         completion:^(NSError *error, NSString *meetingRoomID)
     {
         [SVProgressHUD dismiss];
         if (!error){
             [self reserveNetCallMeeting:meetingRoomID];
         }
         else
         {
             [wself.view makeToast:@"创建聊天室失败，请重试" duration:2.0 position:CSToastPositionCenter];
         }
     }];
}

- (void)reserveNetCallMeeting:(NSString *)roomId
{
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    meeting.name = roomId;
    meeting.type = NIMNetCallTypeVideo;
    meeting.ext = @"test extend meeting messge";
    
    [SVProgressHUD show];
    
    [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [self enterChatRoom:roomId];
        }
        else {
            [self.view makeToast:@"分配视频会议失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)enterChatRoom:(NSString *)roomId
{
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = roomId;
    [SVProgressHUD show];
    
    __weak typeof(self) wself = self;
    
    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *room, NIMChatroomMember *me) {
        [SVProgressHUD dismiss];
        if (!error) {
            [[CSSMeetingManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
            [[CSSMeetingRolesManager sharedInstance] startNewMeeting:me withChatroom:room newCreated:YES];
            CSSMeetingViewController *vc = [[CSSMeetingViewController alloc] initWithChatroom:room];
            self.hidesBottomBarWhenPushed = true;
            [wself.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = false;
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (TxlModel1_oc *data in VideoMeetingManager.shareInstance.meettingPersons) {
                [array addObject:data.ryxm];
            }
            
            
            for (TxlModel1_oc *data in self.dataSource) {
                
                NSString *initiator = VideoMeetingManager.shareInstance.initiator;
                NSString *title = VideoMeetingManager.shareInstance.title;
                NSString *time = VideoMeetingManager.shareInstance.time;

                //构造消息
                NIMMessage *message = [[NIMMessage alloc] init];
                message.text =  [NSString stringWithFormat:@"您收到一条视频会议邀请:\n会议发起人: %@\n会议标题:%@\n预计时长: %@\n会议房间号码: %@",initiator,title,time,request.roomId];
                message.remoteExt = @{@"ID":request.roomId,@"initiator":initiator,@"time":time,@"title":title,@"person":array};
                //构造会话
                NIMSession *session = [NIMSession session:data.jsrydm type:NIMSessionTypeP2P];
                //发送消息
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                
            }
        }
        else
        {
            [wself.view makeToast:@"进入会议失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 40;
        }else{
            NSInteger num = self.dataSource.count/6;
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
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            CreatSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatSessionCell" forIndexPath:indexPath];
            [cell setTitle:@"会议发起人" placeholder:@"请输入发起人名称"];
            cell.creatTextField.delegate = self;
            cell.creatTextField.tag = 0;
            return cell;
            
        }else if (indexPath.row == 1) {
            CreatSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatSessionCell" forIndexPath:indexPath];
            [cell setTitle:@"会议标题" placeholder:@"请输入标题"];
            cell.creatTextField.delegate = self;
            cell.creatTextField.tag = 1;

            return cell;
            
        }else if (indexPath.row == 2) {
            CreatSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatSessionCell" forIndexPath:indexPath];
            [cell setTitle:@"预计时长" placeholder:@"请输入时长"];
            cell.creatTextField.delegate = self;
            cell.creatTextField.tag = 2;

            return cell;
        }else{
            return [[UITableViewCell alloc]init];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            NotificationPersonCell4 *cell = [[NSBundle mainBundle]loadNibNamed:@"NotificationPersonCell4" owner:self options:nil].firstObject;
            cell.title.textColor = UIColor.T2;
            cell.title.font = UIFont.H3;
            [cell.title setText:@"添加人员"];
            [cell.switck setHidden:YES];
            return cell;
        }else{
            NotificationPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationPersonCell" forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;
            __weak typeof(cell) weakCell = cell;

            cell.personClick_oc = ^(NSArray *dataArr){
                MessgeAddressListViewController *vc = [[MessgeAddressListViewController alloc]init];
                vc.isSingleSelect = false;
                [vc changeClassWithArray:self.dataSource];
                vc.AddFringBlock_oc = ^(NSArray *array){
                    weakSelf.dataSource = [[NSMutableArray alloc]initWithArray:array];
                    [weakCell changeClassWithArray:self.dataSource];
                    [weakCell reload];
                    [weakSelf.tableView reloadData];
                    VideoMeetingManager.shareInstance.meettingPersons = self.dataSource;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.deleteClick_oc = ^(NSArray *array){
                weakSelf.dataSource = [[NSMutableArray alloc]initWithArray:array];
                VideoMeetingManager.shareInstance.meettingPersons = self.dataSource;
                [weakSelf.tableView reloadData];
            };
            return cell;
        }
    }
    return [[UITableViewCell alloc]init];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    VideoMeetingManager *manager = VideoMeetingManager.shareInstance;
    if (textField.tag == 0) {
        manager.initiator = textField.text;
    }else if (textField.tag == 1){
        manager.title = textField.text;
    }else if (textField.tag == 2){
        manager.time = textField.text;
    }
    return YES;
}

@end