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
@interface BacklogTableViewController () <DZNSegmentedControlDelegate>

@property (nonatomic, strong) AddItemViewController *vc;
@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSString *currentScrumKey;
@property (nonatomic) NSUInteger currentIndex;

@end

@implementation BacklogTableViewController

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

// Product Backlog(specifications) -> Sprint Backlog -> Sprint  (loop) -> burnout chart
// Sprint planning -> Daily Scrim -> Sprint Review(at end of sprint) -> Chat

// workflow
// product backlog(professor specs) -> sprint planning (plan/discuss user storeis) -> (sprint backlog user stories goals) -> SPRINT (1-3 weeks) with daily scrum every 24 hours. -> Shipped product/review/reflect

- (void)loadView{
    [super loadView];
    NSLog(@"Selected team: %@", self.selectedTeam);
    self.currentScrumKey = [FirebaseManager sharedInstance].currentUser.scrumIDs[self.selectedTeam];
    
    // Set up observer for backlog changes
    [FirebaseManager observeScrumNode:_currentScrumKey withCompletion:^(Artifacts *artifact) {
        self.artifacts = artifact;
        NSLog(@"%@", self.artifacts.productSpecs);
        NSLog(@"%@", self.artifacts.sprintGoals);
        NSLog(@"%@", self.artifacts.sprintCollection);
        self.vc.currentArtifact = artifact;
        [self.tableView reloadData];
        
        [self updateControlCounts];
    }];
    
    self.title = @"SCRUM Artifacts";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addArtifactItem:)];

    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;

}
- (void)viewDidLoad{
    [super viewDidLoad];
//        [self.artifacts.productSpecs addObject:@"raesrasef"];
//    
//    [self.artifacts.productSpecs addObject:@"raesrasef213131"];
    _menuItems = @[[@"Specs" uppercaseString], [@"Goals" uppercaseString], [@"Charts" uppercaseString],[@"Sprints" uppercaseString]];

    self.tableView.tableHeaderView = self.control;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self updateControlCounts];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)addArtifactItem:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"AddItemViewController"];
    self.vc.index = self.currentIndex;
    self.vc.currentScrum = self.currentScrumKey;
    self.vc.currentArtifact = self.artifacts;

    
    NSLog(@"current scrum key: %@", self.currentScrumKey);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.vc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = YES;
    [popover showInViewController:self];
}

- (DZNSegmentedControl *)control{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
        _control.bouncySelectionIndicator = NO;
        _control.height = 75.0f;
        
        //                _control.height = 120.0f;
        //                _control.width = 300.0f;
        //                _control.showsGroupingSeparators = YES;
        //                _control.inverseTitles = YES;
        //                _control.backgroundColor = [UIColor lightGrayColor];
        //                _control.tintColor = [UIColor purpleColor];
        //                _control.hairlineColor = [UIColor purpleColor];
        //                _control.showsCount = NO;
        //                _control.autoAdjustSelectionIndicatorWidth = NO;
        //                _control.selectionIndicatorHeight = 4.0;
                        _control.adjustsFontSizeToFitWidth = YES;
        
        [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - AddItemViewControllerDelegate
-(void)updateArtifactItem{
    
}
#pragma mark - UITableViewDataSource Methods

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
            amountRows = self.allSprints.count;
            break;
        case 3:
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

    switch (self.currentIndex) {
        case 0:
         
            if (self.artifacts.productSpecs.count == 0) {
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.text = @"This is the Product Backlog. Please add project specifications here.";
                cell.userInteractionEnabled = FALSE;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.userInteractionEnabled = TRUE;
                cell.textLabel.text = self.artifacts.productSpecs[indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            }
            break;
        case 1:
            if(self.artifacts.sprintGoals.count == 0){
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.text = @"This is the Sprint Backlog. Please add all the tasks required to finish the assigment specifications.";
                cell.userInteractionEnabled = FALSE;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.userInteractionEnabled = TRUE;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSDictionary *currentDictionary = (NSDictionary*)self.artifacts.sprintGoals[indexPath.row];
                NSLog(@"current dictionary: %@", currentDictionary);
                NSString *taskTitle = currentDictionary[kScrumSprintTitle];
                NSString *deadline = currentDictionary[kScrumSprintDeadline];
                NSString *cellText = [NSString stringWithFormat:@"%@ - %@", deadline, taskTitle];
                cell.textLabel.text = cellText;
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            }
            break;
        case 2:
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"No Burndown Charts To Show";
            cell.userInteractionEnabled = FALSE;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 3:
            if (self.artifacts.sprintCollection.count == 0) {
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.text = @"Please create a new sprint. Once created tap on the sprint for the sprint details";
                cell.userInteractionEnabled = FALSE;
            }else{
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSDictionary *currentDictionary = (NSDictionary*)self.artifacts.sprintCollection[indexPath.row];
                NSLog(@"current dict %@", currentDictionary);
                NSString *taskTitle = currentDictionary[kSprintTitle];
                NSString *deadline = currentDictionary[kSprintDeadline];
                NSString *cellText = [NSString stringWithFormat:@"%@ - %@", deadline, taskTitle];
                cell.textLabel.text = cellText;
                cell.userInteractionEnabled = TRUE;
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            }
  
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}
-(void)configureCell:(UITableViewCell*)cell{
    
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentIndex) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            [self performSegueWithIdentifier:@"CellToSprintViewSegue" sender:self];
            break;
        default:
            break;
    }
}
#pragma mark - ViewController Methods

- (void)updateControlCounts{
    NSNumber *productCount = [NSNumber numberWithUnsignedInteger:self.artifacts.productSpecs.count];
    NSNumber *sprintGoals = [NSNumber numberWithUnsignedInteger:self.artifacts.sprintGoals.count];
    NSNumber *sprintCollection = [NSNumber numberWithUnsignedInteger:self.artifacts.sprintCollection.count];
    
    [self.control setCount:productCount forSegmentAtIndex:0];
    [self.control setCount:sprintGoals forSegmentAtIndex:1];
    [self.control setCount:@(0) forSegmentAtIndex:2]; // Burnout charts later
    [self.control setCount:sprintCollection forSegmentAtIndex:3];
}

- (void)didChangeSegment:(DZNSegmentedControl *)control{
    self.currentIndex = control.selectedSegmentIndex;
    [self.tableView reloadData];
    
}
#pragma mark - DZNSegmentedControlDelegate Methods
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view{
    return UIBarPositionAny;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar{
    return UIBarPositionAny;
}

@end
