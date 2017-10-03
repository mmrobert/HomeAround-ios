//
//  MpersonalMsgViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-23.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MpersonalMsgViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NSFetchedResultsControllerDelegate>

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

- (IBAction)sendAct:(id)sender;

@property (strong, nonatomic) NSManagedObject *chatItem;

@end
