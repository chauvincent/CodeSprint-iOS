//
//  SettingsTableViewCell.m
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "SettingsTableViewCell.h"
#import "HomeViewController.h"
#include "Constants.h"
#import <pop/POP.h>
@implementation SettingsTableViewCell

-(void)awakeFromNib {
    self.userInteractionEnabled = YES;
}

-(void)configureCellForIndexPath:(NSIndexPath*)index{
    
    UIImage *optionImage;
    NSString *optionName, *description;
    
    switch (index.section) {
        case 0:
            optionImage = [UIImage imageNamed:@"sprint_btn"];
            optionName = @"Sprint";
            description = @"Create/View Your Team's Sprint";
            break;
        case 1:
            optionImage = [UIImage imageNamed:@"messages_btn"];
            optionName = @"Messages";
            description = @"Group/Personal Chat";
            break;
        case 2:
            optionImage = [UIImage imageNamed:@"profile_btn"];
            optionName = @"Edit Profile";
            description = @"Adjust your profile settings";
            break;
        default:
            optionImage = [UIImage imageNamed:@"settings_btn"];
            optionName = @"Settings";
            description = @"Adjust your account settings";
            break;
    }
    self.optionIconImageView.image = optionImage;
    self.optionNameLabel.text = optionName;
    self.descriptionLabel.text = description;
    self.descriptionLabel.textColor = [UIColor grayColor];
    [self.layer setCornerRadius:10.0f];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:0.4f];
    self.layer.borderColor = [UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:1.0].CGColor;
}



@end
