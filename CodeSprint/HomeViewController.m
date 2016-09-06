//
//  HomeViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/22/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "HomeViewController.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "FirebaseManager.h"
#import "SettingsTableViewCell.h"
#import "Constants.h"
#import "CreateDisplayNameViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <pop/POP.h>
#import "ChatroomsTableViewController.h"
#import "EditProfileViewController.h"
#import "AnimationGenerator.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, CreateDisplayViewControllerDelegate, ChatroomTableViewControllerDelegate, EditProfileViewControllerDelegate>

@property (strong, nonatomic) NSString *photoURL;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end

@implementation HomeViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
   
    if ([FirebaseManager sharedInstance].isNewUser) {
        [self displaySetNameMenu];
    } else {
        [FirebaseManager retreiveUsersTeams];
    }
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [FirebaseManager removeAllObservers];
    NSString *currentPhoto = [[FirebaseManager sharedInstance].currentUser.photoURL absoluteString];
    
    if (![_photoURL isEqualToString:currentPhoto]) {   // Changed photo
        NSURL *url = [NSURL URLWithString:currentPhoto];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.profilePictureImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, UIImage *_Nonnull image) {
            self.profilePictureImageView.image = image;
            
        } failure:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, NSError *_Nonnull error) {
            NSLog(@"error in downloading image");
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}
//
//- (void)dealloc
//{
//    NSLog(@"HomeViewController NO LEAK");
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HomeToChatSegue"]) {
        ChatroomsTableViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

#pragma mark - View Setup Methods

- (void)setupViews
{
    self.navigationItem.title = @"CodeSprint";
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = GREY_COLOR;
    self.menuTableView.backgroundColor = GREY_COLOR;
    self.photoURL = [[FirebaseManager sharedInstance].currentUser.photoURL absoluteString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[FirebaseManager sharedInstance].currentUser.photoURL];
    [self.profilePictureImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, UIImage *_Nonnull image) {
            self.profilePictureImageView.image = image;
            
    } failure:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, NSError *_Nonnull error) {
            NSLog(@"error in downloading image");
    }];

    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPicture:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profilePictureImageView addGestureRecognizer:singleTap];
    
}

#pragma mark - IBActions

- (void)tappedPicture:(id)sender
{
    [self performSegueWithIdentifier:@"HomeToEditSegue" sender:nil];
}

- (void)displaySetNameMenu
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateDisplayNameViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CreateDisplayNameViewController"];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:nav];
    popover.throwingGestureEnabled = NO;
    popover.tapBlurToDismissEnabled = NO;
    [popover showInViewController:self];

}

#pragma mark - Logout Methods

- (void)dismiss
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

#pragma mark - CreateDisplayNameViewControllerDelegate

- (void)setDisplayName:(NSString *)userInput
{
    [FirebaseManager setUpNewUser:userInput];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell" forIndexPath:indexPath];
    [cell configureCellForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"HomeToSprintSegue" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"HomeToChatSegue" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"HomeToEditSegue" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"HomeToSettingSegue" sender:nil];
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];

    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

#pragma mark ChatroomTableViewControllerDelegate

- (void)detachObservers:(NSMutableArray *)garbage andTeams:(NSMutableArray *)teams
{
    if ([garbage count] != 0) {
        
        for (NSMutableDictionary *imageDictionary in garbage) {
            
            for (NSString *usersKey in imageDictionary) {
                    [[[[[[FIRDatabase database] reference] child:kCSUserHead] child:usersKey] child:kCSUserPhotoURL] removeAllObservers];
            }
        }
    }
    
    if ([teams count] > 0) {
        
        for (NSString *currentTeam in teams) {
            [[[[[FIRDatabase database] reference] child:kChatroomHead] child:currentTeam] removeObserverWithHandle:[FirebaseManager sharedInstance].chatroomHandle];
            [[[[[FIRDatabase database] reference] child:kTeamsHead] child:currentTeam] removeObserverWithHandle:[FirebaseManager sharedInstance].downloadImgHandle];
            [[[[[FIRDatabase database] reference] child:kChatroomHead] child:currentTeam] removeAllObservers];
            [[[[[FIRDatabase database] reference] child:kTeamsHead] child:currentTeam] removeAllObservers];
        }
    }
}

#pragma mark - EditProfileViewControllerDelegate

- (void)didChangeProfilePic:(UIImage *)img
{
    self.profilePictureImageView.image = img;
    [self.profilePictureImageView setNeedsDisplay];
}

@end
