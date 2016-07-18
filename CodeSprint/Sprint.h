//
//  Sprint.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
@interface Sprint : NSObject

@property (strong, nonatomic) NSMutableArray *tasksArray;

-(instancetype)initWithTask:(Task*)task;

@end
