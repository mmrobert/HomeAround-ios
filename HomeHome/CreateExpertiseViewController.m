//
//  CreateExpertiseViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-31.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CreateExpertiseViewController.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface CreateExpertiseViewController ()

@property (strong, nonatomic) NSArray *serviceCatList;
@property (strong, nonatomic) NSMutableArray *selectedCatList;

@property NSMutableArray *selectedIndexPathes;

@end

@implementation CreateExpertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   CGFloat tempW = self.laterBtn.frame.size.width;
 //   self.laterBtn.layer.cornerRadius = tempW / 2;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
   // self.serviceCatList = @[@"Sofa Cleaning", @"Carpet Cleaning", @"Duct Cleaning"];
    self.serviceCatList = [[NSArray alloc] init];
    self.selectedCatList = [[NSMutableArray alloc] init];
    
    self.selectedIndexPathes = [[NSMutableArray alloc] init];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"createExCell" forIndexPath:indexPath];
    // Configure the cell...
    NSString *tempStr = [self.serviceCatList objectAtIndex:indexPath.row];
    cell.textLabel.text = tempStr;
    //   NSLog(@"here just test");
    if ([self.selectedIndexPathes containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  NSLog(@"Cat selected!!");
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *tempStr = [self.serviceCatList objectAtIndex:indexPath.row];
    
    [self.selectedCatList addObject:tempStr];
    //   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //   [self.navigationController popViewControllerAnimated:YES];
    [self.selectedIndexPathes addObject:indexPath];
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
    
    [self.selectedIndexPathes removeObject:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"saveExpertiseSegue"]) {
        //   UINavigationController *nv = [segue destinationViewController];
    }
}
*/

- (IBAction)saveAct:(id)sender {
    if ([self.selectedCatList count] < 1) {
        NSString *alertMsg = @"Choose your expertise to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        [self connectingServer];
        //  NSLog(@"999--test here--999");
    }
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Saving expertise...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"setexpertise"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectedCatList, @"expertise", uToken, @"token", nil];
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
                    
                    NSString *experStr = [self.selectedCatList componentsJoinedByString:@",\n"];
                    [[NSUserDefaults standardUserDefaults] setObject:experStr forKey:myExpertise];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSegueWithIdentifier:@"ExpertiseToNext" sender:self];
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

@end
