//
//  Team.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

// Class Properties
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSMutableArray *membersUID;
@property (strong, nonatomic) NSMutableArray *allSprints;
@property (strong, nonatomic) NSString *scrumID;


// Initalize
-(instancetype)initWithCreatorUID:(NSString *)userID andTeam:(NSString *)name;



@end
