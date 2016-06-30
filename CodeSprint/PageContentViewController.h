//
//  PageContentViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/30/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property NSUInteger index;
@property NSString *imageFile;

@end
