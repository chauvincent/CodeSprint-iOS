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
    if (!teamsRef) {
        teamsRef = [self.ref child:@"teams"];
    }
    return teamsRef;
}

#pragma mark - Reference Getters
+ (FIRDatabaseReference *)mainRef {
    return [FirebaseManager sharedInstance].ref;
}
+ (FIRDatabaseReference *)teamRef {
    return [FirebaseManager sharedInstance].teamRefs;
}

#pragma mark - Queries
+ (void)isNewTeam:(NSString *)teamName withCompletion:(void (^)(BOOL result))block{
    __block NSDictionary *response = [[NSDictionary alloc] init];
    [[[[FirebaseManager sharedInstance] teamRefs] child:teamName] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        response = (NSDictionary*)snapshot.value;
        NSLog(@"%@", snapshot.value);
        if ([response isEqual:[NSNull null]]) {
            block(true);
        }else{
            block(false);
        }
        
    }];
    
   
    
}



#pragma mark - Insertion
+ (void)createTeamWith:(Team *)teamInformation{
    
}





@end
