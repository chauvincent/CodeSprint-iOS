//
//  SearchTeamViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/14/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTeamViewControllerDelegate <NSObject>

-(void)joinNewTeam:(NSString*)teamName;
@optional
-(void)didJoinTeam;
@end

@interface SearchTeamViewController : UIViewController

@property(weak, nonatomic) id<SearchTeamViewControllerDelegate> delegate;

@end
