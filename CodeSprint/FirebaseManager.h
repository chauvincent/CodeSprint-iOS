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

@import Firebase;

@interface FirebaseManager : NSObject{
    FIRDatabaseReference *ref;
    FIRDatabaseReference *teamsRef;
}
+ (FirebaseManager *) sharedInstance;

#pragma mark - App State Properties
@property (nonatomic, assign) BOOL signedIn;
@property (nonatomic, retain) NSString *usersName;
@property (nonatomic, retain) NSURL *photoUrl;
@property (nonatomic, retain) NSString *uid;


#pragma mark - Query Functions
+ (void)isNewTeam:(NSString *)teamName withCompletion:(void (^)(BOOL result))block;


#pragma mark - Insertion/Deletetion Functions
+ (void)createTeamWith:(Team *)teamInformation;


@end
