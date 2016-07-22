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
@import Firebase;

@interface LoginViewController () <UIWebViewDelegate>{
    NSString *responseCode;
    NSString *accessToken;
}

@property (strong, nonatomic) AnimationGenerator *generator;

// Buttons and Views
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *githubLoginButton;
@property (strong, nonatomic) UIWebView *gitHubWebView;

// Animated Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *githubCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fbCenterConstraint;

@end

@implementation LoginViewController

#pragma mark - Keys
NSString *clientID = @"9bc3a5d15c66cd7c2168";
NSString *secretKey = @"f2ab75208ce318c15376ed9adee7db2c3b867a76";
NSString *callbackUrl = @"https://code-spring-ios.firebaseapp.com/__/auth/handler";

#pragma mark - Lazy Initializers
-(UIWebView *)gitHubWebView{
    if (!_gitHubWebView) {
        _gitHubWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) ];
    }
    return _gitHubWebView;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Login";

//    FIRUser *currentUser = [FIRAuth auth].currentUser;
//    if (currentUser) {
//        [self didSignInWith:currentUser];
//        NSLog(@"already signed in");
//    }

    // Animate views
    self.generator = [[AnimationGenerator alloc] initWithConstraints:@[self.labelCenterConstraint, self.githubCenterConstraint, self.fbCenterConstraint]];
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

#pragma mark - IBActions
- (IBAction)facebookLoginButtonPressed:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login  logInWithReadPermissions:@[@"public_profile"]
                  fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                      if (error){
                          NSLog(@"error in login");
                      }else if(result.isCancelled){
                          NSLog(@"canceld");
                      }else{
                          NSLog(@"logged in");
                          FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                           credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                          [[FIRAuth auth] signInWithCredential:credential
                                                    completion:^(FIRUser *user, NSError *error) {
                                                        [self didSignInWith:user];
                                                    }];
                      }
                  }];
}
- (IBAction)githubLoginButtonPressed:(id)sender {
    NSString *gitHubSignIn = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize/?client_id=%@", clientID];
    [self.gitHubWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:gitHubSignIn]]];
    [self.view addSubview:self.gitHubWebView];
    [self.view bringSubviewToFront:self.gitHubWebView];
    self.gitHubWebView.delegate = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.gitHubWebView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
    }];
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - self.view.frame.size.height;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    closeButton.tag = 1111;
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    
}
#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *currentURL = [request.URL absoluteString];
    if ([currentURL containsString:@"code="]) {
        NSRange indexOfCode = [currentURL rangeOfString:@"code="];
        responseCode = [currentURL substringFromIndex:indexOfCode.location + 5];
        [UIView animateWithDuration:0.5 animations:^{
            self.gitHubWebView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            [self.gitHubWebView removeFromSuperview];
        }];
        [self getAccessToken];
        NSLog(@"did sign in");

    }
    return YES;
}

- (IBAction)closeButtonPressed:(id)sender {
    for (UIView *view in [self.view subviews]) {
        // Remove close button
        if (view.tag == 1111) {
            [view removeFromSuperview];
            [self.gitHubWebView removeFromSuperview];
        }
    }
}
#pragma mark - User Helper Methods
-(void)didSignInWith:(FIRUser *)user{
    

    // TODO:
    // query firebase to see if user has a node with a display name
    // if display name is nil, prompt user to add a display name(unique and once)
    // update firebase node with display name and continue on
    
    // if did have a display name already, just retreive object and store into fbmanager
    
    NSString *displayName = user.displayName.length > 0 ? user.displayName : user.email;
    User *currentUser = [[User alloc] initUserWithId:user.uid withDisplay:displayName];
    currentUser.photoURL = user.photoURL;
    currentUser.didSetName = false;
    [FirebaseManager sharedInstance].currentUser = currentUser;
    
    [FirebaseManager lookUpUser:currentUser withCompletion:^(BOOL result) {
        NSLog(@"did return");
    }];
    
    NSLog(@"finished lookup");
    
    [self performSegueWithIdentifier:@"LoginToHomeSegue" sender:self];
}
-(void)updateUserInformation{

}

#pragma mark - GitHub Signin Helpers
-(void)getAccessToken{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *requiredParameters = @{@"client_id":clientID,
                                         @"client_secret":secretKey,
                                         @"code":responseCode};
    
    [manager POST:@"https://github.com/login/oauth/access_token" parameters:requiredParameters success:^(AFHTTPRequestOperation * operation, id responseObject) {
        accessToken = [responseObject valueForKey:@"access_token"];
        FIRAuthCredential *credentials = [FIRGitHubAuthProvider credentialWithToken:accessToken];
        [[FIRAuth auth] signInWithCredential:credentials
                                  completion:^(FIRUser *user, NSError *error) {
                                      [self didSignInWith:user];
                                  }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Something went wrong: %@", error);
    }];
}

@end
