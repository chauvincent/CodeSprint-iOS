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
- (IBAction)createDisplayButtonPressed:(id)sender {
}
#pragma mark - View Setup
-(CGSize)preferredContentSize{
    return CGSizeMake(280.0f, 320.0f);
}
-(void)setupView{
    self.navigationItem.title = @"Set Display Name";
}

@end
