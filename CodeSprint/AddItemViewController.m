//
//  AddItemViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/2/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "AddItemViewController.h"
#import "Constants.h"
#import "FirebaseManager.h"
#import "CustomTextField.h"
#import "CustomTextView.h"

@interface AddItemViewController ()
@property (nonatomic, strong) UITapGestureRecognizer *contentTapGesture;
@property (strong, nonatomic) IBOutlet CustomTextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (strong, nonatomic) IBOutlet CustomTextField *titleTextField;
@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupButtons];
    self.navigationItem.title = @"Add";
    NSLog(@"current index: %lu", (unsigned long)self.index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - View Setup
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
-(void)setupView{

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
- (IBAction)createButtonPressed:(id)sender {
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

@end
