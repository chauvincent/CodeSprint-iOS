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
//#include "CodeSprint-Bridging-Header.h"

@import Firebase;
@interface LoginViewController () <UIWebViewDelegate>{
    NSString *responseCode;
    NSString *accessToken;
}

@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *githubLoginButton;
@property (strong, nonatomic) UIWebView *gitHubWebView;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *githubCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fbCenterConstraint;

@property (strong, nonatomic) AnimationGenerator *generator;
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
        [self.view addSubview:self.gitHubWebView];
        [self.view bringSubviewToFront:self.gitHubWebView];
        self.gitHubWebView.delegate = self;
    }
    return _gitHubWebView;
}

#pragma mark - UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (currentUser) {
      //  [self didSignInWith:currentUser];
        NSLog(@"already signed in");
    }
    
    // Animate views
    self.generator = [[AnimationGenerator alloc] initWithConstraints:@[self.labelCenterConstraint, self.githubCenterConstraint, self.fbCenterConstraint]];
}
-(void)viewDidAppear:(BOOL)animated {
    [self.generator animateScreenWithDelay:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

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
    [UIView animateWithDuration:0.5 animations:^{
        self.gitHubWebView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
    }];
    
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
    }
    return YES;
}


#pragma mark - User Helper Methods
-(void)didSignInWith:(FIRUser *)user{
    [FirebaseManager sharedInstance].usersName = user.displayName.length > 0 ? user.displayName : user.email;
    [FirebaseManager sharedInstance].photoUrl = user.photoURL;
    [FirebaseManager sharedInstance].signedIn = YES;

    NSLog(@"%@", user.photoURL);

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
