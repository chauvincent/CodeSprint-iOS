//
//  CustomTextField.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/13/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(void)awakeFromNib{
    self.layer.cornerRadius = 5.0;
}
-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 0, 0);
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return [self textRectForBounds:bounds];
}

@end
