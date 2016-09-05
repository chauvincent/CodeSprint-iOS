//
//  Artifacts.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/1/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artifacts : NSObject

// Arrays of JSON Dictionaries
@property (strong, nonatomic) NSMutableArray *productSpecs;
@property (strong, nonatomic) NSMutableArray *sprintGoals;
@property (strong, nonatomic) NSMutableArray *sprintCollection; // collection of sprint objects

- (instancetype)initWithProductSpecs:(NSMutableArray *)specs andGoals:(NSMutableArray *)sprintGoals withSprints:(NSMutableArray *)sprintCollection;
    
@end
