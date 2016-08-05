//
//  ImportItemsViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/5/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ImportItemsViewController.h"


@interface ImportItemsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *sprintGoalsTableView;
@property (nonatomic, strong) UITapGestureRecognizer *contentTapGesture;
@end

@implementation ImportItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
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
   
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.title = @"Create";
}
#pragma mark - IBActions
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)editButtonPressed:(id)sender{
    
}
#pragma mark - UITableViewDelegate && UITableViewDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ImportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ([self.currentArtifact.sprintGoals count] == 0) {
        cell.textLabel.text = @"Nothing to import, Please Create Some Sprint Goals";
    }else{
        cell.textLabel.text = self.currentArtifact.sprintGoals[indexPath.row];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.currentArtifact.sprintGoals count] == 0) {
        return 1;
    }
    return [self.currentArtifact.sprintGoals count];
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
