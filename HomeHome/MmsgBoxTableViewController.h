//
//  MmsgBoxTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MmsgBoxTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
