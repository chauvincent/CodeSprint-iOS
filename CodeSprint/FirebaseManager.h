//
//  FirebaseManager.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Artifacts.h"
#import "User.h"
@import Firebase;

#pragma mark - Database References
@interface FirebaseManager : NSObject{
    FIRDatabaseReference *refs;
    FIRDatabaseReference *teamsRefs;
    FIRDatabaseReference *userRefs;
    FIRDatabaseReference *scrumRefs;
}
+ (FirebaseManager *) sharedInstance;

#pragma mark - App State Properties
@property (strong, nonatomic) User *currentUser;
@property (assign) BOOL isNewUser;

#pragma mark - User Management
+ (void)logoutUser;
+ (void)lookUpUser:(User*)currentUser withCompletion:(void (^)(BOOL result))block;
+ (void)setUpNewUser:(NSString*)displayName;
+ (void)retreiveUsersTeams;

#pragma mark - Observers
+ (void)observeNewTeams;
+ (void)observeScrumNode:(NSString*)scrumKey withCompletion:(void (^)(Artifacts *artifact))block;
#pragma mark - Query Functions
+ (void)isNewTeam:(NSString *)teamName withCompletion:(void (^)(BOOL result))block;


#pragma mark - Insertion/Deletetion Functions
+ (void)createTeamWith:(Team *)teamInformation withCompletion:(void (^)(BOOL result))block;
+ (void)addUserToTeam:(NSString*)teamName andUser:(NSString*)uid withCompletion:(void (^)(BOOL result))block; 

#pragma mark - Scrum Functions
+ (void)addProductSpecToScrum:(NSString*)scrumKey withArtifact:(Artifacts*)artifact withCompletion:(void (^)(BOOL completed))block;
+ (void)addSprintGoalToScrum:(NSString*)scrumKey withArtifact:(Artifacts*)artifact withCompletion:(void (^)(BOOL completed))block;
+ (void)createSprintFor:(NSString*)scrumKey withArtifact:(Artifacts*)artifact withCompletion:(void (^)(BOOL completed))block;
+ (void)updateSprintFor:(NSString*)scrumKey withGoalRefs:(NSMutableArray*)refs andCollectionIndex:(NSInteger)index withArtifact:(Artifacts*)artifact withCompletion:(void (^)(Artifacts* artifact))block;

@end
