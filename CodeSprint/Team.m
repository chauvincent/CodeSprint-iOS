//
//  Team.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Team.h"

@implementation Team

-(instancetype)initWithCreatorUID:(NSString *)userID andTeam:(NSString *)name{
    if (self = [super init]){
        // _ =
//        // init properties here
//        @property (strong, nonatomic) NSString *teamUID;
//        @property (strong, nonatomic) NSMutableArray *membersUID;
//        @property (strong, nonatomic) NSString *nickname;
//        @property (strong, nonatomic) Sprint *sprintDetails;
        _membersUID = @[userID].mutableCopy;
        _nickname = name;
        //_sprintDetails =
    }
    return self;
}

@end
