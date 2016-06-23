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
- (FIRDatabaseReference*)ref{
    if (!ref) {
        ref = [[FIRDatabase database] reference];
    }
    return ref;
}

#pragma mark - Getter
+ (FIRDatabaseReference *)mainRef {
    return [FirebaseManager sharedInstance].ref;
}


@end
