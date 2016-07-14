//
//  CreateTeamViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/12/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CreateTeamViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
#import "ImageStyleButton.h"

@interface CreateTeamViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *contentTapGesture;
@end

@implementation CreateTeamViewController

-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButtons];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.contentTapGesture = tap;
    self.contentTapGesture.enabled = NO;
    
    [self.view addGestureRecognizer:tap];


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

-(void)setupButtons{
    UIImage* image3 = [UIImage imageNamed:@"Close-Button"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image3 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss)
         forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *closeButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = closeButton;
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
