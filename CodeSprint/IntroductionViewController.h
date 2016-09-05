//
//  IntroductionViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/22/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface IntroductionViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *PageViewController;
@property (strong, nonatomic) NSArray *pageImages;

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
