//
//  Team.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Team.h"

@implementation Team

#pragma mark - Lazy Initializers

- (NSMutableArray *)allSprints
{
    if (!_allSprints) {
        _allSprints = [[NSMutableArray alloc] init];
    }

    return _allSprints;
}

- (instancetype)initWithCreatorUID:(NSString *)userID andTeam:(NSString *)name
{
    if (self = [super init]) {
        _membersUID = @[userID].mutableCopy;
        _nickname = name;
    }
    
    return self;
}

@end
