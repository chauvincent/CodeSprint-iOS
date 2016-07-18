//
//  Task.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/17/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

// Class Properties
@property (strong, nonatomic) NSString *taskDescription;
@property (strong, nonatomic) NSDate *dueDate;
@property (assign, nonatomic) BOOL isComplete;

// Initializers
-(instancetype)initTaskWith:(NSString*)task withDeadline:(NSDate*)date andCompleted:(BOOL)complete;


@end
