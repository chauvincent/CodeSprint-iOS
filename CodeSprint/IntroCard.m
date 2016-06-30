//
//  IntroCard.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/30/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "IntroCard.h"
#import <UIKit/UIKit.h>

@implementation IntroCard

NSMutableArray *cardArray;
NSString *currentCard;


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowRadius = 5.0f;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shadowColor = [[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0] CGColor];
}
@end
