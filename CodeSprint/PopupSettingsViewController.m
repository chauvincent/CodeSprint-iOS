//
//  PopupSettingsViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/9/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "PopupSettingsViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "FirebaseManager.h"
#import "Constants.h"

@interface PopupSettingsViewController ()
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *completedButton;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) UITapGestureRecognizer *contentTapGesture;
@end

@implementation PopupSettingsViewController
-(void)loadView{
    [super loadView];
    [self setupView];
    switch (self.currentIndex) {
        case 0:
            self.navigationItem.title = @"Specification";
            self.descriptionTextView.text = @"";
            self.titleTextView.hidden = NO;
            break;
        case 1:
            self.navigationItem.title = @"View Goal";
            self.descriptionTextView.hidden = NO;
            self.titleTextView.hidden = NO;
            break;
        case 2:
            self.navigationItem.title = @"View Sprint";
            self.descriptionTextView.hidden = NO;
            self.titleTextView.hidden = NO;
            break;
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
-(void)setupView{
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
    self.navigationItem.leftBarButtonItem.title = @"OK";
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)removeButtonPressed:(id)sender {
}
- (IBAction)completeItemPressed:(id)sender {
}

@end
