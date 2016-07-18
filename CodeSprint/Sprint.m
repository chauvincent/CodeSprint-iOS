//
//  Sprint.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Sprint.h"

@implementation Sprint


-(instancetype)initWithTask:(Task *)task{
    if (self = [super init]) {
        _tasksArray = @[task].mutableCopy;
    }
    return self;
}



@end
