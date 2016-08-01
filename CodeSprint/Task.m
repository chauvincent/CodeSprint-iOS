//
//  Task.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/17/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Task.h"

@implementation Task

-(instancetype)initTaskWithTitle:(NSString*)title withDescription:(NSString*)description andDeadline:(NSDate*)date{
    if (self = [super init]) {
        _taskTitle = title;
        _taskDescription = description;
        _dueDate = date;
        _isComplete = false;
    }
    return self;
}


@end
