//
//  ImportItemsViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/5/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ImportItemsViewController.h"
#import "Constants.h"
#import "ErrorCheckUtil.h"

@interface ImportItemsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *sprintGoalsTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) UITapGestureRecognizer *contentTapGesture;
@property (strong, nonatomic) NSMutableArray *selected;
@end

@implementation ImportItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.selected = [[NSMutableArray alloc] init];
    self.sprintGoalsTableView.delegate = self;
    self.sprintGoalsTableView.dataSource = self;
  
    self.sprintGoalsTableView.allowsMultipleSelectionDuringEditing = YES;
    [self.sprintGoalsTableView setEditing:YES animated:YES];
    NSLog(@"ARTIFACT IN IMPORT: %@", self.currentArtifact.sprintGoals);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - View Setup
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
-(void)setupView{
    self.navigationItem.title = @"Import From Goals";
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
#pragma mark - UITableViewDelegate && UITableViewDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ImportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ([self.currentArtifact.sprintGoals count] == 0) {
        cell.textLabel.text = @"None To Select";
        self.submitButton.enabled = NO;
    }else{
        self.submitButton.enabled = YES;
        NSDictionary *currentGoal = self.currentArtifact.sprintGoals[indexPath.row];
        cell.textLabel.text = currentGoal[kSprintTitle];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.currentArtifact.sprintGoals count] == 0) {
        return 1;
    }else{
        return [self.currentArtifact.sprintGoals count];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.selected containsObject:indexPath]){
        [self.selected removeObject:indexPath];
    }else{
        [self.selected addObject:indexPath];
    }
}
- (IBAction)submitButtonPressed:(id)sender {
    if (self.selected.count!=0) {
        [self.delegate didImport:self.selected];
    }
    [self dismiss];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
