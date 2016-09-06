//
//  SettingsViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "SettingsViewController.h"
#import "AnimatedButton.h"
#import "FirebaseManager.h"
#import "Constants.h"
#import "AnimationGenerator.h"

@interface SettingsViewController ()

@property (strong, nonatomic) AnimationGenerator *generator;

@property (strong, nonatomic) IBOutlet AnimatedButton *logoutButton;
@property (strong, nonatomic) IBOutlet AnimatedButton *deleteAccountButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoutCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewY;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    self.generator = [[AnimationGenerator alloc] initWithConstraintsBottom:@[_stackViewY]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.generator animateScreenWithDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"SettingsViewController NO LEAK");
}

#pragma mark - View Setup

- (void)setupView
{
    self.view.backgroundColor = GREY_COLOR;
    self.navigationItem.title = @"Settings";
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)logoutButtonPressed:(id)sender
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Logout"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         
                                                         NSError *signOutError;
                                                         BOOL status = [[FIRAuth auth] signOut:&signOutError];
                                                       
                                                         if (!status) {
                                                             NSLog(@"Error signing out: %@", signOutError);
                                                             return;
                                                         }
                                                         
                                                         [FirebaseManager removeAllObservers];
                                                         
                                                         [FirebaseManager logoutUser];
                                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Logout"
                                                                   message:@"Are you sure you want to logout?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)deleteAccountPressed:(id)sender
{
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Logout"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         NSMutableArray *groupIds = [FirebaseManager sharedInstance].currentUser.groupsIDs;
                                                         
                                                         for (NSString *gid in groupIds) {
                                                             [[[[[FIRDatabase database] reference] child:kTeamsHead] child:gid] removeAllObservers];
                                                         }
                                                         FIRUser *user = [FIRAuth auth].currentUser;
                                                         
                                                         [user deleteWithCompletion:^(NSError *_Nullable error) {
                                                             if (error) {
                                                                 NSLog(@"error: %@", error.localizedDescription);
                                                             } else {
                                                                 NSLog(@"sucess");
                                                             }
                                                         }];
                                                         [FirebaseManager deleteUser];
                                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Logout"
                                                                   message:@"Are you sure you want to delete you account? If so, you will automatically leave all your teams."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

@end
