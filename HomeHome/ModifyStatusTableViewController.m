//
//  ModifyStatusTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ModifyStatusTableViewController.h"

@interface ModifyStatusTableViewController ()

@end

@implementation ModifyStatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([self.statusStr isEqualToString:@"Pending"]) {
        self.pendingCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([self.statusStr isEqualToString:@"In Progress"]) {
        self.inProgressCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([self.statusStr isEqualToString:@"Completed"]) {
        self.completedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15.0f;
    }
    return 1.0f;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self save:@"Pending"];
        } else if (indexPath.row == 1) {
            [self save:@"In Progress"];
        } else if (indexPath.row == 2) {
            [self save:@"Completed"];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)save:(NSString *) status {
    NSString *key = @"keyStr";
    NSString *newValue = status;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationStatus" object:nil userInfo:dictionary];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
