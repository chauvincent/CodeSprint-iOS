//
//  AddItemViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/2/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artifacts.h"

@protocol AddItemViewControllerDelegate <NSObject>

-(void)updateArtifactItem;

@end

@interface AddItemViewController : UIViewController

@property (nonatomic) NSUInteger index;
@property (strong, nonatomic) NSString *currentScrum;
@property (strong, nonatomic) Artifacts *currentArtifact;

@property (weak, nonatomic) id<AddItemViewControllerDelegate> delegate;


@end
