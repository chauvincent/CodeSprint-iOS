//
//  IntroductionViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/22/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "IntroductionViewController.h"
#include "Constants.h"

#include "AnimationGenerator.h"

@interface IntroductionViewController ()


@end

@implementation IntroductionViewController

#pragma mark - Lazy Initializers
-(NSArray *)pageImages{
    if (!_pageImages) {
        _pageImages = @[@"card1",@"card2"];
    }
    return _pageImages;
}

-(UIPageViewController*)PageViewController{
    if (!_PageViewController) {
        _PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        _PageViewController.dataSource = self;
    }
    return _PageViewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    self.navigationItem.title = @"Introduction";
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:self.PageViewController];
    [self.view addSubview:self.PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
    
}

-(PageContentViewController*)viewControllerAtIndex:(NSUInteger)index{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.index = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Datasource Methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((PageContentViewController*) viewController).index;
    if ((index == 0) || (index == NSNotFound)){
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index2 = ((PageContentViewController*) viewController).index;
    
    if (index2 == NSNotFound){
        return nil;
    }
    index2++;
    return [self viewControllerAtIndex:index2];
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.pageImages count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
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
