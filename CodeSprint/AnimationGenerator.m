//
//  AnimationGenerator.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "AnimationGenerator.h"
#import <pop/POP.h>

@implementation AnimationGenerator

+ (CGPoint) offScreenRight{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat midY = CGRectGetMidY([UIScreen mainScreen].bounds );
    CGPoint position = CGPointMake(width, midY);
    return position;
}
+ (CGPoint) offScreenLeft{
    CGFloat width = -[UIScreen mainScreen].bounds.size.width;
    CGFloat midY = CGRectGetMidY([UIScreen mainScreen].bounds );
    CGPoint position = CGPointMake(width, midY);
    return position;
}
+ (CGPoint) offScreenCenter{
    CGFloat midX = CGRectGetMidX([UIScreen mainScreen].bounds);
    CGFloat midY = CGRectGetMidY([UIScreen mainScreen].bounds );
    CGPoint position = CGPointMake(midX, midY);
    return position;
}


-(id)initWithConstraints:(NSArray*)constraints {
    self = [super init];
    if (self) {
        for ( NSLayoutConstraint* con in constraints  ){
            [_allConstants addObject:[NSNumber numberWithFloat:con.constant]];
            con.constant = [AnimationGenerator offScreenRight].x;
        }
        _allConstraints = constraints;
        
    }
    return self;
}
-(void)animateScreen{
    for(int i = 0; i < self.allConstraints.count; i++){
        //POPSpringAnimation *anim = [POPSpringAnimation animation];
        //anim.property = [POPAnimatableProperty propertyWithName:kPOPLayoutConstraintConstant];
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        anim.toValue = self.allConstants[i];
        NSLog(@"%@", anim.toValue);
        anim.springBounciness = 12;
        anim.springSpeed = 12;
        
        NSLayoutConstraint *con = self.allConstraints[i];
        [con pop_addAnimation:anim forKey:@"moveOnScreen"];
    }
}



@end
