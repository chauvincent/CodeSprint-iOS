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

@implementation FirebaseManager

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
        teamsRefs = [self.ref child:@"teams"];
    }
    return teamsRefs;
}
- (FIRDatabaseReference*)userRefs{
    if (!userRefs) {
        userRefs = [self.ref child:@"CSUsers"];
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
    [FirebaseManager sharedInstance].signedIn = false;
    [FirebaseManager sharedInstance].usersName = nil;
    [FirebaseManager sharedInstance].photoUrl = nil;
    [FirebaseManager sharedInstance].uid = nil;
}
+ (void)updateUserInfo:(User*)currentUser{
    // Called when signed-in; refresh all info
}
+ (BOOL)lookUpUser:(User*)currentUser{
    
    
    return true; // return true if not new user
}
+ (void)addUserToTeam:(NSString*)teamName andUser:(NSString*)uid{
    FIRDatabaseQuery *membersQuery = [[[[[FirebaseManager sharedInstance] teamRefs] child:teamName] child:@"members"] queryOrderedByChild:uid];
    __block NSArray *newmembers = [[NSArray alloc] init];
    __block BOOL alreadyJoined = false;
    [membersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"snapshot %@", snapshot.value);
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
            NSDictionary *teamDetails = @{@"members" : newmembers};
            [teamRef updateChildValues:teamDetails];
            NSLog(@"DID ADD MEMBER");
        }
    }];
}

#pragma mark - Queries
+ (void)isNewTeam:(NSString *)teamName withCompletion:(void (^)(BOOL result))block{
    __block NSDictionary *response = [[NSDictionary alloc] init];
    [[[[FirebaseManager sharedInstance] teamRefs] child:teamName] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        response = (NSDictionary*)snapshot.value;
        BOOL isNew = ([response isEqual:[NSNull null]]) ? true : false;
        block(isNew);
    }];
}
#pragma mark - Insertion
+ (void)createTeamWith:(Team *)teamInformation{
    FIRDatabaseReference *teamRef =[[[FirebaseManager sharedInstance] teamRefs] child:teamInformation.nickname];
    NSArray *members = [[NSArray alloc] initWithArray:teamInformation.membersUID];
    NSDictionary *teamDetails = @{@"members" : members};
    [teamRef updateChildValues:teamDetails];
}


@end
