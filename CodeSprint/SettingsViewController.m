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

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet AnimatedButton *logoutButton;
@property (strong, nonatomic) IBOutlet AnimatedButton *deleteAccountButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View Setup
-(void)setupView{
    self.view.backgroundColor = GREY_COLOR;
    self.navigationItem.title = @"Settings";
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
}
-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions
- (IBAction)logoutButtonPressed:(id)sender {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Logout"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
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
- (IBAction)deleteAccountPressed:(id)sender {
    NSMutableArray *groupIds = [FirebaseManager sharedInstance].currentUser.groupsIDs;
    
    for (NSString *gid in groupIds) {
        [[[[[FIRDatabase database] reference] child:kTeamsHead] child:gid] removeAllObservers];
    }
    NSError *signOutError;
    [FirebaseManager deleteUser];

    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
