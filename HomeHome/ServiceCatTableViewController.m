//
//  ServiceCatTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-03.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ServiceCatTableViewController.h"
#import "CreateJobTableViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AppConstants.h"
#import "NSString+EmptyCheck.h"

@interface ServiceCatTableViewController ()

@property NSArray *serviceCatList;

@end

@implementation ServiceCatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // self.serviceCatList = @[@"General Cleaning", @"Carpet Cleaning", @"Duct Cleaning"];
    self.serviceCatList = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *nameS = [[NSUserDefaults standardUserDefaults] objectForKey:myNickName];
    NSString *locS = [[NSUserDefaults standardUserDefaults] objectForKey:myPostalCode];
    
    if (locS == nil || [locS isStringEmpty]) {
        NSString *alertMsg = @"Please enter your postal code in the Settings to create a job.";
        NSString *okTitle = @"OK";
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:alertMsg
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (nameS == nil || [nameS isStringEmpty]) {
        NSString *alertMsg = @"Please enter your name in the setting to create a job.";
        NSString *okTitle = @"OK";
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:alertMsg
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self fetchServiceList];
    }
    //  [self.tableView reloadData];
}

#pragma networking

- (void)fetchServiceList {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading Services List...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"servicelist"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    //   NSString *token = [returnedDict objectForKey:@"sessionId"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSArray *tempArr = [returnedDict objectForKey:@"list"];
                    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
                    self.serviceCatList = [tempArr sortedArrayUsingDescriptors:@[sd]];
                    [self.tableView reloadData];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                //    NSString *alertMsg = msg;
                //    NSString *okTitle = @"OK";
                //    [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
                }
                
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//   return the number of rows
    return [self.serviceCatList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCatCell" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = [self.serviceCatList objectAtIndex:indexPath.row];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toCreateJobSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = [self.serviceCatList objectAtIndex:indexPath.row];
     //   UINavigationController *nv = [segue destinationViewController];
        CreateJobTableViewController *mm = (CreateJobTableViewController *)[segue destinationViewController];
        
        mm.catStr = object;
        mm.titleStr = @"";
        mm.statusStr = @"";
        mm.timeToFinishStr = @"";
        mm.detailStr = @"";
        mm.timeCreatedStr = @"";
        //  mm.hidesBottomBarWhenPushed = YES;
    }
}

#pragma alert presentation

- (void)presentaAlert:(NSString *)aTitle withMsg:(NSString *)aMsg withConfirmTitle:(NSString *)aConfirmTitle {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:aTitle
                                message:aMsg
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:aConfirmTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
