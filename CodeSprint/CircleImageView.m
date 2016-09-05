//
//  CircleImageView.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CircleImageView.h"
#import "Constants.h"
#import <pop/POP.h>

@implementation CircleImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.width / 2.0f;
    self.clipsToBounds = YES;
    self.layer.shadowColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.5].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.borderWidth = 0.1;
    self.layer.shadowRadius = 8.0;
    self.layer.borderColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTap];
}

- (void)oneTap:(id)sender
{
    POPSpringAnimation *scaleAnime = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    CGSize velocitySize = CGSizeMake(3.0, 3.0);
    CGSize valueSize    = CGSizeMake(1.0, 1.0);
    scaleAnime.velocity = [NSValue valueWithCGSize: velocitySize];
    scaleAnime.toValue  = [NSValue valueWithCGSize:valueSize];
    scaleAnime.springBounciness = 18;
    [self.layer pop_addAnimation:scaleAnime forKey:@"layerScaleSpring Animation"];
}

@end
