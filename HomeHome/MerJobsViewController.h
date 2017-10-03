//
//  MerJobsViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-21.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MerJobsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)segmentChangedAct:(id)sender;

- (IBAction)returnMerJobs:(UIStoryboardSegue *)segue;

@end
