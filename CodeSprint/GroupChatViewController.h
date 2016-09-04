//
//  GroupChatViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/18/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface GroupChatViewController : JSQMessagesViewController

@property (strong, nonatomic) NSString *currentTeam;
@property (strong, nonatomic) NSMutableDictionary *imageDictionary;
@property (strong, nonatomic) NSMutableDictionary *avaDictionary;
@end
