//
//  CreateDisplayNameViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CreateDisplayNameViewController.h"
#import "ImageStyleButton.h"
#import "CustomTextField.h"
#import "FirebaseManager.h"
#import "ErrorCheckUtil.h"

#define MAX_INPUT_LENGTH 20

@interface CreateDisplayNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet ImageStyleButton *createDisplayNameButton;
@property (weak, nonatomic) IBOutlet CustomTextField *displayNameTextField;

@end

@implementation CreateDisplayNameViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)createDisplayButtonPressed:(id)sender
{
    NSString *usernameInput = self.displayNameTextField.text;
    ErrorCheckUtil *errorCheck = [[ErrorCheckUtil alloc] init];

    if ([usernameInput isEqualToString:@""]) {
        UIAlertController *alert = [errorCheck showAlertWithTitle:@"Error" andMessage:@"Please enter a display name" andDismissNamed:@"Ok"];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //[FirebaseManager sharedInstance].currentUser.displayName = usernameInput;
        [self.delegate setDisplayName:usernameInput];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - View Setup

- (CGSize)preferredContentSize
{
    return CGSizeMake(280.0f, 320.0f);
}

- (void)setupView
{
    self.navigationItem.title = @"Set Display Name";
}

#pragma mark - UITextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return newLength <= MAX_INPUT_LENGTH;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

@end
