//
//  PopupSettingsViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/9/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "PopupSettingsViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "FirebaseManager.h"
#import "Constants.h"
#import "AnimatedButton.h"

@interface PopupSettingsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet AnimatedButton *removeButton;
@property (strong, nonatomic) IBOutlet AnimatedButton *completedButton;
@property (strong, nonatomic) UITapGestureRecognizer *contentTapGesture;

@end

@implementation PopupSettingsViewController

#pragma mark - View Controller Lifecycle
-(void)loadView{
    [super loadView];
    [self setupView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FirebaseManager observePassiveScrumNode:self.scrumKey withCompletion:^(Artifacts *artifact) {
        self.currentArtifact = artifact;
    }];
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
    NSLog(@"CURRENT PRODCT SPEC LOCAL: %@",self.currentArtifact.productSpecs);
    self.descriptionLabel.hidden = NO;
    self.completedButton.hidden = NO;
    switch (self.currentIndex) {
        case 0:
            self.navigationItem.title = @"Specification";
            self.descriptionTextView.text = @"";
            self.titleTextView.hidden = NO;
            self.titleTextView.text = self.currentArtifact.productSpecs[_indexPath];
            self.descriptionLabel.hidden = YES;
            self.completedButton.hidden = YES;
            break;
        case 1:
            self.navigationItem.title = @"View Goal";
            self.descriptionTextView.hidden = NO;
            self.titleTextView.hidden = NO;
            [self setForGoals];
            break;
        case 2:
            self.navigationItem.title = @"Sprint Goal";
            self.descriptionTextView.hidden = NO;
            self.titleTextView.hidden = NO;
            [self setForSprint];
            break;
        default:
            break;
    }
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
-(void)setForGoals{
    NSDictionary *currentGoals;
    currentGoals = self.currentArtifact.sprintGoals[_indexPath];
    self.titleTextView.text = currentGoals[kScrumSprintTitle];
    self.descriptionTextView.text = currentGoals[kScrumSprintDescription];
}
-(void)setForSprint{
    NSDictionary *currentSprint = self.currentArtifact.sprintCollection[_selectedIndex];
    NSArray *goalRefs = currentSprint[kSprintGoalReference];
    NSUInteger current = [goalRefs[_indexPath] integerValue];
    NSDictionary *currentGoal = self.currentArtifact.sprintGoals[current];
    self.titleTextView.text = currentGoal[kScrumSprintTitle];
    self.descriptionTextView.text = currentGoal[kScrumSprintDescription];
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - IBActions
- (IBAction)completedButton:(id)sender {
}
- (IBAction)removeButton:(id)sender {
    switch (self.currentIndex) {
        case 0:
            [self removeProductSpec];
            break;
        case 1:
            [self removeSprintGoal];
            break;
        case 2:
            [self removeGoalInsideSprint];
            break;
        default:
            break;
    }
}
#pragma mark - Helpers
-(void)removeProductSpec{
    [FirebaseManager removeProductSpecFor:self.scrumKey withArtifact:self.currentArtifact forIndex:self.indexPath withCompletion:^(BOOL compelted) {
        NSLog(@"DID REMOVE");
        [self dismiss];
    }];
}
-(void)removeSprintGoal{
    
}
-(void)removeGoalInsideSprint{
    [FirebaseManager removeSprintGoalFor:self.scrumKey withArtifact:self.currentArtifact forIndex:self.indexPath andSprintIndex:_selectedIndex withCompletion:^(Artifacts *artifact) {
        [self dismiss];
    }];
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
