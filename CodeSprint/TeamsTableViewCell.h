//
//  TeamsTableViewCell.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/25/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identiconImageView;

@end
