//
//  BacklogTableViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "BacklogTableViewController.h"
#import "DZNSegmentedControl.h"

#define DEBUG_APPERANCE     0
#define DEBUG_IMAGE         0

#define kBakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define kTintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define kHairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]

@interface BacklogTableViewController () <DZNSegmentedControlDelegate>
@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation BacklogTableViewController


// Product Backlog(specifications) -> Sprint Backlog -> Sprint  (loop) -> burnout chart
// Sprint planning -> Daily Scrim -> Sprint Review(at end of sprint) -> Chat

// workflow
// product backlog(professor specs) -> sprint planning (plan/discuss user storeis) -> (sprint backlog user stories goals) -> SPRINT (1-3 weeks) with daily scrum every 24 hours. -> Shipped product/review/reflect

- (void)loadView{
    [super loadView];
    
    self.title = @"Scrum Artifacts";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSegment:)];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;

}

- (void)viewDidLoad{
    [super viewDidLoad];
    

    _menuItems = @[[@"Product Specs" uppercaseString], [@"Sprint Goals" uppercaseString], [@"Charts" uppercaseString]];

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

- (DZNSegmentedControl *)control{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 1;
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
        //                _control.adjustsFontSizeToFitWidth = YES;
        
        [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ #%d", [[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] capitalizedString], (int)indexPath.row+1];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - ViewController Methods

- (void)addSegment:(id)sender{
    NSUInteger newSegment = self.control.numberOfSegments;
    

    [self.control setTitle:[@"Favorites" uppercaseString] forSegmentAtIndex:newSegment];
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:newSegment];

}

- (void)refreshSegments:(id)sender{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.menuItems];
    NSUInteger count = [array count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    _menuItems = array;
    
    [self.control setItems:self.menuItems];
    [self updateControlCounts];
}

- (void)updateControlCounts{
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:0];
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:1];
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:2];
    
}

- (void)didChangeSegment:(DZNSegmentedControl *)control{
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
