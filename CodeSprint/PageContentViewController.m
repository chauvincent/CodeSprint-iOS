//
//  PageContentViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/30/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "PageContentViewController.h"
#import "Constants.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GREY_COLOR;
    self.contentImageView.image = [UIImage imageNamed:self.imageFile];
     self.contentImageView.layer.cornerRadius = 50.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
