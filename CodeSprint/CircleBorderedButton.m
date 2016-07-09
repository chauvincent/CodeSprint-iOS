//
//  CircleBorderedButton.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/9/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CircleBorderedButton.h"
#import "Constants.h"
@implementation CircleBorderedButton

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.width / 2.0f;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.5].CGColor;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
