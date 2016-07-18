//
//  Team.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprint.h"
#import "Task.h"

@interface Team : NSObject

// Class Properties
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSMutableArray *membersUID;
@property (strong, nonatomic) NSMutableArray *allSprints;

// Initalize
-(instancetype)initWithCreatorUID:(NSString *)userID andTeam:(NSString *)name;

// Update/Insert/Delete
-(void)addNewSprint:(Sprint*)sprint;

@end
