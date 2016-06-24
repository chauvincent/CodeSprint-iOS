//
//  ShadowView.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView
#define SHADOW_COLOR 157.0/266.0

-(void)awakeFromNib{
    self.layer.cornerRadius = 2.0;
    self.layer.shadowColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.5].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
