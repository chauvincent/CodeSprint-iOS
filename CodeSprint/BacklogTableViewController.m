//
//  BacklogTableViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "BacklogTableViewController.h"
#import "DZNSegmentedControl.h"
#import "AddItemViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "FirebaseManager.h"
#import "Artifacts.h"
#import "Constants.h"
#import "ViewSprintViewController.h"
#import "PopupSettingsViewController.h"
#import "ErrorCheckUtil.h"

@interface BacklogTableViewController () <DZNSegmentedControlDelegate>

@property (nonatomic, strong) AddItemViewController *vc;
@property (nonatomic, weak) ViewSprintViewController *viewSprintController;
@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSString *currentScrumKey;
@property (nonatomic) NSUInteger selectedSprintIndex;
@property (nonatomic) NSUInteger currentIndex;

@end

@implementation BacklogTableViewController

#pragma mark - Lazy Initializations
-(Artifacts*)artifacts{
    if (!_artifacts) {
        _artifacts = [[Artifacts alloc] initWithProductSpecs:[[NSMutableArray alloc] init]
                                                    andGoals:[[NSMutableArray alloc] init]
                                                 withSprints:[[NSMutableArray alloc] init]];
    }
    return _artifacts;
}
-(NSMutableArray*)allSprints{
    if (!_allSprints) {
        _allSprints = [[NSMutableArray alloc] init];
    }
    return _allSprints;
}
- (DZNSegmentedControl *)control{
    if (!_control){
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
        _control.bouncySelectionIndicator = NO;
        _control.height = 75.0f;
        _control.adjustsFontSizeToFitWidth = YES;
        [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}
#pragma mark - ViewController Lifecycle
- (void)loadView{
    [super loadView];
    [self setupView];
}

//
//[FirebaseManager removeAllObservers];
//[FirebaseManager detachScrum];
//[FirebaseManager detachChatroom];
//[FirebaseManager detachScrumDelete];
//[FirebaseManager detachNewTeams];

- (void)viewDidLoad{
    [super viewDidLoad];
    _menuItems = @[@"Specifications",@"Sprint Goals",@"Active Sprints"];
    self.tableView.tableHeaderView = self.control;
    self.tableView.tableFooterView = [UIView new];
//    [FirebaseManager observePassiveScrumNode:self.currentScrumKey withCompletion:^(Artifacts *artifact) {
//        NSLog(@"OBSERVER PASSIVE 1");
//
//    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self updateControlCounts];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"CellToSprintViewSegue"]) {
        self.viewSprintController = [segue destinationViewController];
        self.viewSprintController.selectedIndex = self.selectedSprintIndex;
        self.viewSprintController.currentArtifact = self.artifacts;
        self.viewSprintController.currentScrum = self.currentScrumKey;
        
    }
}
-(void)dismiss{
    [FirebaseManager detachScrum];
    [FirebaseManager detachScrumDelete];
    [[[[[FIRDatabase database] reference] child:kScrumHead] child:self.currentScrumKey ] removeObserverWithHandle:[FirebaseManager sharedInstance].passiveScrumHandle];
   
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Helper Methods
-(void)setupView{
    self.currentScrumKey = [FirebaseManager sharedInstance].currentUser.scrumIDs[self.selectedTeam];
    [FirebaseManager observePassiveScrumNode:_currentScrumKey withCompletion:^(Artifacts *artifact) {
        self.artifacts = artifact;
        self.vc.currentArtifact = artifact;
        self.viewSprintController.currentArtifact = artifact;
        self.viewSprintController.vc.currentArtifact = artifact;
        self.viewSprintController.currentScrum = self.currentScrumKey;
        NSLog(@"OBSERVE PASSIVE 2");
        [self.tableView reloadData];
        [self updateControlCounts];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addArtifactItem:)];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
}
-(void)popoverForCell:(NSInteger)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopupSettingsViewController *viewc = [storyboard instantiateViewControllerWithIdentifier:@"PopupSettingsViewController"];
    viewc.currentIndex = self.currentIndex;
    viewc.indexPath = indexPath;
    viewc.currentArtifact = self.artifacts;
    viewc.scrumKey = self.currentScrumKey;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
}
#pragma mark - IBAction
-(void)addArtifactItem:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"AddItemViewController"];
    self.vc.index = self.currentIndex;
    self.vc.currentScrum = self.currentScrumKey;
    self.vc.currentArtifact = self.artifacts;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.vc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
}
#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger amountRows;
    switch (self.currentIndex) {
        case 0:
            amountRows = self.artifacts.productSpecs.count;
            break;
        case 1:
            amountRows = self.artifacts.sprintGoals.count;
            break;
        case 2:
            amountRows = self.artifacts.sprintCollection.count;
            break;
        default:
            amountRows = 0;
    }
    if (amountRows == 0) {
        return 1;
    }
    return amountRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ArtifactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return [self configureCellForIndex:indexPath withCell:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentIndex == 2) {
        self.selectedSprintIndex = indexPath.row;
        NSLog(@"%lu", (unsigned long)self.selectedSprintIndex);
        self.viewSprintController.currentScrum = self.currentScrumKey;
        self.viewSprintController.selectedSprintIndex = indexPath.row;
        [self performSegueWithIdentifier:@"CellToSprintViewSegue" sender:self];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentIndex) {
        case 0:
            [self popoverForCell:indexPath.row];
            break;
        case 1:
            [self popoverForCell:indexPath.row];
            break;
        default:
            break;
    }
}

#pragma mark - DZNSegmentedControlDelegate Methods
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view{
    return UIBarPositionAny;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar{
    return UIBarPositionAny;
}
- (void)updateControlCounts{
    NSNumber *productCount = [NSNumber numberWithUnsignedInteger:self.artifacts.productSpecs.count];
    NSNumber *sprintGoals = [NSNumber numberWithUnsignedInteger:self.artifacts.sprintGoals.count];
    NSNumber *sprintCollection = [NSNumber numberWithUnsignedInteger:self.artifacts.sprintCollection.count];
    
    [self.control setCount:productCount forSegmentAtIndex:0];
    [self.control setCount:sprintGoals forSegmentAtIndex:1];
    [self.control setCount:sprintCollection forSegmentAtIndex:2];
}
- (void)didChangeSegment:(DZNSegmentedControl *)control{
    if (self.artifacts.productSpecs.count == 0 && control.selectedSegmentIndex == 1) {
        ErrorCheckUtil *errorCheck = [[ErrorCheckUtil alloc] init];
        UIAlertController *alert =[errorCheck showAlertWithTitle:@"Sprint Goals" andMessage:@"Please add to the Specifications tab, before proceeding to the Sprint Backlog." andDismissNamed:@"OK"];
        [self presentViewController:alert animated:YES completion:nil];
        self.currentIndex = control.selectedSegmentIndex;
        [self.tableView reloadData];
    }else if (self.artifacts.sprintGoals.count == 0 && control.selectedSegmentIndex == 2){
        ErrorCheckUtil *errorCheck = [[ErrorCheckUtil alloc] init];
        UIAlertController *alert =[errorCheck showAlertWithTitle:@"Active Sprints" andMessage:@"Please add to the Sprint Goals tab before proceeding to create Active Sprints." andDismissNamed:@"OK"];
        [self presentViewController:alert animated:YES completion:nil];
        self.currentIndex = control.selectedSegmentIndex;
        [self.tableView reloadData];
    }else{
        self.currentIndex = control.selectedSegmentIndex;
        [self.tableView reloadData];
        
    }
}
#pragma mark - Cell Helpers
-(ArtifactsTableViewCell*)configureCellForIndex:(NSIndexPath*)indexPath withCell:(ArtifactsTableViewCell*)cell{
    switch (self.currentIndex) {
        case 0:
            self.title = @"Product Backlog";
            cell.detailTextLabel.text = @"";
            if (self.artifacts.productSpecs.count == 0) {
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.text = @"This is the Product Backlog. Please add the product specifications here before proceeding to the next tab.";
                cell.userInteractionEnabled = FALSE;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.userInteractionEnabled = TRUE;
                cell.textLabel.text = self.artifacts.productSpecs[indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.detailTextLabel.text = @"";
            }
            break;
        case 1:
            self.title = @"Sprint Backlog";
            if(self.artifacts.sprintGoals.count == 0 && self.artifacts.productSpecs.count == 0){
                cell.hidden = TRUE;
                [self.control setSelectedSegmentIndex:0];
                self.currentIndex = 0;
                [self.tableView reloadData];
            }else if(self.artifacts.sprintGoals.count == 0){
                cell.hidden = FALSE;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.text = @"This is the Sprint Backlog. Please add all the tasks required to finish the project specifications and their deadlines.";
                cell.userInteractionEnabled = FALSE;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = @"";
            }else{
                cell.hidden = FALSE;
                cell.userInteractionEnabled = TRUE;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSDictionary *currentDictionary = (NSDictionary*)self.artifacts.sprintGoals[indexPath.row];
                NSLog(@"current dictionary: %@", currentDictionary);
                NSString *taskTitle = currentDictionary[kScrumSprintTitle];
                if ([currentDictionary[kScrumSprintCompleted] isEqual:@(1)]) {
                    NSString *detailText = [NSString stringWithFormat:@"Deadline: %@, Completed on %@", currentDictionary[kScrumSprintDeadline], currentDictionary[kScrumSprintFinishDate]];
                    cell.detailTextLabel.text = detailText;
                }else{
                    NSString *deadline = currentDictionary[kScrumSprintDeadline];
                    NSString *subtitleText = [NSString stringWithFormat:@"Deadline: %@", deadline];
                    cell.detailTextLabel.text = subtitleText;
                }
                cell.textLabel.text = taskTitle;
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            }
            break;
        case 2: 
            self.title = @"Active Sprints";
            if (self.artifacts.productSpecs.count == 0 || self.artifacts.sprintGoals.count == 0 ) {
                cell.hidden = TRUE;
                [self.control setSelectedSegmentIndex:1];
                self.currentIndex = 1;
                [self.tableView reloadData];
            }
            if (self.artifacts.sprintCollection.count == 0) {
                cell.hidden = FALSE;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.text = @"Please create a new sprint. Once created tap on the cell to manage an active sprint.";
                cell.userInteractionEnabled = FALSE;
                cell.detailTextLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else {
                cell.hidden = FALSE;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSDictionary *currentDictionary = (NSDictionary*)self.artifacts.sprintCollection[indexPath.row];
                NSString *taskTitle = currentDictionary[kSprintTitle];
                NSString *deadline = currentDictionary[kSprintDeadline];
                NSString *subtitleText = [NSString stringWithFormat:@"Ends on: %@", deadline];
                cell.textLabel.text = taskTitle;
                cell.detailTextLabel.text = subtitleText;
                cell.userInteractionEnabled = TRUE;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        default:
            break;
    }
    return cell;
}

@end
