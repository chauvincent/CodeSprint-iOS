//
//  ChatroomsTableViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/18/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatroomTableViewControllerDelegate <NSObject>

- (void)detachObservers:(NSMutableArray *)garbage andTeams:(NSMutableArray *)teams;

@end

@interface ChatroomsTableViewController : UITableViewController

@property (weak, nonatomic) id<ChatroomTableViewControllerDelegate> delegate;

@end
