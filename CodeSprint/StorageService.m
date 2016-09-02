//
//  StorageService.m
//  CodeSprint
//
//  Created by Vincent Chau on 9/1/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "StorageService.h"
#import "FirebaseManager.h"

@implementation StorageService

NSString* STORAGE_BASE_URL = @"gs://code-spring-ios.appspot.com";

-(FIRStorageReference*)storageRef{
    if (!_storageRef) {
        _storageRef = [[FIRStorage storage] referenceForURL:STORAGE_BASE_URL];
    }
    return _storageRef;
}

-(void)uploadToImageData:(NSData*)data withCompletion:(void (^)(NSURL* imageUrl))block{
    NSString *uid = [FirebaseManager sharedInstance].currentUser.uid;
    FIRStorageReference *uploadRef = [[self storageRef] child:uid];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    FIRStorageUploadTask *uploadTask = [uploadRef putData:data metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }else {
            NSURL *pictureURL = metadata.downloadURL;
            NSLog(@"URL IS : %@", [pictureURL absoluteString]);
            block(pictureURL);
        }
        NSURL *badUpload = [NSURL URLWithString:@"ERROR"];
        block(badUpload);
    }];
    
}



@end