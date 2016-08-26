//
//  ChatroomMessage.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatroomMessage : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *senderText;

-(instancetype)initWithMessage:(NSString*)displayName withSenderID:(NSString*)senderID andText:(NSString*)text;

@end
