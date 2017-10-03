//
//  MsgBoxTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-13.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MsgBoxTableViewController : UITableViewController

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;

@end
