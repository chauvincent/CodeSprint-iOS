//
//  GroupMessageTableViewCell.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/28/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;

@end
