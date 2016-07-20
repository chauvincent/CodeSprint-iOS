//
//  SearchTeamViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/14/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "SearchTeamViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "ImageStyleButton.h"
#import "FirebaseManager.h"
#import "CustomTextField.h"


@interface SearchTeamViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *inputNameTextField;
@property (nonatomic, strong) UITapGestureRecognizer *contentTapGesture;
@property (weak, nonatomic) IBOutlet ImageStyleButton *searchTeamButton;
@property (assign) BOOL didCall;
@end

@implementation SearchTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _didCall = false;
    [self setupButtons];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
-(void)setupButtons{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.contentTapGesture = tap;
    self.contentTapGesture.enabled = NO;
    [self.view addGestureRecognizer:tap];
    
    UIImage* closeImage = [UIImage imageNamed:@"Close-Button"];
    CGRect frameimg = CGRectMake(0, 0, closeImage.size.width, closeImage.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:closeImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *closeButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = closeButton;
    self.navigationItem.title = @"Search";
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - IBActions
- (IBAction)searchButtonPressed:(id)sender {
    _didCall = false;
    NSString *inputText = self.inputNameTextField.text;
    
    BOOL badInput = ![self.delegate checkBadInput:inputText];
    if (badInput) {
        NSLog(@"Bad input handled");
        return;
    }
    [FirebaseManager isNewTeam:inputText withCompletion:^(BOOL result) {
        if (result) {
            [self.delegate showAlertWithTitle:@"Error" andMessage:@"This team name is already taken, Please enter another team identifier."
                              andDismissNamed:@"Ok"];
            _didCall = false;
            return;
        }else if (!result && !_didCall){
            NSLog(@"join team");
            _didCall = true;
            [self.delegate joinNewTeam:inputText];
            [self dismiss];
        }
    }];
}
@end
