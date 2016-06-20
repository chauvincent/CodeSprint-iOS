//
//  LoginViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *githubLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *emailLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    // Do any additional setup after loading the view.
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
#pragma mark - IBActions
- (IBAction)facebookLoginButtonPressed:(id)sender {
}
- (IBAction)githubLoginButtonPressed:(id)sender {
}
- (IBAction)emailLoginButtonPressed:(id)sender {
}


@end
