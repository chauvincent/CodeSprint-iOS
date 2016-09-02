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

@property (weak, nonatomic) IBOutlet CustomTextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet AnimatedButton *saveChangesButton;
@property (weak, nonatomic) IBOutlet AnimatedButton *cancelButton;
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
        self.displayNameTextField.text = usernameInput;
        ;
        UIAlertController *alert = [errorCheck showAlertWithTitle:@"Success!" andMessage:@"Your display name has been updated. People in your team chat will identify you by this name." andDismissNamed:@"Ok"];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)tappedPicture:(id)sender{
    [self showImgPicker];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismiss];
}


#pragma mark - Helpers
- (void)showImgPicker {
   UIImagePickerController* imgPicker = [[UIImagePickerController alloc] init];
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
    UIImage *compressedImg = [self resizeImage:img];
    NSData *imgData = UIImageJPEGRepresentation(compressedImg, 1.0f);
    StorageService *service = [[StorageService alloc] init];
    [service uploadToImageData:imgData withCompletion:^(NSURL *imageUrl) {
        if (![[imageUrl absoluteString] isEqualToString:@"ERROR"]) {
            [FirebaseManager uploadedNewPhoto:imageUrl];
            [FirebaseManager sharedInstance].currentUser.photoURL = imageUrl;
            NSLog(@"%@",[FirebaseManager sharedInstance].currentUser.photoURL);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Helpers
-(UIImage *)resizeImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:imageData];
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
