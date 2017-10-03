//
//  JobPostedViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-18.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobPostedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *catViewContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *serviceCatL;

- (IBAction)returnJobPosted:(UIStoryboardSegue *)segue;
- (IBAction)refreshAct:(id)sender;

@end
