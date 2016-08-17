//
//  SprintMenuViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/8/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "SprintMenuViewController.h"
#import "CreateTeamViewController.h"
#import "SearchTeamViewController.h"
#import "ManageTeamsViewController.h"
#import "BacklogTableViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "Team.h"
#import "FirebaseManager.h"
#import "TeamsTableViewCell.h"
#import "IGIdenticon.h"
#import "Constants.h"

@interface SprintMenuViewController () <CreateTeamViewControllerDelegate, SearchTeamViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *selectedTeam;
@property (weak, nonatomic) IBOutlet UITableView *teamsTableView;
@property (weak, nonatomic) RWBlurPopover *createTeamPopover;
@property (strong, nonatomic) IGImageGenerator *simpleIdenticonsGenerator;

@end

@implementation SprintMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [FirebaseManager observeNewTeams];
    self.teamsTableView.delegate = self;
    self.teamsTableView.dataSource = self;
    
    self.view.backgroundColor = GREY_COLOR;
    self.teamsTableView.backgroundColor = GREY_COLOR;
    self.simpleIdenticonsGenerator = [[IGImageGenerator alloc] initWithImageProducer:[IGSimpleIdenticon new] hashFunction:IGJenkinsHashFromData];
    [self.teamsTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SprintMenuToTeamSegue"]) {
        BacklogTableViewController *vc = [segue destinationViewController];
        vc.selectedTeam = self.selectedTeam;
    }
}
#pragma mark - IBActions
- (IBAction)createButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateTeamViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CreateTeamViewController"];
    vc.delegate = self;
    [self popoverController:vc];
}
- (IBAction)searchButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchTeamViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SearchTeamViewController"];
    vc.delegate = self;
    [self popoverController:vc];
}
- (IBAction)editButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ManageTeamsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ManageTeamsViewController"];
    vc.delegate = self;
    [self popoverController:vc];
}

#pragma mark - View Setup
-(void)setupView{
    self.navigationItem.title = @"Teams";
    self.navigationItem.hidesBackButton = YES;
    self.teamsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    [self.createGroupButton setBackgroundImage:[UIImage imageNamed:@"create-button2"] forState:UIControlStateNormal];
    [self.findGroupButton setBackgroundImage:[UIImage imageNamed:@"find-button"] forState:UIControlStateNormal];
    [self.removeButton setBackgroundImage:[UIImage imageNamed:@"remove-button"] forState:UIControlStateNormal];
}
-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popoverController:(id)controller{
    if ([controller isKindOfClass:[CreateTeamViewController class]] || [controller isKindOfClass:[SearchTeamViewController class]] || [controller isKindOfClass:[ManageTeamsViewController class]]) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
        popover.throwingGestureEnabled = YES;
        [popover showInViewController:self];
        self.createTeamPopover = popover;
    }
}

#pragma mark - CreateTeamViewControllerDelegate && SearchTeamViewControllerDelegate && ManageTeamViewControllerDelegate
-(void)createdNewTeam:(NSString*)inputText{
    Team *newTeam = [[Team alloc] initWithCreatorUID:[FirebaseManager sharedInstance].currentUser.uid andTeam:inputText];
    [[FirebaseManager sharedInstance].currentUser.groupsIDs addObject:inputText];
    [FirebaseManager createTeamWith:newTeam
                     withCompletion:^(BOOL result) {
                         [self.teamsTableView reloadData];
                     }];
}
-(void)joinNewTeam:(NSString*)teamName {
    [FirebaseManager addUserToTeam:teamName
                           andUser:[FirebaseManager sharedInstance].currentUser.uid
                    withCompletion:^(BOOL result) {
                        [self.teamsTableView reloadData];
                    }];
}
-(void)didJoinTeam{
    [self.teamsTableView reloadData];
}
-(void)didLeave:(NSMutableArray*)selected{
    User *currentUser = [FirebaseManager sharedInstance].currentUser;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [selected count]; i++) {
        NSIndexPath *path = (NSIndexPath*)selected[i];
        NSInteger index = path.row;
        [array addObject:@(index)];
    }
//    
//    [FirebaseManager removeUserFromTeam:groupName andUser:currentUser.uid withIndexs:@[] withCompletion:^(BOOL result) {
//        [self.teamsTableView reloadData];
//    }];
}
#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TeamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];
    // TODO: refactor and set up image persistence
    if ([[FirebaseManager sharedInstance].currentUser.groupsIDs count] == 0) {
        cell.teamNameLabel.text = @"No teams to display.";
        CGSize imageViewSize = cell.identiconImageView.frame.size;
        cell.identiconImageView.image = [self.simpleIdenticonsGenerator imageFromUInt32:arc4random() size:imageViewSize];
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.teamNameLabel.text = [FirebaseManager sharedInstance].currentUser.groupsIDs[indexPath.section];
    CGSize imageViewSize = cell.identiconImageView.frame.size;
    u_int32_t random = arc4random();
    cell.identiconImageView.image = [self.simpleIdenticonsGenerator imageFromUInt32:random size:imageViewSize];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"tapped on team : %@" , [FirebaseManager sharedInstance].currentUser.groupsIDs[indexPath.section]);
    self.selectedTeam = [FirebaseManager sharedInstance].currentUser.groupsIDs[indexPath.section];
    [self performSegueWithIdentifier:@"SprintMenuToTeamSegue" sender:self];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSUInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    return (count == 0) ? 1 : count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

@end
