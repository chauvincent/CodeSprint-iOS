//
//  CircleBorderedButton.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/9/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "CircleBorderedButton.h"
#import "Constants.h"
#import <pop/POP.h>
@implementation CircleBorderedButton

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.width / 2.0f;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5f;
    self.layer.borderWidth = 8.0f;
    self.layer.borderColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.1].CGColor;
    self.contentMode = UIViewContentModeScaleToFill;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self setupView];
}
-(void)setupView{
    [self addTarget:self action:@selector(scaleToSmall) forControlEvents: UIControlEventTouchDown];
    [self addTarget:self action:@selector(scaleToSmall) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleDefault) forControlEvents:UIControlEventTouchDragExit];
}
- (void) scaleToSmall{
    POPBasicAnimation *scaleAnime = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    CGSize size = CGSizeMake(0.95, 0.95);
    scaleAnime.toValue = [NSValue valueWithCGSize:size];
    [self.layer pop_addAnimation:scaleAnime forKey:@"layerScaleSmallAnimation"];
}

- (void) scaleAnimation{
    POPSpringAnimation *scaleAnime = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    CGSize velocitySize = CGSizeMake(3.0, 3.0);
    CGSize valueSize    = CGSizeMake(1.0, 1.0);
    scaleAnime.velocity = [NSValue valueWithCGSize: velocitySize];
    scaleAnime.toValue  = [NSValue valueWithCGSize:valueSize];
    scaleAnime.springBounciness = 18;
    [self.layer pop_addAnimation:scaleAnime forKey:@"layerScaleSpring Animation"];
}

- (void) scaleDefault{
    POPBasicAnimation *scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    CGSize size = CGSizeMake(1, 1);
    scaleAnim.toValue = [NSValue valueWithCGSize:size];
    [self.layer pop_addAnimation:scaleAnim forKey:@"layerScaleDefaultAnimation"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
