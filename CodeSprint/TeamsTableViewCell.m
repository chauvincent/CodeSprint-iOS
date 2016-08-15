//
//  TeamsTableViewCell.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/25/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "TeamsTableViewCell.h"
#import "Constants.h"
@implementation TeamsTableViewCell

- (void)awakeFromNib {
    [self.layer setCornerRadius:10.0f];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:0.4f];
    self.layer.borderColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.3].CGColor;
}

@end
