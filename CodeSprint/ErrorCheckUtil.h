//
//  ErrorCheckUtil.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ErrorCheckUtil : NSObject

// Check bad user input for illegal chracters and empty
- (UIAlertController *)checkBadInput:(NSString *)inputText withMessage:(NSString *)message andDismiss:(NSString *)dismissTitle withSuccessMessage:(NSString *)successMessage title:(NSString *)sucessTitle;
// Display Alert
- (UIAlertController *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andDismissNamed:(NSString *)dismiss;
// Bad input checking taking in TextViews
- (UIAlertController *)checkBadInputForTextViews:(NSString *)inputText withMessage:(NSString *)message andDismiss:(NSString *)dismissTitle withSuccessMessage:(NSString *)successMessage title:(NSString *)sucessTitle;

@end
