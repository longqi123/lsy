//
//  CSContactSelectViewController.m
//  CSKit
//
//  Created by chris on 15/9/14.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSContactSelectViewController.h"
#import "CSContactSelectTabView.h"
#import "CSContactPickedView.h"
#import "CSGroupedUsrInfo.h"
#import "CSGroupedDataCollection.h"
#import "CSContactDataCell.h"
#import "UIView+CS.h"
#import "CSKit.h"
#import "UIView+CSKitToast.h"

@interface CSContactSelectViewController ()<UITableViewDataSource, UITableViewDelegate, CSContactPickedViewDelegate>{
    NSMutableArray *_selectecContacts;
}
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) CSContactSelectTabView *selectIndicatorView;

@property (nonatomic, assign) NSInteger maxSelectCount;

@property (nonatomic, assign) CSContactSelectType selectType;

@property (nonatomic, strong) CSGroupedDataCollection *data;

@end

@implementation CSContactSelectViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _maxSelectCount = NSIntegerMax;
    }
    return self;
}

- (instancetype)initWithConfig:(id<CSContactSelectConfig>) config{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.selectIndicatorView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.title = [self.config respondsToSelector:@selector(title)] ? [self.config title] : @"选择联系人";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelBtnClick:)];
    self.selectIndicatorView.pickedView.delegate = self;
    [self.selectIndicatorView.doneButton addTarget:self action:@selector(onDoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.selectIndicatorView.nim_width = self.view.nim_width;
    self.tableView.nim_height = self.view.nim_height - self.selectIndicatorView.nim_height;
    self.selectIndicatorView.nim_bottom = self.view.nim_height;
}

- (void)show{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:self] animated:YES completion:nil];
}

- (void)setConfig:(id<CSContactSelectConfig>)config{
    _config = config;
    if ([config respondsToSelector:@selector(maxSelectedNum)]) {
        _maxSelectCount = [config maxSelectedNum];
    }
    [self makeData];
}

- (void)onCancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^() {
        if (self.cancelBlock) {
            self.cancelBlock();
            self.cancelBlock = nil;
        }
        if([_delegate respondsToSelector:@selector(didCancelledSelect)]) {
            [_delegate didCancelledSelect];
        }
    }];
}

- (IBAction)onDoneBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^() {
        if (self.finshBlock) {
            self.finshBlock(_selectecContacts);
            self.finshBlock = nil;
        }
        if([_delegate respondsToSelector:@selector(didFinishedSelect:)]) {
            [_delegate didFinishedSelect:_selectecContacts];
        }
    }];
}


- (void)makeData{
    self.selectType = NIMContactSelectTypeFriend;
    if ([self.config respondsToSelector:@selector(selectType)]) {
        self.selectType = [self.config selectType];
    }
    switch (self.selectType) {
        case NIMContactSelectTypeFriend:{
            NSMutableArray *data = [[NIMSDK sharedSDK].userManager.myFriends mutableCopy];
            NSMutableArray *myFriendArray = [[NSMutableArray alloc] init];
            for (NIMUser *user in data) {
                [myFriendArray addObject:user.userId];
            }
            NSArray *uids = [self filterData:myFriendArray];
            self.data = [self makeUserInfoData:uids];
            break;
        }
        case NIMContactSelectTypeTeamMember:{
            if ([self.config respondsToSelector:@selector(teamId)]) {
                NSString *teamId = [self.config teamId];
                __weak typeof(self) wself = self;
                [[NIMSDK sharedSDK].teamManager fetchTeamMembers:teamId completion:^(NSError *error, NSArray *members) {
                    if (!error) {
                        NSMutableArray *data = [[NSMutableArray alloc] init];
                        for (NIMTeamMember *member in members) {
                            [data addObject:member.userId];
                        }
                        NSArray *uids = [wself filterData:data];
                        wself.data = [wself makeTeamMemberInfoData:uids teamId:teamId];
                    }
                }];
            }
            break;
        }
        case NIMContactSelectTypeTeam:{
            NSMutableArray *teams = [[NSMutableArray alloc] init];
            NSMutableArray *data = [[NIMSDK sharedSDK].teamManager.allMyTeams mutableCopy];
            for (NIMTeam *team in data) {
                [teams addObject:team.teamId];
            }
            NSArray *uids = [self filterData:teams];
            self.data = [self makeTeamInfoData:uids];
            break;
        }
        default:
            break;
    }
    if ([self.config respondsToSelector:@selector(alreadySelectedMemberId)]) {
        _selectecContacts = [[self.config alreadySelectedMemberId] mutableCopy];
    }
    _selectecContacts = _selectecContacts.count ? _selectecContacts : [NSMutableArray array];
    for (NSString *selectId in _selectecContacts) {
        CSKitInfo *info;
        if (self.selectType == NIMContactSelectTypeTeam) {
            info = [[CSKit sharedKit] infoByTeam:selectId];
        }else{
            info = [[CSKit sharedKit] infoByUser:selectId];
        }
        [self.selectIndicatorView.pickedView addMemberInfo:info];
    }
}

- (NSArray *)filterData:(NSMutableArray *)data{
    if (data) {
        if ([self.config respondsToSelector:@selector(filterIds)]) {
            NSArray *ids = [self.config filterIds];
            [data removeObjectsInArray:ids];
        }
        return data;
    }
    return nil;
}

- (CSGroupedDataCollection *)makeUserInfoData:(NSArray *)uids{
    CSGroupedDataCollection *collection = [[CSGroupedDataCollection alloc] init];
    NSMutableArray *members = [[NSMutableArray alloc] init];
    for (NSString *uid in uids) {
        CSGroupUser *user = [[CSGroupUser alloc] initWithUserId:uid];
        [members addObject:user];
    }
    collection.members = members;
    return collection;
}

- (CSGroupedDataCollection *)makeTeamMemberInfoData:(NSArray *)uids teamId:(NSString *)teamId{
    CSGroupedDataCollection *collection = [[CSGroupedDataCollection alloc] init];
    NSMutableArray *members = [[NSMutableArray alloc] init];
    for (NSString *uid in uids) {
        CSGroupTeamMember *user = [[CSGroupTeamMember alloc] initWithUserId:uid teamId:teamId];
        [members addObject:user];
    }
    collection.members = members;
    return collection;
}

- (CSGroupedDataCollection *)makeTeamInfoData:(NSArray *)teamIds{
    CSGroupedDataCollection *collection = [[CSGroupedDataCollection alloc] init];
    NSMutableArray *members = [[NSMutableArray alloc] init];
    for (NSString *teamId in teamIds) {
        CSGroupTeam *team = [[CSGroupTeam alloc] initWithTeam:teamId];
        [members addObject:team];
    }
    collection.members = members;
    return collection;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data groupCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data memberCountOfGroup:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.data titleOfGroup:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<CSGroupMemberProtocol> contactItem = [self.data memberOfIndex:indexPath];
    CSContactDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectContactCellID"];
    if (cell == nil) {
        cell = [[CSContactDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectContactCellID"];
    }
    cell.accessoryBtn.hidden = NO;
    cell.accessoryBtn.selected = [_selectecContacts containsObject:[contactItem memberId]];
    if (self.selectType == NIMContactSelectTypeTeam) {
        [cell refreshTeam:contactItem];
    }else{
        [cell refreshUser:contactItem];
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.data sortedGroupTitles];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<CSGroupMemberProtocol> member = [self.data memberOfIndex:indexPath];
    NSString *memberId = [(id<CSGroupMemberProtocol>)member memberId];
    CSContactDataCell *cell = (CSContactDataCell *)[tableView cellForRowAtIndexPath:indexPath];
    CSKitInfo *info;
    if (self.selectType == NIMContactSelectTypeTeam) {
        info = [[CSKit sharedKit] infoByTeam:memberId];
    }else{
        info = [[CSKit sharedKit] infoByUser:memberId];
    }
    if([_selectecContacts containsObject:memberId]) {
        [_selectecContacts removeObject:memberId];
        cell.accessoryBtn.selected = NO;
        [self.selectIndicatorView.pickedView removeMemberInfo:info];
    } else if(_selectecContacts.count >= _maxSelectCount) {
        if ([self.config respondsToSelector:@selector(selectedOverFlowTip)]) {
            NSString *tip = [self.config selectedOverFlowTip];
            [self.view CSKit_makeToast:tip duration:2.0 position:CSKitToastPositionCenter];
        }
        cell.accessoryBtn.selected = NO;
    } else {
        [_selectecContacts addObject:memberId];
        cell.accessoryBtn.selected = YES;
        [self.selectIndicatorView.pickedView addMemberInfo:info];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ContactPickedViewDelegate

- (void)removeUser:(NSString *)userId {
    [_selectecContacts removeObject:userId];
    [_tableView reloadData];
}


#pragma mark - Private
- (CSContactSelectTabView *)selectIndicatorView{
    if (_selectIndicatorView) {
        return _selectIndicatorView;
    }
    CGFloat tabHeight = 50.f;
    CGFloat tabWidth  = 320.f;
    _selectIndicatorView = [[CSContactSelectTabView alloc] initWithFrame:CGRectMake(0, 0, tabWidth, tabHeight)];
    return _selectIndicatorView;
}
@end

