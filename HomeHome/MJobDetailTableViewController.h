//
//  MJobDetailTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJobInfoTableViewCell.h"
#import "AppDelegate.h"
#import "MJobStatusTableViewCell.h"
#import "MJobDeleteTableViewCell.h"

@interface MJobDetailTableViewController : UITableViewController <MJobInfoTableViewCellDelegate, MJobStatusTableViewCellDelegate, MJobDeleteTableViewCellDelegate>

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSDictionary *jobItem;
@property (strong, nonatomic) NSString *jobStatusStr;

@property int situationCode;

- (IBAction)cancelAct:(id)sender;

@end
