//
//  Artifacts.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/1/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Artifacts.h"

@implementation Artifacts

- (instancetype)initWithProductSpecs:(NSMutableArray *)specs andGoals:(NSMutableArray *)sprintGoals withSprints:(NSMutableArray *)sprintCollection
{
   
    if (self = [super init]) {
        _productSpecs = specs;
        _sprintGoals = sprintGoals;
        _sprintCollection = sprintCollection;
    }
    
    return self;
}

@end
