//
//  ViewSprintViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/4/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ViewSprintViewController.h"
#import "Constants.h"
#import "ImportItemsViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "FirebaseManager.h"
#import "Constants.h"
#import "ArtifactsTableViewCell.h"
#import "PopupSettingsViewController.h"
#import "AnimatedButton.h"
@interface ViewSprintViewController () <ImportItemsViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (strong, nonatomic) IBOutlet UITableView *sprintGoalsTableView;
@property (strong, nonatomic) IBOutlet AnimatedButton *removeSprintButton;
@property (strong, nonatomic) NSMutableArray *goalRefs;
@end

@implementation ViewSprintViewController
- (void)loadView{
     [super loadView];
    self.navigationItem.title = @"Goals for this Sprint";
    self.navigationItem.hidesBackButton = YES;
    self.sprintGoalsTableView.delegate = self;
    self.sprintGoalsTableView.dataSource = self;
    self.sprintGoalsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(importButtonPressed:)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *currentSprint = self.currentArtifact.sprintCollection[self.selectedIndex];
    NSString *deadlineText = [NSString stringWithFormat:@"Deadline: %@",currentSprint[kSprintDeadline]];
    self.deadlineLabel.text = deadlineText;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)importButtonPressed:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ImportItemsViewController"];
    self.vc.currentArtifact = self.currentArtifact;
    self.vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.vc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
}
-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)didImport:(NSMutableArray*)selected{
    NSLog(@"selected index: %ld", (long)self.selectedIndex);
    //NSLog(@"%@", self.currentArtifact.sprintCollection[self.selectedIndex]);
    [FirebaseManager updateSprintFor:self.currentScrum withGoalRefs:selected andCollectionIndex:(NSInteger)self.selectedIndex withArtifact:self.currentArtifact withCompletion:^(Artifacts *artifact) {
        self.currentArtifact = artifact;
        [self.sprintGoalsTableView reloadData];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtifactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewSprintCell"];
    
    NSDictionary *dictionary = self.currentArtifact.sprintCollection[self.selectedIndex];
    NSArray *goalRefs = dictionary[kSprintGoalReference];

    if ([goalRefs count] == 1 && [goalRefs containsObject:@(-1)]) {
        cell.textLabel.text = @"No Goals To Display.";
        cell.detailTextLabel.text = @"";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.numberOfLines = 3;
    }else{
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        NSInteger myInt = [goalRefs[indexPath.row] integerValue];
        NSDictionary *currentSprint = [self.currentArtifact.sprintGoals objectAtIndex:myInt];
        cell.textLabel.text = currentSprint[kScrumSprintTitle];
        cell.detailTextLabel.text = currentSprint[kScrumSprintDeadline];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dictionary = self.currentArtifact.sprintCollection[self.selectedIndex];
    NSArray *goals = (NSArray*)dictionary[kSprintGoalReference];
    return [goals count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopupSettingsViewController *viewc = [storyboard instantiateViewControllerWithIdentifier:@"PopupSettingsViewController"];
    viewc.currentIndex = 2;
    viewc.indexPath = indexPath.row;
    viewc.currentArtifact = self.currentArtifact;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)removeButtonPressed:(id)sender {
}

@end
