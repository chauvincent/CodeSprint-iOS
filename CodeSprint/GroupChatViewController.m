//
//  GroupChatViewController.m
//  CodeSprint
//
//  Created by Vincent Chau on 8/18/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "GroupChatViewController.h"
#import "JSQMessages.h"
#import "FirebaseManager.h"
#import "Constants.h"
#include "Chatroom.h"
#include "ChatroomMessage.h"
#include "AFNetworking.h"
#include "AvatarModel.h"
@interface GroupChatViewController () <JSQMessagesCollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation GroupChatViewController


-(NSMutableDictionary*)imageDictionary{
    if (!_imageDictionary) {
        _imageDictionary = [[NSMutableDictionary alloc] init];
    }
    return _imageDictionary;
}

-(NSMutableDictionary*)avaDictionary{
    if (!_avaDictionary) {
        _avaDictionary = [[NSMutableDictionary alloc] init];
    }
    return _avaDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupUser];
    [FirebaseManager retreiveImageURLForTeam:_currentTeam withCompletion:^(NSMutableDictionary *avatarsDict) {
        self.imageDictionary = avatarsDict;
        [self setupAvatarWithCompletion:^(BOOL completed) {
            [self finishReceivingMessage];
        }];
    }];
    
    [FirebaseManager observeChatroomFor:_currentTeam withCompletion:^(Chatroom *updatedChat) {
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];
        for (NSDictionary *messageInfo in updatedChat.messages) {
            JSQMessage *msg;
            if ([messageInfo[kChatroomSenderID] isEqualToString:self.senderId]) {
                msg = [[JSQMessage alloc] initWithSenderId:messageInfo[kChatroomSenderID] senderDisplayName:messageInfo[kChatroomDisplayName] date:[NSDate date] text:messageInfo[kChatroomSenderText]];
            }else{
                NSString *text = [NSString stringWithFormat:@"%@: %@", messageInfo[kChatroomDisplayName], messageInfo[kChatroomSenderText]];
                msg = [[JSQMessage alloc] initWithSenderId:messageInfo[kChatroomSenderID] senderDisplayName:messageInfo[kChatroomDisplayName] date:[NSDate date] text:text];
            }
            [newMessages addObject:msg];
        }
        self.messages = newMessages;
        [self setupAvatarWithCompletion:^(BOOL complete) {
                    [self finishReceivingMessage];
        }];
    }];
    self.title = @"Messages";
  
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [[[[[FIRDatabase database] reference] child:kChatroomHead] child:_currentTeam] removeObserverWithHandle:[FirebaseManager sharedInstance].chatroomHandle];
    [[[[[FIRDatabase database] reference] child:kTeamsHead] child:_currentTeam] removeObserverWithHandle:[FirebaseManager sharedInstance].downloadImgHandle];
    [[[[[FIRDatabase database] reference] child:kChatroomHead] child:_currentTeam] removeAllObservers];
     [[[[[FIRDatabase database] reference] child:kTeamsHead] child:_currentTeam] removeAllObservers];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup
-(void)setupUser{
    self.senderId = [FirebaseManager sharedInstance].currentUser.uid;
    self.senderDisplayName = [FirebaseManager sharedInstance].currentUser.displayName;
}
-(void)setupViews{
    self.navigationItem.title = @"Goals for this Sprint";
    self.navigationItem.hidesBackButton = YES;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

-(void)dismiss{
    [FirebaseManager detachChatroom];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - JSQMessagesViewController Delegate

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.messages objectAtIndex:indexPath.item];
}
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *currentMsg = self.messages[indexPath.item];
    if ([currentMsg.senderId isEqualToString:self.senderId]) {
        return _outgoingBubbleImageData;
    }else{
        return _incomingBubbleImageData;
    }
}
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_imageDictionary count] == 0) {
        return nil;
    }
    JSQMessage* currentMsg = self.messages[indexPath.item];
    return self.avaDictionary[currentMsg.senderId];
}
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    ChatroomMessage *msg = [[ChatroomMessage alloc] initWithMessage:senderDisplayName withSenderID:senderId andText:text];
    [FirebaseManager sendMessageForChatroom:self.currentTeam withMessage:msg withCompletion:^(BOOL completed) {
        [self finishSendingMessage];
    }];
     [self finishSendingMessage];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.messages count];
}
-(void)setupAvatarWithCompletion:(void (^)(BOOL complete))block{
    for (NSString *key in self.imageDictionary) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *currentURL = [NSURL URLWithString:self.imageDictionary[key]];
            UIImage *currentIMG = [UIImage imageWithData:[NSData dataWithContentsOfURL:currentURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                AvatarModel* newModel = [[AvatarModel alloc] initWithAvatarImage:currentIMG highlightedImage:nil placeholderImage:currentIMG];
                self.avaDictionary[key] = newModel;
                if ([self.avaDictionary count] == [self.imageDictionary count]) {
                    block(true);
                }
                
            });
        });
    }
}


@end
