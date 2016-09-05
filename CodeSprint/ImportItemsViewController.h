//
//  ImportItemsViewController.h
//  CodeSprint
//
//  Created by Vincent Chau on 8/5/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artifacts.h"
@protocol ImportItemsViewDelegate <NSObject>

- (void)didImport:(NSMutableArray *)selected;

@end

@interface ImportItemsViewController : UIViewController

@property (strong, nonatomic) Artifacts *currentArtifact;
@property (weak, nonatomic) id<ImportItemsViewDelegate> delegate;

@end
