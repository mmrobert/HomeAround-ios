//
//  CountryListTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-08-17.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CountryListTableViewController.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface CountryListTableViewController ()

@property (strong, nonatomic) NSArray *countryList;

@end

@implementation CountryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Select Your Country";
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
  //  self.countryList = @[@"Canada", @"United States"];
    self.countryList = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchCountryList];
    
    //  [self.tableView reloadData];
}

#pragma networking

- (void)fetchCountryList {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading Country List...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"countrylist"]];
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
                    
                    self.countryList = [returnedDict objectForKey:@"list"];
                    [self.tableView reloadData];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                 //   NSString *alertMsg = msg;
                 //   NSString *okTitle = @"OK";
                 //   [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
                }
                
            }
        }
    }];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows
    return [self.countryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryItem" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = [self.countryList objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:self.chosedCountry]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempCountry = [self.countryList objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:tempCountry forKey:myCountry];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
