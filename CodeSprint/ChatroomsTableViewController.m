//
//  ChatroomsTableViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/18/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ChatroomsTableViewController.h"
#import <JSQMessages.h>
#include "FirebaseManager.h"
#include "Constants.h"
#import "GroupChatViewController.h"
#import "GroupMessageTableViewCell.h"
#import "IGIdenticon.h"
@interface ChatroomsTableViewController ()

@property (strong, nonatomic) IGImageGenerator *simpleIdenticonsGenerator;
@end

@implementation ChatroomsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Setup
-(void)setupView{
    self.view.backgroundColor = GREY_COLOR;
    self.tableView.backgroundColor = GREY_COLOR;
    self.navigationItem.title = @"Team Chat";
    self.navigationItem.hidesBackButton = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.simpleIdenticonsGenerator = [[IGImageGenerator alloc] initWithImageProducer:[IGSimpleIdenticon new] hashFunction:IGJenkinsHashFromData];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
}
-(void)dismiss{
    [FirebaseManager detachChatroom];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    return (count == 0) ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    NSInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    if (count == 0) {
        CGSize imageViewSize = CGSizeMake(50.0f, 50.0f);
        cell.userInteractionEnabled = NO;
        cell.teamImage.image = [self.simpleIdenticonsGenerator imageFromUInt32:arc4random() size:imageViewSize];
        cell.teamLabel.text = @"No team chats available.";
    }else{
        NSMutableArray *teams = [FirebaseManager sharedInstance].currentUser.groupsIDs;
        cell.teamLabel.text = teams[indexPath.row];
        CGSize imageViewSize = CGSizeMake(50.0f, 50.0f);
        u_int32_t avatarIcon;
        NSString *teamName = teams[indexPath.row];
        NSUInteger hashForUser = [[NSUserDefaults standardUserDefaults] integerForKey:teamName];
        if (hashForUser != 0){
            avatarIcon = (u_int32_t)hashForUser;
        }else{
            avatarIcon = arc4random();
            NSUInteger iconHash = (NSUInteger)avatarIcon;
            [[NSUserDefaults standardUserDefaults] setInteger:iconHash forKey:teamName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        cell.teamImage.image = [self.simpleIdenticonsGenerator imageFromUInt32:avatarIcon size:imageViewSize];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupChatViewController *vc = [GroupChatViewController messagesViewController];
    NSMutableArray *teams = [FirebaseManager sharedInstance].currentUser.groupsIDs;
    vc.currentTeam = teams[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
