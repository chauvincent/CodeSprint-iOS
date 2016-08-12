//
//  ErrorCheckUtil.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/24/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ErrorCheckUtil : NSObject

-(UIAlertController*)checkBadInput:(NSString*)inputText withMessage:(NSString*)message andDismiss:(NSString*)dismissTitle withSuccessMessage:(NSString*)successMessage title:(NSString*)sucessTitle;

-(UIAlertController*)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andDismissNamed:(NSString*)dismiss;

-(UIAlertController*)checkBadInputForTextViews:(NSString*)inputText withMessage:(NSString*)message andDismiss:(NSString*)dismissTitle withSuccessMessage:(NSString*)successMessage title:(NSString*)sucessTitle;
@end
