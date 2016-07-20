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


@end

@interface SearchTeamViewController : UIViewController

@property(strong, nonatomic) id<SearchTeamViewControllerDelegate> delegate;

@end
