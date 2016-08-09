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

@interface ViewSprintViewController () <ImportItemsViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (strong, nonatomic) NSMutableArray *goalRefs;
@end

@implementation ViewSprintViewController
- (void)loadView{
     [super loadView];
    self.navigationItem.title = @"Sprint";
    self.navigationItem.hidesBackButton = YES;
    
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
    NSDictionary *currentSprint = self.currentArtifact.sprintCollection[self.selectedIndex];
    //NSArray *currentSprint = currentSprint[@"goalref"];
    NSLog(@"CURRENT SPRINT %@",currentSprint);
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
