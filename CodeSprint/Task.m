//
//  Task.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/17/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Task.h"

@implementation Task

-(instancetype)initTaskWith:(NSString*)task withDeadline:(NSDate*)date andCompleted:(BOOL)complete{
    if (self = [super init]) {
        _taskDescription = task;
        _dueDate = date;
        _isComplete = false;
    }
    return self;
}


@end
