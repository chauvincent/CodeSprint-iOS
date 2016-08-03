//
//  Artifacts.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/1/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artifacts : NSObject

@property (strong, nonatomic) NSMutableArray *productSpecs;
@property (strong, nonatomic) NSMutableArray *sprintGoals;
-(instancetype)initWithProductSpecs:(NSMutableArray*)specs andGoals:(NSMutableArray*)sprintGoals;

@end
