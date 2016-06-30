//
//  PageContentViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/30/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end



@implementation PageContentViewController

@synthesize imageFile,index, contentImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentImageView.image = [UIImage imageNamed:self.imageFile];
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
