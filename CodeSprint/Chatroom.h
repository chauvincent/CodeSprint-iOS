//
//  Chatroom.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chatroom : NSObject

@property (strong, nonatomic) NSString *chatID;
@property (strong, nonatomic) NSMutableArray *usersIDs;
@property (strong, nonatomic) NSMutableArray *messages;

- (instancetype)initChatWithTeamName:(NSString *)teamname withUser:(NSMutableArray *)users withMessages:(NSMutableArray *)messages;

@end
