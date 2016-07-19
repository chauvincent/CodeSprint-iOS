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
#import <RWBlurPopover/RWBlurPopover.h>
#import "Team.h"
#import "FirebaseManager.h"
@interface SprintMenuViewController () <CreateTeamViewControllerDelegate>

@property (nonatomic, weak) RWBlurPopover *createTeamPopover;

@end

@implementation SprintMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
    self.createTeamPopover = popover;
}

#pragma mark - CreateTeamViewControllerDelegate
-(void)createdNewTeam:(NSString*)inputText{
    Team *newTeam = [[Team alloc] initWithCreatorUID:[FirebaseManager sharedInstance].uid andTeam:inputText];
    [FirebaseManager createTeamWith:newTeam];
}
@end
