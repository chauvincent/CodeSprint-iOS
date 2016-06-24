//
//  CircleImageView.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.width / 2.0f;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 3.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
