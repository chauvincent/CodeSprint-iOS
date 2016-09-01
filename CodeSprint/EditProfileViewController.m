//
//  EditProfileViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CustomTextField.h"
#import "AnimatedButton.h"
#include "Constants.h"
#include "ErrorCheckUtil.h"
#include "FirebaseManager.h"
#import "CircleImageView.h"
#import <AFNetworking.h>
#import "StorageService.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet CustomTextField *displayNameTextField;
@property (strong, nonatomic) IBOutlet UISwitch *showDisplaySwitch;
@property (strong, nonatomic) IBOutlet AnimatedButton *saveChangesButton;
@property (strong, nonatomic) IBOutlet AnimatedButton *cancelButton;

@property (weak, nonatomic) IBOutlet CircleImageView *profileImageView;

@end


@implementation EditProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View Setup
- (void)setupView{
    self.view.backgroundColor = GREY_COLOR;
    self.navigationItem.title = @"Edit Profile";
    self.displayNameTextField.backgroundColor = [UIColor whiteColor];
    self.displayNameTextField.placeholder = [FirebaseManager sharedInstance].currentUser.displayName;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;

    NSString *old = [[NSUserDefaults standardUserDefaults] objectForKey:@"PrivatePhoto"];
    if (old == nil) {
        [self.showDisplaySwitch setOn:YES];
    }else if([old isEqualToString:@"PRIVATE"]){
        [self.showDisplaySwitch setOn:NO];
    }else if([old isEqualToString:@"PUBLIC"]){
        [self.showDisplaySwitch setOn:YES];
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPicture:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImageView addGestureRecognizer:singleTap];
}
- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions
- (IBAction)saveChangesButtonPressed:(id)sender {
    
    NSString *usernameInput = self.displayNameTextField.text;
    ErrorCheckUtil *errorCheck = [[ErrorCheckUtil alloc] init];
    if ([usernameInput isEqualToString:@""]) {
        UIAlertController *alert = [errorCheck showAlertWithTitle:@"Error" andMessage:@"Please enter a display name" andDismissNamed:@"Ok"];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [FirebaseManager setUpNewUser:usernameInput];
    }
    [self dismiss];
}
- (void)tappedPicture:(id)sender{
    [self showImgPicker];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismiss];
}
- (IBAction)toggled:(id)sender {
    BOOL showMyPhoto = self.showDisplaySwitch.isOn;
    if (!showMyPhoto) {
        [FirebaseManager setPlaceHolderImageAsPhoto];
    }else{
        [FirebaseManager togglePlaceholderWithOld];
    }
    NSString *newSetting = showMyPhoto ? @"PUBLIC"  : @"PRIVATE";
    [[NSUserDefaults standardUserDefaults] setObject:newSetting forKey:@"PrivatePhoto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Helpers
- (void)showImgPicker {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = info[UIImagePickerControllerEditedImage];
    if (!img){
        img = info[UIImagePickerControllerOriginalImage];
    }
    
    NSData *imgData = UIImageJPEGRepresentation(img, 0.9);
    StorageService *service = [[StorageService alloc] init];
    [service uploadToImageData:imgData];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Helpers


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
