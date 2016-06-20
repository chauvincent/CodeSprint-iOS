//
//  LoginViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import Firebase;
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *githubLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *emailLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

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
-(void)updateUserInformation{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:@{@"fields" : @"name,age_range,first_name,locale,gender,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSDictionary *jsonData = (NSDictionary *)result;
                 
             }
         }];
    }
}

@end
