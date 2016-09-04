//
//  EditProfileViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditProfileViewControllerDelegate <NSObject>

-(void)didChangeProfilePic:(UIImage*)img;

@end


@interface EditProfileViewController : UIViewController

@property (weak, nonatomic) id<EditProfileViewControllerDelegate> delegate;

@end
