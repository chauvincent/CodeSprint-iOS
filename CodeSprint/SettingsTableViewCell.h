//
//  SettingsTableViewCell.h
//  CodeSprint
//
//  Created by Vincent Chau on 6/29/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CircleImageView.h"

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionNameLabel;
@property (weak, nonatomic) IBOutlet CircleImageView *optionIconImageView;
@property NSInteger cellIndex;

-(void)configureCellForIndexPath:(NSIndexPath*)index;

@end
