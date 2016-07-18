//
//  Team.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprint.h"

@interface Team : NSObject

@property (strong, nonatomic) NSString *teamUID;
@property (strong, nonatomic) NSMutableArray *membersUID;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) Sprint *sprintDetails;



-(instancetype)initWithCreatorUID:(NSString *)userID andTeam:(NSString *)name;

@end
