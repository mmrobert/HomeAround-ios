//
//  CMFirstPageViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-26.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CMFirstPageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet UIButton *postJobBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)returnToJobList:(UIStoryboardSegue *)segue;

@end
