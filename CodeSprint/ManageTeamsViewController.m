//
//  ManageTeamsViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/15/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ManageTeamsViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "FirebaseManager.h"
#import "Constants.h"
@interface ManageTeamsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) IBOutlet UITableView *teamsTableView;
@property (strong, nonatomic) UITapGestureRecognizer *contentTapGesture;
@property (strong, nonatomic) NSMutableArray *selected;
@end

@implementation ManageTeamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.selected = [[NSMutableArray alloc] init];
    self.teamsTableView.delegate = self;
    self.teamsTableView.dataSource = self;
    self.teamsTableView.allowsMultipleSelectionDuringEditing = NO;
    
    NSInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    if (count == 0) {
        [self.teamsTableView setEditing:NO animated:NO];
    }else{
        [self.teamsTableView setEditing:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - View Setup
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
-(void)setupView{
    self.navigationItem.title = @"Leave Teams";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.contentTapGesture = tap;
    self.contentTapGesture.enabled = NO;
    [self.view addGestureRecognizer:tap];
    
    UIImage* closeImage = [UIImage imageNamed:@"Close-Button"];
    CGRect frameimg = CGRectMake(0, 0, closeImage.size.width, closeImage.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:closeImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *closeButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = closeButton;
    self.navigationItem.leftBarButtonItem.title = @"OK";
}
#pragma mark - IBActions
- (void)dismiss {
   // [FirebaseManager detachScrum];
   // [FirebaseManager detachScrumDelete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ImportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    if (count == 0) {
        cell.textLabel.text = @"No teams to leave.";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = NO;
    }else{
        cell.userInteractionEnabled = YES;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = [FirebaseManager sharedInstance].currentUser.groupsIDs[indexPath.row];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    return (count == 0) ?  1 : count;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.selected addObject:indexPath];
        [self.delegate didLeave:self.selected];
        [self dismiss];
    }
}
@end
