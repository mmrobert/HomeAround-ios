//
//  MSendMsgViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MSendMsgViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *toWhom;
@property (weak, nonatomic) IBOutlet UITextView *msgDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
- (IBAction)sendAct:(id)sender;

@property (strong, nonatomic) NSDictionary *customDict;

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
