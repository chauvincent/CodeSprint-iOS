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

#pragma mark - User Management - Lifecycle
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
#pragma mark - Team Management - Creations
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

#pragma mark - Team Management - Deletions

#pragma mark - Scrum Management - Insertions
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
+ (void)updateSprintFor:(NSString*)scrumKey withGoalRefs:(NSMutableArray*)refs andCollectionIndex:(NSInteger)index withArtifact:(Artifacts*)artifact withCompletion:(void (^)(Artifacts* artifact))block{
    FIRDatabaseQuery *goalRefQuery = [[[self scrumRef] child:scrumKey] queryOrderedByChild:kSprintHead];
    [goalRefQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *response = (NSDictionary*)snapshot.value;
        NSMutableArray *sprintArray = [(NSArray*)response[kSprintHead] mutableCopy];
        NSDictionary *currentSprint = sprintArray[index];
        NSMutableArray *goalRef = [currentSprint[kSprintGoalReference] mutableCopy];
        for (int i = 0; i < refs.count; i++) {
            NSIndexPath *path = (NSIndexPath*)refs[i];
            NSInteger myInteger = path.row;
            int newInt = (int)myInteger;
            NSNumber *sprintRef = [NSNumber numberWithInt:newInt];
            [goalRef addObject:sprintRef];
        }
        if ([goalRef containsObject:@(-1)]) {
            [goalRef removeObject:@(-1)];
        }
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:goalRef];
        NSArray *arrayWithoutDuplicates = [orderedSet array];
        NSMutableDictionary *dict = [[artifact.sprintCollection objectAtIndex:index] mutableCopy];
        FIRDatabaseReference *updateRef = [[[[self scrumRef] child:scrumKey] child:kSprintHead] child:[NSString stringWithFormat:@"%ld",(long)index]];
        [updateRef updateChildValues:@{kSprintGoalReference:arrayWithoutDuplicates}];
        dict[kSprintGoalReference] = arrayWithoutDuplicates;
        artifact.sprintCollection[index] = dict;
        Artifacts *newArtifact = [[Artifacts alloc] initWithProductSpecs:artifact.productSpecs andGoals:artifact.sprintGoals withSprints:artifact.sprintCollection];
        block(newArtifact);
    }];
}
#pragma mark - Scrum Management - Observers
+ (void)observePassiveScrumNode:(NSString*)scrumKey withCompletion:(void (^)(Artifacts *artifact))block{
    FIRDatabaseQuery *scrumQuery = [[[self scrumRef] child:scrumKey] queryOrderedByChild:kScrumCreator];

    [scrumQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *productSpecs = [[NSMutableArray alloc] init];
        NSMutableArray *allGoals = [[NSMutableArray alloc] init];
        NSMutableArray *sprintCollection = [[NSMutableArray alloc] init];
        NSDictionary *response = (NSDictionary*)snapshot.value;
        if ([[response allKeys] containsObject:kScrumProductSpecs]) {
            productSpecs = response[kScrumProductSpecs];
        }
        if ([[response allKeys] containsObject:kScrumSprintGoals]) {
            NSArray *test = (NSArray*)response[kScrumSprintGoals];
            for (NSDictionary *dict in test) {
                [allGoals addObject:dict];
            }
        }
        if ([[response allKeys] containsObject:kSprintHead]) {
            NSArray *sprintIntervals = (NSArray*)response[kSprintHead];
            for (NSDictionary *dict in sprintIntervals) {
                [sprintCollection addObject:dict];
            }
        }
        Artifacts *artifact = [[Artifacts alloc] initWithProductSpecs:productSpecs andGoals:allGoals withSprints:sprintCollection];
        block(artifact);
    }];
}
+ (void)observeIncaseDelete:(NSString*)scrumKey withCurrentIndex:(NSInteger)index withCompletion:(void (^)(BOOL completed))block{
    NSString *currentIndex = [NSString stringWithFormat:@"%ld", (long)index];
    FIRDatabaseReference *change = [[[self scrumRef] child:scrumKey] child:kSprintHead];
    [change observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot.key isEqualToString:currentIndex]) {
            block(true);
            NSLog(@"current is being deleted");
        }else{
            block(false);
        }
    }];
    NSLog(@"FIRED OBSERVE DELETE INCASE");
    
    
}
+ (void)observeScrumNode:(NSString*)scrumKey withCompletion:(void (^)(Artifacts *artifact))block{
    FIRDatabaseQuery *scrumQuery = [[[self scrumRef] child:scrumKey] queryOrderedByChild:kScrumCreator];
    [scrumQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *productSpecs = [[NSMutableArray alloc] init];
        NSMutableArray *allGoals = [[NSMutableArray alloc] init];
        NSMutableArray *sprintCollection = [[NSMutableArray alloc] init];
        NSDictionary *response = (NSDictionary*)snapshot.value;
        if ([[response allKeys] containsObject:kScrumProductSpecs]) {
            productSpecs = response[kScrumProductSpecs];
        }
        if ([[response allKeys] containsObject:kScrumSprintGoals]) {
            NSArray *test = (NSArray*)response[kScrumSprintGoals];
            for (NSDictionary *dict in test) {
                [allGoals addObject:dict];
            }
        }
        if ([[response allKeys] containsObject:kSprintHead]) {
            NSArray *sprintIntervals = (NSArray*)response[kSprintHead];
            for (NSDictionary *dict in sprintIntervals) {
                [sprintCollection addObject:dict];
            }
        }
        Artifacts *artifact = [[Artifacts alloc] initWithProductSpecs:productSpecs andGoals:allGoals withSprints:sprintCollection];
        block(artifact);
    }];
}

#pragma mark - Scrum Management - Deletions
+ (void)removeActiveSprintFor:(NSString*)scrumKey withArtifact:(Artifacts*)artifact forIndex:(NSInteger)selectedIndex withCompletion:(void (^)(BOOL compelted))block{
    FIRDatabaseReference *currentSprint = [[[self scrumRef] child:scrumKey] child:kSprintHead];
    [currentSprint observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *sprintArray = [(NSArray*)snapshot.value mutableCopy];
        [sprintArray removeObjectAtIndex:selectedIndex];
        [currentSprint setValue:sprintArray];
        block(true);
    }];
}
+ (void)removeProductSpecFor:(NSString*)scrumKey withArtifact:(Artifacts*)artifact forIndex:(NSInteger)selectedIndex withCompletion:(void (^)(BOOL compelted))block{
    FIRDatabaseReference *currentScrum = [[[self scrumRef] child:scrumKey] child:kScrumProductSpecs];
    [currentScrum observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *productSpecs = [(NSArray*)snapshot.value mutableCopy];
        [productSpecs removeObjectAtIndex:selectedIndex];
        [currentScrum setValue:productSpecs];
        block(true);
    }];
}
+ (void)removeSprintGoalFor:(NSString*)scrumKey withArtifact:(Artifacts*)artifact forIndex:(NSInteger)selectedIndex andSprintIndex:(NSUInteger)selectedSprint withCompletion:(void (^)(Artifacts* artifact))block{
    FIRDatabaseQuery *goalRefQuery = [[[self scrumRef] child:scrumKey] queryOrderedByChild:kSprintHead];
    [goalRefQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *response = (NSDictionary*)snapshot.value;
        NSMutableArray *sprintArray = [(NSArray*)response[kSprintHead] mutableCopy];
        NSDictionary *currentSprint = sprintArray[selectedSprint];
        NSMutableArray *goalRef = [currentSprint[kSprintGoalReference] mutableCopy];
        
        [goalRef removeObjectAtIndex:selectedIndex];
        if (goalRef.count == 0) {
            [goalRef addObject:@(-1)];
        }
        NSArray *array = [NSArray arrayWithArray:goalRef];

        FIRDatabaseReference *updateRef = [[[[self scrumRef] child:scrumKey] child:kSprintHead] child:[NSString stringWithFormat:@"%ld",(long)selectedSprint]];
        [updateRef updateChildValues:@{kSprintGoalReference:array}];
        block(artifact);
    }];
}
+ (void)removeSprintFromAllFor:(NSString*)scrumKey withArtifact:(Artifacts*)currentArtifact andIndex:(NSInteger)indexPath withCompletion:(void (^)(BOOL completed))block{
    FIRDatabaseQuery *goalRefQuery = [[[self scrumRef] child:scrumKey]queryOrderedByChild:kSprintHead
                                      ];
    [goalRefQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *response = (NSDictionary*)snapshot.value;
        NSMutableArray *sprintGoals = [(NSArray*)response[kScrumSprintGoals] mutableCopy];
        [sprintGoals removeObjectAtIndex:indexPath];
        NSArray *newGoals = [NSArray arrayWithArray:sprintGoals];
        NSLog(@"NEW GOALS: %@", newGoals);
        FIRDatabaseReference *update = [[self scrumRef] child:scrumKey];
        
        if ([[response allKeys] containsObject:kSprintHead]) {
            NSMutableArray *sprintArray = [(NSArray*)response[kSprintHead] mutableCopy];
            NSMutableArray *newSprintArray = [[NSMutableArray alloc] init];
            for (NSMutableDictionary* sprintDict in sprintArray) {
                if ([[sprintDict allKeys] containsObject:kSprintGoalReference]) {
                    NSMutableArray* goalRefs = [sprintDict[kSprintGoalReference] mutableCopy];
                    if ([goalRefs containsObject:@(indexPath)]) {
                        [goalRefs removeObject:@(indexPath)];
                        if ([goalRefs count] == 0) {
                            [goalRefs addObject:@(-1)];
                        }
                    }
                    sprintDict[kSprintGoalReference] = goalRefs;
                }
                [newSprintArray addObject:sprintDict];
            }
            [update updateChildValues:@{kSprintHead:[NSArray arrayWithArray:newSprintArray]}];
        }
        [update updateChildValues:@{kScrumSprintGoals:newGoals}];
        block(TRUE);
    }];
    
    
    
}
@end
