//
//  CreateDisplayNameViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 7/23/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CreateDisplayViewControllerDelegate <NSObject>

-(void)setDisplayName:(NSString*)userInput;

@end

@interface CreateDisplayNameViewController : UIViewController

@property (weak, nonatomic) id<CreateDisplayViewControllerDelegate> delegate;


@end
