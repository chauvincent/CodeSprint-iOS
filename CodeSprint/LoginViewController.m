//
//  LoginViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//
#import "LoginViewController.h"
#import "FirebaseManager.h"
#import <AFNetworking.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#include "Constants.h"
#include "AnimationGenerator.h"
#import "HomeViewController.h"
#import "CustomTextField.h"
#import "AnimatedButton.h"
#import "ErrorCheckUtil.h"

@import Firebase;

@interface LoginViewController () <UIWebViewDelegate, UITextFieldDelegate>{
    NSString *responseCode;
    NSString *accessToken;
}

@property (strong, nonatomic) AnimationGenerator *generator;
@property (strong, nonatomic) AnimationGenerator *generator2;

@property (weak, nonatomic) IBOutlet CustomTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet AnimatedButton *createButton;
@property (weak, nonatomic) IBOutlet AnimatedButton *loginButton;

// Buttons and Views
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property (strong, nonatomic) UIWebView *gitHubWebView;
@property (strong, nonatomic) UIWebView *policyWebView;

// Animated Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewCenterX;

@end

@implementation LoginViewController

#pragma mark - Keys
NSString *clientID = @"6e0aa67e5343ab805db3";
NSString *secretKey = @"88c8d081b80ab97bbaa5c2ccfc7937d383f86564";
NSString *callbackUrl = @"https://code-spring-ios.firebaseapp.com/__/auth/handler";

#pragma mark - Lazy Initializers

-(UIWebView *)policyWebView{
    if (!_policyWebView) {
        _policyWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _policyWebView;
}

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    self.generator = [[AnimationGenerator alloc] initWithConstraints:@[self.labelCenterConstraint]];
}
-(void)viewDidAppear:(BOOL)animated {
    [self.generator animateScreenWithDelay:0.8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginToHomeSegue"]) {

    }
}
#pragma mark - Setup
-(void)setupView{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    self.navigationItem.title = @"Login";
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}
-(void)dismiss{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - IBActions
- (IBAction)loginButtonPressed:(id)sender {
    NSString *inputText = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    ErrorCheckUtil *errorCheck = [[ErrorCheckUtil alloc] init];
    if ([inputText isEqualToString:@""] || ![inputText containsString:@"@"]) {
        UIAlertController *badEmail = [errorCheck showAlertWithTitle:@"Invalid Email" andMessage:@"Please enter a valid email address." andDismissNamed:@"OK"];
        [self presentViewController:badEmail animated:YES completion:nil];
    } else if ([password isEqualToString:@""] || [password length] < 6) {
        UIAlertController *badPass = [errorCheck showAlertWithTitle:@"Invalid Password" andMessage:@"Please enter a password with more than six characters." andDismissNamed:@"OK"];
        [self presentViewController:badPass animated:YES completion:nil];
    } else {
        [[FIRAuth auth] signInWithEmail:inputText password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                NSString *errorName = @"Error";
                NSString *errorMsg = @"Error";
                if (([@(error.code) isEqual:@(17009)])) {
                    errorMsg = @"Invalid password. Please try again.";
                } else if(([@(error.code) isEqual:@(17011)])){
                    errorMsg = @"The email you entered does not exist. Please enter a valid email or create an account.";
                } else {
                    errorMsg = @"Please try again later.";
                }
                UIAlertController *errorAlert = [errorCheck showAlertWithTitle:errorName andMessage:errorMsg andDismissNamed:@"OK"];
                [self presentViewController:errorAlert animated:YES completion:nil];
            }else{
              // success
                FIRUser *currentUser = user;
                [self didSignInWith:currentUser];
            }
        }];
    }
}
- (IBAction)createButtonPressed:(id)sender {
    NSString *inputText = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    ErrorCheckUtil *errorCheck = [[ErrorCheckUtil alloc] init];

    if ([inputText isEqualToString:@""] || ![inputText containsString:@"@"]) {
        UIAlertController *badEmail = [errorCheck showAlertWithTitle:@"Invalid Email" andMessage:@"Please enter a valid email address." andDismissNamed:@"OK"];
        [self presentViewController:badEmail animated:YES completion:nil];
    } else if ([password isEqualToString:@""] || [password length] < 6) {
        UIAlertController *badPass = [errorCheck showAlertWithTitle:@"Invalid Password" andMessage:@"Please enter a password with more than six characters." andDismissNamed:@"OK"];
        [self presentViewController:badPass animated:YES completion:nil];
    } else {
        [[FIRAuth auth] createUserWithEmail:inputText password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                NSString *errorName = @"Error";
                NSString *errorMsg = @"Error";
                if ([@(error.code) isEqual:@(17007)]) {
                    errorMsg = @"This email is already in-use. Please use another email or sign-in with an existing one.";
                }else {
                    errorMsg = @"Unexpected Error, Please try again later.";
                }
                UIAlertController *otherErrors = [errorCheck showAlertWithTitle:errorName andMessage:errorMsg andDismissNamed:@"OK"];
                [self presentViewController:otherErrors animated:YES completion:nil];
            } else {
               // Successfuly created
                FIRUser *currentUser = user;
                [self didSignInWith:currentUser];
            }
            
        }];
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    for (UIView *view in [self.view subviews]) {
        // Remove close button
        if (view.tag == 1112) {
            [view removeFromSuperview];
            [self.policyWebView removeFromSuperview];
        }
    }
}
#pragma mark - User Helper Methods
-(void)didSignInWith:(FIRUser *)user{
    NSString *displayName = user.displayName.length > 0 ? user.displayName : @"DEFAULT";
    User *currentUser = [[User alloc] initUserWithId:user.uid withDisplay:displayName];
    currentUser.didSetName = false;
    
    [FirebaseManager sharedInstance].currentUser = currentUser;
    [FirebaseManager lookUpUser:currentUser withCompletion:^(BOOL result) {
        if(result){
            [FirebaseManager sharedInstance].isNewUser = !result;
        }else{
            [FirebaseManager sharedInstance].isNewUser = !result;
        }
        [self performSegueWithIdentifier:@"LoginToHomeSegue" sender:self];
    }];
    
}

#pragma mark - Privacy Policy
- (IBAction)privacyButtonPressed:(id)sender {
    NSString *policyURL = @"https://www.iubenda.com/privacy-policy/7902422";
    [self.policyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:policyURL]]];
    [self.view addSubview:self.policyWebView];
    [self.view bringSubviewToFront:self.policyWebView];
    self.policyWebView.delegate = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.policyWebView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
    }];
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - self.view.frame.size.height;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    closeButton.tag = 1112;
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 35;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
