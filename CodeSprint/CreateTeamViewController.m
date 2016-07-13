//
//  CreateTeamViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/12/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CreateTeamViewController.h"
#import <RWBlurPopover/RWBlurPopover.h>
@interface CreateTeamViewController ()

//@property (nonatomic, strong) UITapGestureRecognizer *contentTapGesture;
@end

@implementation CreateTeamViewController
//
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
//- (void)dismiss {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//-(void)loadView{
//    [super loadView];
//    CGRect appBounds = [[UIScreen mainScreen] bounds];
//    UIView *contentView = [[UIView alloc] initWithFrame:appBounds];
//    contentView.backgroundColor = [UIColor blackColor];
//    self.view = contentView;
//    
//
//}
- (void)viewDidLoad {
//    [super viewDidLoad];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//
//    self.contentTapGesture = tap;
//    self.contentTapGesture.enabled = NO;
//    [self.view addGestureRecognizer:tap];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
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

@end
