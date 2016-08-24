//
//  CustomUILabel.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/28/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CustomUILabel.h"
#import "Constants.h"
@implementation CustomUILabel

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setCornerRadius:8.0f];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:0.3f];
    self.layer.borderColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.2].CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
