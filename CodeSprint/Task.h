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
@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) NSString *taskDescription;
@property (strong, nonatomic) NSDate *dueDate;
@property (assign, nonatomic) BOOL isComplete;

// Initializers
-(instancetype)initTaskWithTitle:(NSString*)title withDescription:(NSString*)description andDeadline:(NSDate*)date;

@end
