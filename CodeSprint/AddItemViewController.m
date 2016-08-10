//
//  AddItemViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/2/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "AddItemViewController.h"
#import "Constants.h"
#import "FirebaseManager.h"
#import "CustomTextField.h"
#import "CustomTextView.h"
#import "BacklogTableViewController.h"

@interface AddItemViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *contentTapGesture;
@property (strong, nonatomic) IBOutlet CustomTextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (strong, nonatomic) IBOutlet CustomTextField *titleTextField;

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupButtons];
    
    NSLog(@"additem : %@", _currentScrum);
    NSLog(@"current index: %lu", (unsigned long)self.index);
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
    
    switch (self.index) {
        case 0: // Add Product Spec
            self.navigationItem.title = @"Add Specification";
            self.deadlineLabel.hidden = TRUE;
            self.deadlineDatePicker.hidden = TRUE;
            self.titleTextField.hidden = TRUE;
            break;
        case 1: // Add Sprint Goal
              self.navigationItem.title = @"Add Sprint Goal";
            self.deadlineLabel.text = @"Deadline";
            self.deadlineLabel.hidden = FALSE;
            self.deadlineDatePicker.hidden = FALSE;
            self.titleTextField.hidden = FALSE;
            self.titleTextField.placeholder = @"Title";
            break;
      //  case 2: // Burnout Charts
        //    break;
        case 2: // Add A Sprint
            self.navigationItem.title = @"Add Sprint";
            self.descriptionTextView.hidden = TRUE;
            self.titleTextField.placeholder = @"eg. Sprint 0";
            self.deadlineLabel.text = @"Deadline";
            break;
        default:
            break;
    }
    self.deadlineDatePicker.minimumDate = [NSDate date];

}
-(void)setupButtons{
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
}
- (IBAction)createButtonPressed:(id)sender {
    switch (self.index) {
        case 0: // Add Product Spec
            NSLog(@"Add Specification");
            [self addProductSpecs];
            break;
        case 1: // Add Sprint Goal
            NSLog(@"Add Sprint Goals");
            [self addSprintGoals];
            break;
        //case 2: // Add
          //  break;
        case 2: // Add a sprint
            NSLog(@"Add a Sprint");
            [self addSprint];
            break;
        default:
            break;
    }
  
  
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 12;
}
#pragma mark - Helper Methods
- (void)addProductSpecs{
    NSString *input = self.descriptionTextView.text;
    [self.currentArtifact.productSpecs addObject:input];
    [FirebaseManager addProductSpecToScrum:self.currentScrum withArtifact:self.currentArtifact withCompletion:^(BOOL completed) {
        [self dismiss];
    }];
}
-(void)addSprintGoals{
    NSString *title = self.titleTextField.text;
    NSString *description = self.descriptionTextView.text;
    NSDate *chosenDate = [self.deadlineDatePicker date];
    NSString *stringFromDate = [self convertDate:chosenDate];
    NSDictionary *newSprintGoal = @{kScrumSprintTitle:title,
                                    kScrumSprintDescription:description,
                                    kScrumSprintDeadline:stringFromDate,
                                    kScrumSprintCompleted:@0};
    [self.currentArtifact.sprintGoals addObject:newSprintGoal];
    [FirebaseManager addSprintGoalToScrum:_currentScrum withArtifact:(Artifacts *)self.currentArtifact withCompletion:^(BOOL completed) {
        [self dismiss];
    }];
}
-(void)addSprint{
    NSString *sprintName = self.titleTextField.text;
    NSString *date = [self convertDate:self.deadlineDatePicker.date];
    NSDictionary *newSprint = @{kSprintTitle:sprintName,
                                kSprintGoalReference:@[@(-1)],
                                kSprintDeadline:date};
    [self.currentArtifact.sprintCollection addObject:newSprint];
    [FirebaseManager createSprintFor:_currentScrum withArtifact:self.currentArtifact withCompletion:^(BOOL completed) {
        [self dismiss];
    }];
}
-(NSString*)convertDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

#pragma mark - Navigation



@end
