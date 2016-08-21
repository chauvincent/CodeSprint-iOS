//
//  Chatroom.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Chatroom.h"

@implementation Chatroom


-(instancetype)initChatWithTeamName:(NSString *)teamname withUser:(NSMutableArray*)users withMessages:(NSMutableArray*)messages{
    if(self = [super init]){
        _chatID = teamname;
        _usersIDs = users;
        _messages = messages;
    }
    return self;
}
@end
