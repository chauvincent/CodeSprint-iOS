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

// Global
CGFloat *constantsArray;

- (CGPoint) offScreenRight{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat midY = CGRectGetMidY([UIScreen mainScreen].bounds );
    CGPoint position = CGPointMake(width, midY);
    return position;
}
- (CGPoint) offScreenLeft{
    CGFloat width = -[UIScreen mainScreen].bounds.size.width;
    CGFloat midY = CGRectGetMidY([UIScreen mainScreen].bounds );
    CGPoint position = CGPointMake(width, midY);
    return position;
}
- (CGPoint) offScreenCenter{
    CGFloat midX = CGRectGetMidX([UIScreen mainScreen].bounds);
    CGFloat midY = CGRectGetMidY([UIScreen mainScreen].bounds );
    CGPoint position = CGPointMake(midX, midY);
    return position;
}

-(id)initWithConstraints:(NSArray*)constraints {
    self = [super init];
    if (self) {
        int i = 0;
        constantsArray = (CGFloat*)malloc(constraints.count * sizeof(CGFloat));
        for ( NSLayoutConstraint* con in constraints  ){
            constantsArray[i] = con.constant;
            i++;
            con.constant = self.offScreenRight.x;
        }
        self.allConstraints = constraints;
    }
    return self;
}

-(void)animateScreenWithDelay:(double)delay{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, ((int64_t)(double)delay) * (double)NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        for(int i = 0; i < self.allConstraints.count; i++){
            POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            layoutAnimation.springSpeed = 20.0f;
            layoutAnimation.springBounciness = 15.0f;
            layoutAnimation.toValue = @(constantsArray[i]);
            if(i > 0){
                layoutAnimation.dynamicsFriction += 50 + (CGFloat)i;
            }
            [self.allConstraints[i] pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
        } 
    });
}

@end
