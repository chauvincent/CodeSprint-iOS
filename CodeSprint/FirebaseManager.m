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
- (FIRDatabaseReference*)ref{
    if (!ref) {
        ref = [[FIRDatabase database] reference];
    }
    return ref;
}
- (FIRDatabaseReference*)teamRefs{
    if (!teamsRefs) {
        teamsRefs = [[self ref] child:kTeamsHead];
    }
    return teamsRefs;
}
- (FIRDatabaseReference*)userRefs{
    if (!userRefs) {
        userRefs = [[self ref] child:kCSUserHead];
    }
    return userRefs;
}
#pragma mark - Reference Getters
+ (FIRDatabaseReference *)mainRef {
    return [FirebaseManager sharedInstance].ref;
}
+ (FIRDatabaseReference *)teamRef {
    return [FirebaseManager sharedInstance].teamRefs;
}
+ (FIRDatabaseReference *)userRef{
    return [FirebaseManager sharedInstance].userRefs;
}

#pragma mark - User Management
+ (void)logoutUser{
    [FirebaseManager sharedInstance].currentUser = nil;
}
+ (void)setUpNewUser:(NSString*)displayName{
    NSString *uid = [FirebaseManager sharedInstance].currentUser.uid;
    FIRDatabaseReference *currentUserRef = [[FirebaseManager userRef] child:uid];
    NSDictionary *newUserInfo = @{kCSUserDidSetDisplay : @1,
                                  kCSUserDisplayKey : displayName};
    [currentUserRef updateChildValues:newUserInfo];
}
+ (void)updateUserInfo{
    // Called when signed-in; refresh all info
}
+ (void)lookUpUser:(User*)currentUser withCompletion:(void (^)(BOOL result))block{
    // Return false if no display name set or first time user
    __block BOOL theResult = false;
    [[[self userRef] child:currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.value == [NSNull null]) { // if user node not created
            FIRDatabaseReference *userRef = [[self userRef] child:currentUser.uid];
            NSDictionary *userDetails = @{kCSUserDidSetDisplay : @0};
            [userRef updateChildValues:userDetails];
            NSLog(@"Did create a node for user");
            theResult = false;
            block(theResult);
        }else{
            FIRDatabaseQuery *userQuery = [[[FirebaseManager userRef] child:currentUser.uid] queryOrderedByChild:kCSUserDisplayKey];
            [userQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                if (snapshot.value) {
                    NSDictionary *response = (NSDictionary*)snapshot.value;
                    if ([response objectForKey:kCSUserDisplayKey]) {
                        theResult = true;
                    }else{
                        theResult = false;
                    }
                }
                block(theResult);
            }];
        }
    }];
}
+ (void)retreiveUsersTeams{
    FIRDatabaseReference *userRef = [FirebaseManager userRef];
    FIRDatabaseQuery *usersQuery = [[userRef child:[FirebaseManager sharedInstance].currentUser.uid] queryOrderedByChild:kCSUserTeamKey];
    [usersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *response = (NSDictionary*)snapshot.value;
        if ([[response allKeys] containsObject:kCSUserTeamKey]) {
            [FirebaseManager sharedInstance].currentUser.groupsIDs = [[response objectForKey:kCSUserTeamKey] mutableCopy];
        }else{
            
        }
    }];
     
}
+ (void)observeNewTeams{
    FIRDatabaseReference *userRef = [FirebaseManager userRef];
    FIRDatabaseQuery *usersQuery = [[userRef child:[FirebaseManager sharedInstance].currentUser.uid] queryOrderedByChild:kCSUserTeamKey];
    [usersQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"OBSERVER %@", snapshot.value);
        NSDictionary *response = (NSDictionary*)snapshot.value;
        if ([[response allKeys] containsObject:kCSUserTeamKey]) {
            [FirebaseManager sharedInstance].currentUser.groupsIDs = [[response objectForKey:kCSUserTeamKey] mutableCopy];
        }
    }];
}
#pragma mark - Queries
+ (void)isNewTeam:(NSString *)teamName withCompletion:(void (^)(BOOL result))block{
    __block NSDictionary *response = [[NSDictionary alloc] init];
    [[[FirebaseManager teamRef] child:teamName] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        response = (NSDictionary*)snapshot.value;
        BOOL isNew = ([response isEqual:[NSNull null]]) ? true : false;
        block(isNew);
    }];
}
#pragma mark - Team Management
+ (void)createTeamWith:(Team *)teamInformation{
    FIRDatabaseReference *teamRef =[[[FirebaseManager sharedInstance] teamRefs] child:teamInformation.nickname];
    NSArray *members = [[NSArray alloc] initWithArray:teamInformation.membersUID];
    NSDictionary *teamDetails = @{kMembersHead : members};
    [teamRef updateChildValues:teamDetails];
    NSArray *newTeams = [FirebaseManager sharedInstance].currentUser.groupsIDs;
    NSString *currentUID = [FirebaseManager sharedInstance].currentUser.uid;
    FIRDatabaseReference *userNodeRef = [[FirebaseManager userRef] child:currentUID];
    NSDictionary *updateInfo = @{kCSUserTeamKey : newTeams};
    [userNodeRef updateChildValues:updateInfo];
}
+ (void)addUserToTeam:(NSString*)teamName andUser:(NSString*)uid{
    FIRDatabaseQuery *membersQuery = [[[[[FirebaseManager sharedInstance] teamRefs] child:teamName] child:kMembersHead] queryOrderedByChild:uid];
    __block NSArray *newmembers = [[NSArray alloc] init];
    __block BOOL alreadyJoined = false;
    [membersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        for (FIRDataSnapshot *child in snapshot.children) {
            if ([child.value isEqualToString:uid]) {
                alreadyJoined = true;
                return;
            }
        }
        if(!alreadyJoined){
            NSArray *response = (NSArray*)snapshot.value;
            NSMutableArray *oldMembers = [response mutableCopy];
            [oldMembers addObject:uid];
            newmembers = [NSArray arrayWithArray:oldMembers];
            FIRDatabaseReference *teamRef =[[[FirebaseManager sharedInstance] teamRefs] child:teamName];
            NSDictionary *teamDetails = @{kMembersHead : newmembers};
            [teamRef updateChildValues:teamDetails];
            
            FIRDatabaseReference *userRef = [FirebaseManager userRef];
            FIRDatabaseQuery *usersQuery = [[userRef child:uid] queryOrderedByChild:kCSUserTeamKey];
            [usersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *response = (NSDictionary*)snapshot.value;
                NSArray *newTeams = @[];
                if ([[response allKeys] containsObject:kCSUserTeamKey]) {
                    // Has previous teams
                    NSMutableArray *oldTeams = [[response objectForKey:kCSUserTeamKey] mutableCopy];
                    [oldTeams addObject:teamName];
                    newTeams = [oldTeams mutableCopy];
                }else{
                    // No previous teams
                    newTeams = [NSArray arrayWithArray:[NSMutableArray arrayWithObject:teamName]];
                }
                FIRDatabaseReference *newTeamsRef = [[userRef child:uid] child:kCSUserTeamKey];
                [newTeamsRef setValue:newTeams];
            }];
        }
    }];
}

#pragma mark - Sprint Management


@end
