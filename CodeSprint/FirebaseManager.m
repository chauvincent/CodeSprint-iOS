//
//  FirebaseManager.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "FirebaseManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#include "Constants.h"
#include "User.h"
#include "Artifacts.h"

@implementation FirebaseManager

#pragma mark - Singleton
+ (FirebaseManager*)sharedInstance{
    static FirebaseManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FirebaseManager alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - References Lazy Initializers
- (FIRDatabaseReference*)refs{
    if (!refs) {
        refs = [[FIRDatabase database] reference];
    }
    return refs;
}
- (FIRDatabaseReference*)teamRefs{
    if (!teamsRefs) {
        teamsRefs = [[self refs] child:kTeamsHead];
    }
    return teamsRefs;
}
- (FIRDatabaseReference*)userRefs{
    if (!userRefs) {
        userRefs = [[self refs] child:kCSUserHead];
    }
    return userRefs;
}
- (FIRDatabaseReference*)scrumRefs{
    if (!scrumRefs) {
        scrumRefs = [[self refs] child:kScrumHead];
    }
    return scrumRefs;
}
#pragma mark - Reference Getters
+ (FIRDatabaseReference *)mainRef {
    return [self sharedInstance].refs;
}
+ (FIRDatabaseReference *)teamRef {
    return [self sharedInstance].teamRefs;
}
+ (FIRDatabaseReference *)userRef{
    return [self sharedInstance].userRefs;
}
+ (FIRDatabaseReference *)scrumRef{
    return [self sharedInstance].scrumRefs;
}

#pragma mark - User Management
+ (void)logoutUser{
    [FirebaseManager sharedInstance].currentUser = nil;
}
+ (void)setUpNewUser:(NSString*)displayName{
    NSString *uid = [FirebaseManager sharedInstance].currentUser.uid;
    [[[self userRef] child:uid] updateChildValues:@{kCSUserDidSetDisplay : @1,
                                                    kCSUserDisplayKey : displayName}];
}
+ (void)lookUpUser:(User*)currentUser withCompletion:(void (^)(BOOL result))block{
    __block BOOL theResult = false;
    [[[self userRef] child:currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.value == [NSNull null]) {
            [[[self userRef] child:currentUser.uid] updateChildValues:@{kCSUserDidSetDisplay : @0}];
            block(false);
        }else{
            FIRDatabaseQuery *userQuery = [[[self userRef] child:currentUser.uid] queryOrderedByChild:kCSUserDisplayKey];
            [userQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                if (snapshot.value) {
                    NSDictionary *response = (NSDictionary*)snapshot.value;
                    theResult = ([response objectForKey:kCSUserDisplayKey] ? true : false);
                }
                block(theResult);
            }];
        }
    }];
}
+ (void)retreiveUsersTeams{
    FIRDatabaseQuery *usersQuery = [[[self userRef] child:[FirebaseManager sharedInstance].currentUser.uid] queryOrderedByChild:kCSUserTeamKey];
    [usersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *response = (NSDictionary*)snapshot.value;
        if ([[response allKeys] containsObject:kCSUserTeamKey]) {
            [FirebaseManager sharedInstance].currentUser.groupsIDs = [[response objectForKey:kCSUserTeamKey] mutableCopy];
        }else{
            NSLog(@"No teams");
        }
    }];
}
+ (void)observeNewTeams{
    FIRDatabaseQuery *usersQuery = [[[self userRef] child:[FirebaseManager sharedInstance].currentUser.uid] queryOrderedByChild:kCSUserTeamKey];
    [usersQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"Observer Firing %@", snapshot.value);
        NSDictionary *response = (NSDictionary*)snapshot.value;
        if ([[response allKeys] containsObject:kCSUserTeamKey]) {
            [FirebaseManager sharedInstance].currentUser.groupsIDs = [[response objectForKey:kCSUserTeamKey] mutableCopy];
            for (NSString *groupID in [FirebaseManager sharedInstance].currentUser.groupsIDs) {
                FIRDatabaseQuery *scrumQuery = [[[self teamRef] child:groupID] queryOrderedByChild:kTeamsScrumKey];
                [scrumQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSDictionary *scrumSnap = (NSDictionary*)snapshot.value;
                    NSString *scrumKey = scrumSnap[kTeamsScrumKey];
                   [[FirebaseManager sharedInstance].currentUser.scrumIDs setObject:scrumKey forKey:groupID];
                }];
            }
        }else{
            [FirebaseManager sharedInstance].currentUser.groupsIDs = [[NSMutableArray alloc] init];
        }
    }];
}

#pragma mark - Queries
+ (void)isNewTeam:(NSString *)teamName withCompletion:(void (^)(BOOL result))block{
    __block NSDictionary *response = [[NSDictionary alloc] init];
    [[[self teamRef] child:teamName] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        response = (NSDictionary*)snapshot.value;
        BOOL isNew = ([response isEqual:[NSNull null]]) ? true : false;
        block(isNew);
    }];
}
#pragma mark - Team Management
+ (void)createTeamWith:(Team *)teamInformation withCompletion:(void (^)(BOOL result))block{
    NSArray *newTeams = [self sharedInstance].currentUser.groupsIDs;
    NSString *currentUID = [self sharedInstance].currentUser.uid;
    [[[self userRef] child:currentUID] updateChildValues:@{kCSUserTeamKey : newTeams}];
    
    FIRDatabaseReference *scrumNode = [[self scrumRef] childByAutoId];
    FIRDatabaseReference *teamRef =[[self teamRef] child:teamInformation.nickname];
    [teamRef updateChildValues:@{kMembersHead : teamInformation.membersUID,
                                 kTeamsScrumKey : scrumNode.key}];
    [scrumNode setValue:@{kScrumCreator:currentUID}];
    block(true);
}
+ (void)addUserToTeam:(NSString*)teamName andUser:(NSString*)uid withCompletion:(void (^)(BOOL result))block{
    __block BOOL alreadyJoined = false;
    FIRDatabaseQuery *membersQuery = [[[[self teamRef] child:teamName] child:kMembersHead] queryOrderedByChild:uid];
    [membersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        for (FIRDataSnapshot *child in snapshot.children) {
            if ([child.value isEqualToString:uid]) {
                alreadyJoined = true;
                block(false);
            }
        }
        if(!alreadyJoined){
            NSMutableArray *oldMembers = [(NSArray*)snapshot.value mutableCopy];
            [oldMembers addObject:uid];
            FIRDatabaseReference *teamRef =[[self teamRef] child:teamName];
            FIRDatabaseQuery *usersQuery = [[[self userRef] child:uid] queryOrderedByChild:kCSUserTeamKey];
            [teamRef updateChildValues:@{kMembersHead :[NSArray arrayWithArray:oldMembers]}];
            [usersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *response = (NSDictionary*)snapshot.value;
                NSArray *newTeams;
                if ([[response allKeys] containsObject:kCSUserTeamKey]) {
                    NSMutableArray *oldTeams = [[response objectForKey:kCSUserTeamKey] mutableCopy];
                    [oldTeams addObject:teamName];
                    newTeams = [oldTeams mutableCopy];
                }else{
                    newTeams = [NSArray arrayWithArray:[NSMutableArray arrayWithObject:teamName]];
                }
                [[[[self userRef] child:uid] child:kCSUserTeamKey] setValue:newTeams];
                block(true);
            }];
        }
    }];
}

#pragma mark - Scrum Management
+ (void)observeScrumNode:(NSString*)scrumKey withCompletion:(void (^)(Artifacts *artifact))block{
    FIRDatabaseQuery *scrumQuery = [[[self scrumRef] child:scrumKey] queryOrderedByChild:kScrumCreator];
    [scrumQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *productSpecs = [[NSMutableArray alloc] init];
        NSMutableArray *allGoals = [[NSMutableArray alloc] init];
        NSMutableArray *sprintCollection = [[NSMutableArray alloc] init];
        NSDictionary *response = (NSDictionary*)snapshot.value;
        
        NSLog(@"respones is : %@", response);
        if ([[response allKeys] containsObject:kScrumProductSpecs]) {
            productSpecs = response[kScrumProductSpecs];
        }
        
        if ([[response allKeys] containsObject:kScrumSprintGoals]) {
//            allGoals = response[kScrumSprintGoals];
            NSArray *test = (NSArray*)response[kScrumSprintGoals];
            for (NSDictionary *dict in test) {
                [allGoals addObject:dict];
            }
            NSLog(@"%@", allGoals);
        }
        if ([[response allKeys] containsObject:kSprintHead]) {
            NSLog(@"has scrum");
            NSArray *sprintIntervals = (NSArray*)response[kSprintHead];
            for (NSDictionary *dict in sprintIntervals) {
                [sprintCollection addObject:dict];
            }
            
        }
        Artifacts *artifact = [[Artifacts alloc] initWithProductSpecs:productSpecs andGoals:allGoals withSprints:sprintCollection];
        block(artifact);
    }];
}
+ (void)addProductSpecToScrum:(NSString*)scrumKey withArtifact:(Artifacts*)artifact withCompletion:(void (^)(BOOL completed))block{
    
    FIRDatabaseReference *scrumRef = [[self scrumRef] child:scrumKey];
    [scrumRef updateChildValues:@{kScrumProductSpecs:artifact.productSpecs}];
    block(true);
}
+ (void)addSprintGoalToScrum:(NSString*)scrumKey withArtifact:(Artifacts*)artifact withCompletion:(void (^)(BOOL completed))block{
    FIRDatabaseReference *scrumRef = [[self scrumRef] child:scrumKey];
    [scrumRef updateChildValues:@{kScrumSprintGoals:artifact.sprintGoals}];
    block(true);
}
+ (void)createSprintFor:(NSString*)scrumKey withArtifact:(Artifacts*)artifact withCompletion:(void (^)(BOOL completed))block{
    FIRDatabaseReference *scrumRef = [[self scrumRef] child:scrumKey];
    [scrumRef updateChildValues:@{kSprintHead:artifact.sprintCollection}];
    block(true);
}


@end
