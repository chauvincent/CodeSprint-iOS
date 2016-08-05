//
//  ArtifactsTableViewCell.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/2/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ArtifactsTableViewCell.h"

@implementation ArtifactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.textLabel.font = [UIFont systemFontOfSize:13.0f];
    self.textLabel.numberOfLines = 4;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
