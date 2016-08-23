//
//  AvatarModel.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessage.h>
#include "JSQMessageAvatarImageDataSource.h"

@interface AvatarModel : NSObject <JSQMessageAvatarImageDataSource>

@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) UIImage *avatarHighlightedImage;
@property (strong, nonatomic) UIImage *avatarPlaceholderImage;

- (instancetype)initWithAvatarImage:(UIImage *)avatarImage
                   highlightedImage:(UIImage *)highlightedImage
                   placeholderImage:(UIImage *)placeholderImage;
@end
