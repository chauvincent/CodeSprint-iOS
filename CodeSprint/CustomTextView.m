//
//  CustomTextView.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/2/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CustomTextView.h"
#import "Constants.h"

@implementation CustomTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = LIGHT_GREY_COLOR;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.2].CGColor;
}

@end
