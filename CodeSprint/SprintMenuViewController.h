//
//  SprintMenuViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/8/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBorderedButton.h"
@interface SprintMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet CircleBorderedButton *createGroupButton;
@property (weak, nonatomic) IBOutlet CircleBorderedButton *findGroupButton;
@property (weak, nonatomic) IBOutlet CircleBorderedButton *removeButton;

@end
