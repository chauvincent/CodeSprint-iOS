//
//  User.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/19/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSMutableArray *groupsIDs;
@property (strong, nonatomic) NSString *displayName;

-(instancetype)initUserWithId:(NSString *)uid withDisplay:(NSString*)name;


@end
