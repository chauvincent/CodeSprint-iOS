//
//  FirebaseManager.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Sprint.h"
#import "User.h"
@import Firebase;

#pragma mark - Database References
@interface FirebaseManager : NSObject{
    FIRDatabaseReference *ref;
    FIRDatabaseReference *teamsRefs;
    FIRDatabaseReference *userRefs;
}
+ (FirebaseManager *) sharedInstance;

#pragma mark - App State Properties
@property (strong, nonatomic) User *currentUser;
@property (assign) BOOL isNewUser;

#pragma mark - User Management
+ (void)logoutUser;
+ (void)updateUserInfo;
+ (void)lookUpUser:(User*)currentUser withCompletion:(void (^)(BOOL result))block;
+ (void)setUpNewUser:(NSString*)displayName;

#pragma mark - Query Functions
+ (void)isNewTeam:(NSString *)teamName withCompletion:(void (^)(BOOL result))block;


#pragma mark - Insertion/Deletetion Functions
+ (void)createTeamWith:(Team *)teamInformation;
+ (void)addUserToTeam:(NSString*)teamName andUser:(NSString*)uid; 

@end
