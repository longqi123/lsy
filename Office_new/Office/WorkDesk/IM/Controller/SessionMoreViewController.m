//
//  SessionMoreTableViewController.m
//  Office
//
//  Created by roger on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "SessionMoreViewController.h"
#import "SessionMoreTableViewCell.h"
#import "NIMContactSelectViewController.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "NTESContactAddFriendViewController.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESTeamListViewController.h"
#import "FPPopoverController.h"
#import <CoreFramework/CoreFramework-umbrella.h>
#import "NTESSessionViewController.h"

@interface SessionMoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SessionMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorColor = UIColor.clearColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SessionMoreTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SessionMoreTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SessionMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionMoreTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.title.text = @"发起聊天";
        cell.leftImageView.image = [UIImage imageNamed:@"fa_qi_liao_tian"];
    }else{
        cell.title.text = @"发起群聊";
        cell.leftImageView.image = [UIImage imageNamed:@"fa_qi_qun_liao"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        if ([self.delegate respondsToSelector:@selector(startChat)]) {
            [self.delegate startChat];
            [self.popover dismissPopoverAnimated:NO];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(startSession)]) {
            [self.delegate startSession];
            [self.popover dismissPopoverAnimated:NO];
        }
        
        NTESAdvancedTeamListViewController *vc = [[NTESAdvancedTeamListViewController alloc] initWithNibName:nil bundle:nil];
        [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:self] animated:YES completion:nil];

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


@end
