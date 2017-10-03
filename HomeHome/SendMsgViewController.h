//
//  SendMsgViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-06.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SendMsgViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *toName;
@property (weak, nonatomic) IBOutlet UITextView *msgDetail;

- (IBAction)sendAct:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

@property (strong, nonatomic) NSDictionary *serviceDict;

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
