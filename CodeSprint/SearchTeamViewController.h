//
//  SearchTeamViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/14/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTeamViewControllerDelegate <NSObject>

-(BOOL)checkBadInput:(NSString*)inputText;
-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andDismissNamed:(NSString*)dismiss;

@end

@interface SearchTeamViewController : UIViewController

@property(weak, nonatomic) id<SearchTeamViewControllerDelegate> delegate;

@end
