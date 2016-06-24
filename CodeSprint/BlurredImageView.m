//
//  BlurredImageView.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "BlurredImageView.h"

@implementation BlurredImageView

-(void)awakeFromNib{
    [super awakeFromNib];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    effectView.alpha = 1.0;
    [self addSubview:effectView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
