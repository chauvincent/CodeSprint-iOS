//
//  ChatroomMessage.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ChatroomMessage.h"

@implementation ChatroomMessage

- (instancetype)initWithMessage:(NSString *)displayName withSenderID:(NSString *)senderID andText:(NSString *)text
{
    if (self = [super init]) {
        _displayName = displayName;
        _senderID = senderID;
        _senderText = text;
    }

    return self;
}

@end
