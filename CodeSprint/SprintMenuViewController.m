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
//    if ([FirebaseManager sharedInstance].currentUser.groupsIDs != NULL) {
//        NSLog(@"VIEW DID LOAD, CURRENT TEAMS  = %@", [FirebaseManager sharedInstance].currentUser.groupsIDs);
//    }
//    // Do any additional setup after loading the view.
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"DISSPAEARING");
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SprintMenuToTeamSegue"]) {
        BacklogTableViewController *vc = [segue destinationViewController];
        vc.selectedTeam = self.selectedTeam;
    }
}


#pragma mark - IBActions
- (IBAction)createButtonPressed:(id)sender {
    [self displayMenuCreateWithIdentifier:@"CreateTeamViewController"];
}
- (IBAction)searchButtonPressed:(id)sender {
    [self displayMenuSearchWithIdentifier:@"SearchTeamViewController"];
}
- (IBAction)editButtonPressed:(id)sender {
   
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
-(void)displayMenuCreateWithIdentifier:(NSString*)controllerName{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateTeamViewController *vc = [storyboard instantiateViewControllerWithIdentifier:controllerName];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
    self.createTeamPopover = popover;
}
-(void)displayMenuSearchWithIdentifier:(NSString*)controllerName{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchTeamViewController *vc = [storyboard instantiateViewControllerWithIdentifier:controllerName];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
    self.createTeamPopover = popover;
}

#pragma mark - CreateTeamViewControllerDelegate && SearchTeamViewControllerDelegate
-(void)createdNewTeam:(NSString*)inputText{
    Team *newTeam = [[Team alloc] initWithCreatorUID:[FirebaseManager sharedInstance].currentUser.uid andTeam:inputText];
    [[FirebaseManager sharedInstance].currentUser.groupsIDs addObject:inputText];
    [FirebaseManager createTeamWith:newTeam];
    NSLog(@"CREATE NEW TEAM CALLED");
    [self.teamsTableView reloadData];
}
-(void)joinNewTeam:(NSString*)teamName{
    [FirebaseManager addUserToTeam:teamName andUser:[FirebaseManager sharedInstance].currentUser.uid];
    [self.teamsTableView reloadData];
}
-(void)didJoinTeam{
    [self.teamsTableView reloadData];
}
#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TeamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];
    
    if ([[FirebaseManager sharedInstance].currentUser.groupsIDs count] == 0) {
        cell.teamNameLabel.text = @"No teams to display.";
        CGSize imageViewSize = cell.identiconImageView.frame.size;
        cell.identiconImageView.image = [self.simpleIdenticonsGenerator imageFromUInt32:arc4random() size:imageViewSize];
        //cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.teamNameLabel.text = [FirebaseManager sharedInstance].currentUser.groupsIDs[indexPath.section];
    CGSize imageViewSize = cell.identiconImageView.frame.size;
    cell.identiconImageView.image = [self.simpleIdenticonsGenerator imageFromUInt32:arc4random() size:imageViewSize];
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
    if (count == 0) {
        return 1;
    }else{
        return count;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

@end
