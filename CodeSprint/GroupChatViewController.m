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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupUser];

    
    [FirebaseManager retreiveImageURLForTeam:_currentTeam withCompletion:^(NSMutableDictionary *avatarsDict) {
        NSLog(@"RETURNED FROM URL");
        NSLog(@"avatar dic: %@", avatarsDict);
        [self downloadImagesWith:avatarsDict withCompletion:^(NSMutableDictionary *imageDict) {
            self.imageDictionary = imageDict;
            [self setupAvatars];
            [self finishReceivingMessage];
        }];
    }];
    
    [FirebaseManager observeChatroomFor:_currentTeam withCompletion:^(Chatroom *updatedChat) {
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];
        for (NSDictionary *messageInfo in updatedChat.messages) {
            JSQMessage *msg = [[JSQMessage alloc] initWithSenderId:messageInfo[kChatroomSenderID] senderDisplayName:messageInfo[kChatroomDisplayName] date:[NSDate date] text:messageInfo[kChatroomSenderText]];
            [newMessages addObject:msg];
        }
        self.messages = newMessages;
        [self finishReceivingMessage];
    }];
    self.title = @"Messages";
  
    // Do any additional setup after loading the view.
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
    
//    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}
-(void)setupAvatars{
//    for (NSString *key in self.imageDictionary) {
//        JSQMessagesAvatarImage *image = [JSQMessagesAvatarImage avatarWithImage:self.imageDictionary[key]];
//        self.imageDictionary[key] = image;
//    }
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    for (NSString *key in self.imageDictionary) {
        UIImage *image = self.imageDictionary[key];
        AvatarModel *model = [[AvatarModel alloc] initWithAvatarImage:image highlightedImage:nil placeholderImage:image];
        newDict[key] = model;
    }
    self.imageDictionary = newDict;
}
-(void)dismiss{
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
    JSQMessage *currentMsg = self.messages[indexPath.item];
    return _imageDictionary[currentMsg.senderId];
}
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    NSLog(@"DID PRESS SEND");
    ChatroomMessage *msg = [[ChatroomMessage alloc] initWithMessage:senderDisplayName withSenderID:senderId andText:text];
    [FirebaseManager sendMessageForChatroom:self.currentTeam withMessage:msg withCompletion:^(BOOL completed) {
        NSLog(@"DID FINISH SENDING MSG");
        [self finishSendingMessage];
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.messages count];
}
#pragma mark - Helper Methods
- (void)downloadImagesWith:(NSMutableDictionary*)avatars withCompletion:(void (^)(NSMutableDictionary *imageDict))block{
    __block NSMutableDictionary *imageTable = [[NSMutableDictionary alloc] init];
    __block int count = 0;
    for (NSString *userID in avatars) {
        NSURL *url = [NSURL URLWithString:[avatars objectForKey:userID]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"did finish download inside request block");
            UIImage *downloadedImg = (UIImage*)responseObject;
            imageTable[userID] = downloadedImg;
            count++;
            if (count == avatars.count) {
                NSLog(@"finished download");
                block(imageTable);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
            count++;
        }];
        [requestOperation start];
    }

}
@end
