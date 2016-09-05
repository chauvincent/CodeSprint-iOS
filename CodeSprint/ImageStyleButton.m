//
//  ImageStyleButton.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/13/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ImageStyleButton.h"
#import "Constants.h"
#import <pop/POP.h>

@implementation ImageStyleButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentMode = UIViewContentModeScaleToFill;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self setupView];
}

- (void)setupView
{
    [self addTarget:self action:@selector(scaleToSmall) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(scaleToSmall) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleDefault) forControlEvents:UIControlEventTouchDragExit];
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnime = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    CGSize size = CGSizeMake(0.95, 0.95);
    scaleAnime.toValue = [NSValue valueWithCGSize:size];
    [self.layer pop_addAnimation:scaleAnime forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnime = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    CGSize velocitySize = CGSizeMake(3.0, 3.0);
    CGSize valueSize    = CGSizeMake(1.0, 1.0);
    scaleAnime.velocity = [NSValue valueWithCGSize: velocitySize];
    scaleAnime.toValue  = [NSValue valueWithCGSize:valueSize];
    scaleAnime.springBounciness = 18;
    [self.layer pop_addAnimation:scaleAnime forKey:@"layerScaleSpring Animation"];
}

- (void)scaleDefault
{
    POPBasicAnimation *scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    CGSize size = CGSizeMake(1, 1);
    scaleAnim.toValue = [NSValue valueWithCGSize:size];
    [self.layer pop_addAnimation:scaleAnim forKey:@"layerScaleDefaultAnimation"];
}

@end
