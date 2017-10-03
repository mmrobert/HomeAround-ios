//
//  ModifyJobTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-01.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JobStatusTableViewCell.h"
#import "JobDeleteTableViewCell.h"

@interface ModifyJobTableViewController : UITableViewController <JobStatusTableViewCellDelegate, JobDeleteTableViewCellDelegate>

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSManagedObject *jobItem;

- (IBAction)saveJob:(id)sender;

@end
