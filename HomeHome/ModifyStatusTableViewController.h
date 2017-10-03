//
//  ModifyStatusTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyStatusTableViewController : UITableViewController

@property (strong, nonatomic) NSString *statusStr;

@property (weak, nonatomic) IBOutlet UITableViewCell *pendingCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *inProgressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *completedCell;

@end
