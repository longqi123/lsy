//
//  CSSMeetingRoomSearchViewController.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/7.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSMeetingRoomSearchViewController.h"
#import "CSSCommonTableDelegate.h"
#import "CSSCommonTableData.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "CSSMeetingViewController.h"
#import "CSSMeetingManager.h"
#import "CSSMeetingRolesManager.h"

@interface CSSMeetingRoomSearchViewController ()

@property (nonatomic,strong) CSSCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,assign) NSInteger               inputLimit;

@property (nonatomic,copy  ) NSString                *roomId;

@end

@implementation CSSMeetingRoomSearchViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _inputLimit = 13;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    __weak typeof(self) wself = self;
    [self buildData];
    self.delegator = [[CSSCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self.tableView reloadData];
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView becomeFirstResponder];
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes =@{
                                                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpNav{
    self.navigationItem.title = @"加入会议室";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)onDone:(id)sender{
    [self.view endEditing:YES];
    if (!self.roomId.length) {
        [self.view makeToast:@"会议室ID不能为空" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (self.roomId.length > self.inputLimit) {
        [self.view makeToast:@"会议室ID过长" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = self.roomId;
    [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];
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

- (void)buildData{
    self.roomId = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedRoom"];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"请输入房间ID号",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : self.roomId.length? self.roomId : @"",
                                      CellClass     : @"CSSTextSettingCell",
                                      RowHeight     : @(50),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      ];
    self.data = [NTESCommonTableSection sectionsWithData:data];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self onDone:nil];
    }
    // 如果是删除键
    if ([string length] == 0 && range.length > 0)
    {
        return YES;
    }
    NSString *genString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.inputLimit && genString.length > self.inputLimit) {
        return NO;
    }
    return YES;
}


- (void)onTextFieldChanged:(NSNotification *)notification{
    UITextField *textField = notification.object;
    self.roomId = textField.text;
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

@end
