//
//  CreateJobTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-08-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CreateJobTableViewController : UITableViewController

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *timeCreatedStr;
@property (strong, nonatomic) NSString *catStr;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *statusStr;
@property (strong, nonatomic) NSString *timeToFinishStr;
@property (strong, nonatomic) NSString *detailStr;

- (IBAction)savePost:(id)sender;

@end
