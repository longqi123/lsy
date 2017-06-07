//
//  NTESTeamListViewController.m
//  NIM
//
//  Created by Xuhui on 15/3/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESTeamListViewController.h"
#import "NTESSessionViewController.h"

//新增
#import "NIMContactSelectViewController.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "NTESContactAddFriendViewController.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESContactViewController.h"
#import "CreatNewSessionCell.h"
#import "SessionCell.h"
#import "Office-Swift.h"

@interface NTESTeamListViewController () <UITableViewDelegate, UITableViewDataSource,NIMTeamManagerDelegate,MessgeAddressListDelegate> {
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *myTeams;

@end

@implementation NTESTeamListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTeams = [self fetchTeams];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreatNewSessionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreatNewSessionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SessionCell"];

    self.tableView.estimatedRowHeight = 85;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
}

- (NSMutableArray *)fetchTeams{
    //subclass override
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myTeams.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CreatNewSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatNewSessionCell"];
        if(!cell) {
            cell = [[CreatNewSessionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CreatNewSessionCell"];
        }
        return cell;
    }else{
        SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
        if(!cell) {
            cell = [[SessionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SessionCell"];
        }
        NIMTeam *team = [_myTeams objectAtIndex:indexPath.row - 1];
        cell.sessionName.text = team.teamName;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 85;
    }else{
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        
        MessgeAddressListViewController *vc = [[MessgeAddressListViewController alloc]init];
        vc.delegate = self;
        vc.isSingleSelect = false;
        vc.PersonMaxiNum = 50;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        NIMTeam *team = [_myTeams objectAtIndex:indexPath.row - 1];
        NIMSession *session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        [self.navigationController pushViewController:vc animated:YES];
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in array) {
            if ([vc isKindOfClass:[NTESTeamListViewController class]]) {
                [array removeObject:vc];
                break;
            }
        }
        self.navigationController.viewControllers = array;
    }
}


- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
}

#pragma makr -MessgeAddressListDelegate

- (void)addFriendWithDataSource:(NSArray<NSString *> *)dataSource{
    
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:dataSource];
    
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.name       = @"新建群聊";
    option.type       = NIMTeamTypeAdvanced;
    option.joinMode   = NIMTeamJoinModeNoAuth;
    option.postscript = @"邀请你加入群组";
    option.beInviteMode = NIMTeamBeInviteModeNoAuth;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId) {
        [SVProgressHUD dismiss];
        if (!error) {
            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            for (UIViewController *vc in array) {
                if ([vc isKindOfClass:[MessgeAddressListViewController class]]) {
                    [array removeObject:vc];
                    break;
                }
            }
            self.navigationController.viewControllers = array;
        }else{
            if (error.code == 404) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"创建失败" message:@"被选定的用户只有登录过该应用，才能创建群聊" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        
        }
    }];
}

@end



@implementation NTESAdvancedTeamListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"NTESTeamListViewController" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"发起群聊";
}

- (NSMutableArray *)fetchTeams{
    NSMutableArray *myTeams = [[NSMutableArray alloc]init];
    for (NIMTeam *team in [NIMSDK sharedSDK].teamManager.allMyTeams) {
        if (team.type == NIMTeamTypeAdvanced) {
            [myTeams addObject:team];
        }
    }
    return myTeams;
}

- (void)onTeamAdded:(NIMTeam *)team{
    if (team.type == NIMTeamTypeAdvanced) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

- (void)onTeamUpdated:(NIMTeam *)team{
    if (team.type == NIMTeamTypeAdvanced) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}


- (void)onTeamRemoved:(NIMTeam *)team{
    if (team.type == NIMTeamTypeAdvanced) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

@end


@implementation NTESNormalTeamListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"NTESTeamListViewController" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"讨论组";
}

- (NSMutableArray *)fetchTeams{
    NSMutableArray *myTeams = [[NSMutableArray alloc]init];
    for (NIMTeam *team in [NIMSDK sharedSDK].teamManager.allMyTeams) {
        if (team.type == NIMTeamTypeNormal) {
            [myTeams addObject:team];
        }
    }
    return myTeams;
}

- (void)onTeamUpdated:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}


- (void)onTeamRemoved:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

- (void)onTeamAdded:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

@end
