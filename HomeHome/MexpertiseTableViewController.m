//
//  MexpertiseTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-29.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MexpertiseTableViewController.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface MexpertiseTableViewController ()

@property (strong, nonatomic) NSArray *serviceCatList;
@property (strong, nonatomic) NSMutableArray *selectedCatList;
@property (strong, nonatomic) NSMutableArray *selectedIndexList;

@end

@implementation MexpertiseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.serviceCatList = [[NSArray alloc] init];
  //
    NSString *expertise = [[NSUserDefaults standardUserDefaults] objectForKey:myExpertise];
    if (expertise) {
        NSArray *tempArr = [expertise componentsSeparatedByString:@",\n"];
        self.selectedCatList = [NSMutableArray arrayWithArray:tempArr];
    } else {
        self.selectedCatList = [[NSMutableArray alloc] init];
    }
    self.selectedIndexList = [[NSMutableArray alloc] init];
 //   [self.tableView reloadData];
    [self fetchServiceList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                    
                    for (NSIndexPath *temp in self.selectedIndexList) {
                        [self.tableView selectRowAtIndexPath:temp animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *alertMsg = msg;
                    NSString *okTitle = @"OK";
                    [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
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

- (IBAction)doneAct:(id)sender {
//    NSString *temp = [self.selectedCatList componentsJoinedByString:@",\n"];
 //   [[NSUserDefaults standardUserDefaults] setObject:temp forKey:myExpertise];
 //   [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *key = @"keyStr";
    NSString *newValue = [self.selectedCatList componentsJoinedByString:@",\n"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSetExpertise" object:nil userInfo:dictionary];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAct:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expertiseCell" forIndexPath:indexPath];
    // Configure the cell...
    NSString *tempStr = [self.serviceCatList objectAtIndex:indexPath.row];
    cell.textLabel.text = tempStr;
    if ([self.selectedCatList containsObject:tempStr]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedIndexList addObject:indexPath];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
 //   NSLog(@"here just test");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //  NSLog(@"Cat selected!!");
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *tempStr = [self.serviceCatList objectAtIndex:indexPath.row];

    [self.selectedCatList addObject:tempStr];
 //   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
 //   [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  //  NSLog(@"Cat remove selected!!");
    UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
    tempCell.accessoryType = UITableViewCellAccessoryNone;

    NSString *toDelete;
    for (NSString *object in self.selectedCatList) {
        if ([tempCell.textLabel.text isEqualToString:object]) {
            toDelete = object;
        }
    }
    [self.selectedCatList removeObject:toDelete];
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
