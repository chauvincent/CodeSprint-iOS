//
//  CreateTeamViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/12/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CreateTeamViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "ImageStyleButton.h"
#import "FirebaseManager.h"
#import "Team.h"
#import "ErrorCheckUtil.h"
#import "CustomTextField.h"

#define MAX_INPUT_LENGTH 20

@interface CreateTeamViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet CustomTextField *teamTextField;
@property (strong, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (nonatomic, strong) UITapGestureRecognizer *contentTapGesture;

@end

@implementation CreateTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _teamTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    [self setupButtons];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View Setup
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
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
    self.navigationItem.title = @"Create Team";
}

#pragma mark - IBActions
- (IBAction)createButtonPressed:(id)sender {
    NSString *inputText = self.teamTextField.text;
    NSString *password = self.passwordTextField.text;
    ErrorCheckUtil *errorCheck = [[ErrorCheckUtil alloc] init];

    NSString *successTitle = @"Success";
    UIAlertController *alert = [errorCheck checkBadInput:inputText
                                             withMessage:@"Please enter a unique team name"
                                              andDismiss:@"Dismiss"
                                      withSuccessMessage:@"You have joined a new team" title:successTitle];
    
    if ([alert.title isEqualToString:successTitle]) {
        [FirebaseManager isNewTeam:inputText withCompletion:^(BOOL result) {
            if (!result) {
                UIViewController *doesNotExistAlert = [errorCheck showAlertWithTitle:@"Error"
                                                                          andMessage:@"This team name is already taken, Please enter another team identifier"
                                                                     andDismissNamed:@"Ok"];
                [self presentViewController:doesNotExistAlert animated:YES completion:nil];
                return;
            }else if (result ){
                [self dismiss];
                [self.delegate createdNewTeam:inputText withPassword:password];
            }
        }];
    }else{
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (IBAction)cancelButtonPressed:(id)sender {
    self.teamTextField.text = @"";
    self.passwordTextField.text = @"";
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= MAX_INPUT_LENGTH;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
#pragma mark - Helper methods
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
