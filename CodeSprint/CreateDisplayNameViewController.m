//
//  CreateDisplayNameViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CreateDisplayNameViewController.h"
#import "ImageStyleButton.h"
#import "CustomTextField.h"
#import "FirebaseManager.h"

@interface CreateDisplayNameViewController ()
@property (weak, nonatomic) IBOutlet ImageStyleButton *createDisplayNameButton;
@property (weak, nonatomic) IBOutlet CustomTextField *displayNameTextField;

@end

@implementation CreateDisplayNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
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
- (IBAction)createDisplayButtonPressed:(id)sender {
    NSLog(@"create button pressed");
    NSString *usernameInput = self.displayNameTextField.text;
    BOOL valid = [self checkBadInput:usernameInput];
    if (valid) {
     
        
        [self.delegate setDisplayName:usernameInput];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - View Setup
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
-(void)setupView{
    self.navigationItem.title = @"Set Display Name";
}
#pragma mark - Helper
-(BOOL)checkBadInput:(NSString*)inputText{
    
    if ([inputText isEqualToString:@""]) {
        [self showAlertWithTitle:@"Error: No Input" andMessage:@"Please enter a display name."
                 andDismissNamed:@"Dismiss"];
        return false;
    }
    NSCharacterSet *charSet = [NSCharacterSet
                               characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-"];
    charSet = [charSet invertedSet];
    NSRange range = [inputText rangeOfCharacterFromSet:charSet];
    
    if (range.location != NSNotFound) {
        [self showAlertWithTitle:@"Invalid Characters" andMessage:@"Please enter a name containing only: [A-Z], [a-z], [0-9], -, _"
                 andDismissNamed:@"Dismiss"];
        return false;
    }
    return true; // valid input
}
-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andDismissNamed:(NSString*)dismiss{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:dismiss style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
