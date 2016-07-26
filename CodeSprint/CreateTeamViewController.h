//
//  CreateTeamViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/12/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageStyleButton.h"

@protocol CreateTeamViewControllerDelegate <NSObject>

-(void)createdNewTeam:(NSString*)inputText;

@end

@interface CreateTeamViewController : UIViewController

@property (weak, nonatomic) IBOutlet ImageStyleButton *createButton;
@property (weak, nonatomic) IBOutlet ImageStyleButton *clearButton;
@property (weak, nonatomic) id<CreateTeamViewControllerDelegate> delegate;

@end
