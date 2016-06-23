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
@import Firebase;
@interface LoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *githubLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *emailLoginButton;
@property (strong, nonatomic) UIWebView *gitHubWebView;

@end

@implementation LoginViewController

#pragma mark - Keys
NSString *clientID = @"9bc3a5d15c66cd7c2168";
NSString *secretKey = @"f2ab75208ce318c15376ed9adee7db2c3b867a76";

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (currentUser) {
        [self didSignInWith:currentUser];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
                                                           credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                                           .tokenString];
                          [[FIRAuth auth] signInWithCredential:credential
                                                    completion:^(FIRUser *user, NSError *error) {
                                                        [self updateUserInformation];
                                                    }];
                      }
                  }];
}
- (IBAction)githubLoginButtonPressed:(id)sender {
}
- (IBAction)emailLoginButtonPressed:(id)sender {
}

#pragma mark - Helper Methods
-(void)didSignInWith:(FIRUser *)user{
    
}
-(void)updateUserInformation{
//    if ([FBSDKAccessToken currentAccessToken]) {
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
//                                           parameters:@{@"fields" : @"name,age_range,first_name,locale,gender,last_name"}]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 NSDictionary *jsonData = (NSDictionary *)result;
//                 FIRUser *user = [FIRAuth auth].currentUser;
//                 
//                 if (user != nil) {
//                     NSString *name = user.displayName;
//                     NSString *email = user.email;
//                     NSURL *photoUrl = user.photoURL;
//                     NSString *uid = user.uid;  // The user's ID, unique to the Firebase
//                     // project. Do NOT use this value to
//                     // authenticate with your backend server, if
//                     // you have one. Use
//                     // getTokenWithCompletion:completion: instead.
//                     NSLog(@"NAME IS : %@", name);
//                     NSLog(@"Email IS : %@", email);
//                     NSLog(@"PhotoURL : %@", photoUrl);
//                     NSLog(@"UID : %@", uid);
//                 } else {
//                     // No user is signed in.
//                 }
//                 
//             }
//         }];
//    }
}

@end
