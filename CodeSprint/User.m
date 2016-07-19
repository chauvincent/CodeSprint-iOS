//
//  User.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/19/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initUserWithId:(NSString *)uid withDisplay:(NSString*)name{
    if(self = [super init]){
        _uid = uid;
        _displayName = name;
        _groupsIDs = [[NSMutableArray alloc] init];
    }
    return self;
}



@end
