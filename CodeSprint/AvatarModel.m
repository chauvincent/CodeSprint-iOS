//
//  AvatarModel.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "AvatarModel.h"

@implementation AvatarModel

- (instancetype)initWithAvatarImage:(UIImage *)avatarImage
                   highlightedImage:(UIImage *)highlightedImage
                   placeholderImage:(UIImage *)placeholderImage
{
    self = [super init];

    if (self) {
        _avatarImage = avatarImage;
        _avatarHighlightedImage = highlightedImage;
        _avatarPlaceholderImage = placeholderImage;
    }
    
    return self;
}

@end
