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
    [self.teamsTableView setEditing:YES animated:YES];
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
    self.navigationItem.leftBarButtonItem = self.submitButton;
    self.navigationItem.leftBarButtonItem.title = @"OK";
}
#pragma mark - IBActions
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitButtonPressed:(id)sender {
    if (self.selected.count!=0) {
        [self.delegate didLeave:self.selected];
    }
    [self dismiss];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ImportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    if (count == 0) {
        self.submitButton.enabled = NO;
    }else{
        self.submitButton.enabled = YES;
        cell.textLabel.text = [FirebaseManager sharedInstance].currentUser.groupsIDs[indexPath.row];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [[FirebaseManager sharedInstance].currentUser.groupsIDs count];
    return (count == 0) ?  1 : count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if([self.selected containsObject:indexPath]){
//        [self.selected removeObject:indexPath];
//    }else{
//        [self.selected addObject:indexPath];
//    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.selected addObject:indexPath];
        NSLog(@"DID GET CALLED");
        NSLog(@"%@",self.selected);
        [self.delegate didLeave:self.selected];
        
        [self dismiss];
    }
}
@end
