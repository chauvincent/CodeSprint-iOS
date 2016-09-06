//
//  StorageService.h
//  CodeSprint
//
//  Created by Vincent Chau on 9/1/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface StorageService : NSObject

@property (strong, nonatomic) FIRStorageReference *storageRef;

- (void)uploadToImageData:(NSData *)data withCompletion:(void (^)(NSURL *imageUrl))block;

@end
