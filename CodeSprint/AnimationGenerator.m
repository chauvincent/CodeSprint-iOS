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

CGFloat *constantsArray;

-(id)initWithConstraints:(NSArray*)constraints {
    self = [super init];
    if (self) {
        int i = 0;
        constantsArray = (CGFloat*)malloc(constraints.count * sizeof(CGFloat));
        for ( NSLayoutConstraint* con in constraints  ){
          //  [self.allConstants addObject:(con.constant];
            constantsArray[i] = con.constant;
            NSLog(@"%lf", constantsArray[i]);
            i++;
            con.constant = [AnimationGenerator offScreenRight].x;
           
        }
        self.allConstraints = constraints;
        
    }
    return self;
}
-(void)animateScreen{
    
    for(int i = 0; i < self.allConstraints.count; i++){
        //POPSpringAnimation *anim = [POPSpringAnimation animation];
        //anim.property = [POPAnimatableProperty propertyWithName:kPOPLayoutConstraintConstant];
//        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
//      
//        anim.toValue = self.allConstants[i];
//        anim.springBounciness = 12.0f;
//        anim.springSpeed = 12.0f;
//        //NSLayoutConstraint *con = self.allConstraints[i];
//        [self.allConstraints[i] pop_addAnimation:anim forKey:@"moveOnScreen"];
        
        POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        layoutAnimation.springSpeed = 20.0f;
        layoutAnimation.springBounciness = 15.0f;
      //  layoutAnimation.toValue = _allConstants[i];
        layoutAnimation.toValue = @(constantsArray[i]);
    //    NSLog(@"%@", layoutAnimation.toValue);
        [self.allConstraints[i] pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
    }
    

}



@end
