//
//  ImageStyleButton.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/13/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ImageStyleButton.h"
#import "Constants.h"
@implementation ImageStyleButton

-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentMode = UIViewContentModeScaleToFill;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
}

@end
