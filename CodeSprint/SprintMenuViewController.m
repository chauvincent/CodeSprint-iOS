//
//  SprintMenuViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/8/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "SprintMenuViewController.h"

@interface SprintMenuViewController ()

@end

@implementation SprintMenuViewController

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

-(void)setupView{

    [self.createGroupButton setBackgroundImage:[UIImage imageNamed:@"create-button2"] forState:UIControlStateNormal];
    //self.createGroupButton.imageView.image = [UIImage imageNamed:@"create-button"];
    self.createGroupButton.contentMode = UIViewContentModeScaleToFill;
    self.createGroupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.createGroupButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [self.findGroupButton setBackgroundImage:[UIImage imageNamed:@"find-button"] forState:UIControlStateNormal];
    //self.createGroupButton.imageView.image = [UIImage imageNamed:@"create-button"];
    self.findGroupButton.contentMode = UIViewContentModeScaleToFill;
    self.findGroupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.findGroupButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [self.findGroupButton setBackgroundImage:[UIImage imageNamed:@"remove-button"] forState:UIControlStateNormal];
    //self.createGroupButton.imageView.image = [UIImage imageNamed:@"create-button"];
    self.findGroupButton.contentMode = UIViewContentModeScaleToFill;
    self.findGroupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.findGroupButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
}

@end
