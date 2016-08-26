//
//  Constants.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#pragma mark - CSUser Keys
extern NSString *const kCSUserHead;
extern NSString *const kCSUserDisplayKey;
extern NSString *const kCSUserDidSetDisplay;
extern NSString *const kCSUserPhotoURL;
extern NSString *const kCSUserTeamKey;
extern NSString *const kCSUserScrumKey;
extern NSString *const kCSUserOldPhotoURL;

#pragma mark - Team Keys
extern NSString *const kTeamsHead;
extern NSString *const kTeamsScrumKey;
extern NSString *const kMembersHead;
extern NSString *const kTeamsPassword;

#pragma mark - Scrum Keys
extern NSString *const kScrumHead;
extern NSString *const kScrumCreator;
extern NSString *const kScrumProductSpecs;
extern NSString *const kScrumSprintGoals;
extern NSString *const kScrumProductComplete;

#pragma mark - Artifacts Keys
extern NSString *const kScrumSprintTitle;
extern NSString *const kScrumSprintDeadline;
extern NSString *const kScrumSprintCompleted;
extern NSString *const kScrumSprintFinishDate;
extern NSString *const kScrumSprintDescription;

#pragma mark - Sprint Keys
extern NSString *const kSprintHead;
extern NSString *const kSprintGoalReference;
extern NSString *const kSprintTitle;
extern NSString *const kSprintDeadline;

#pragma mark - Chat Keys
extern NSString *const kChatroomHead;
extern NSString *const kChatroomSenderID;
extern NSString *const kChatroomSenderText;
extern NSString *const kChatroomDisplayName;



#pragma mark - Color Constants

#define SHADOW_COLOR 157.0/255.0
#define DARK_BLUE [UIColor colorWithRed:56.0/255.0 green:133.0/255.0 blue:208.0/255.0 alpha:1.0]
#define LIGHT_BLUE [UIColor colorWithRed:63.0/255.0 green:152.0/255.0 blue:228.0/255.0 alpha:1.0]
//#define GREY_COLOR [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0]
#define GREY_COLOR [UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]
#define LIGHT_GREY_COLOR [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:0.5]
#define SHADOW = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]
#define FEINT_LIGHT_BLUE [UIColor colorWithRed:63.0/255.0 green:152.0/255.0 blue:228.0/255.0 alpha:1.0]
#define BLUE_MIST [UIColor colorWithRed:189.0/255.0 green:220.0/255.0 blue:241.0/255.0 alpha:1.0]

@end

