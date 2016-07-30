//
//  ErrorCheckUtil.m
//  CodeSprint
//
//  Created by Vincent Chau on 7/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ErrorCheckUtil.h"

@implementation ErrorCheckUtil

-(instancetype)initWith{
    if (self = [super init]) {
    
    }
    return self;
}
-(UIAlertController*)checkBadInput:(NSString*)inputText withMessage:(NSString*)message andDismiss:(NSString*)dismissTitle withSuccessMessage:(NSString*)successMessage title:(NSString*)sucessTitle{
    
    if ([inputText isEqualToString:@""]) {
        return [self showAlertWithTitle:@"Error: Blank Input" andMessage:message
                 andDismissNamed:dismissTitle];
    }
    NSCharacterSet *charSet = [NSCharacterSet
                               characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_- "];
    charSet = [charSet invertedSet];
    NSRange range = [inputText rangeOfCharacterFromSet:charSet];
    
    if (range.location != NSNotFound) {
        return [self showAlertWithTitle:@"Invalid Characters" andMessage:@"Please enter a name containing only: [A-Z], [a-z], [0-9], -, _"
                 andDismissNamed:@"Dismiss"];
    }
    
    UIAlertController *success = [self showAlertWithTitle:sucessTitle andMessage:successMessage
                                          andDismissNamed:@"OK"];

    return success; // returns nil if valid input
}
-(UIAlertController*)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andDismissNamed:(NSString*)dismiss{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:dismiss style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    //[self presentViewController:alert animated:YES completion:nil];
    return alert;
}
@end
