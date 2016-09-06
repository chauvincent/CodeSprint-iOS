//
//  ManageTeamsViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/15/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageTeamViewControllerDelegate <NSObject>

- (void)didLeave:(NSMutableArray *)selected;

@end

@interface ManageTeamsViewController : UIViewController

@property (weak, nonatomic) id<ManageTeamViewControllerDelegate> delegate;

@end