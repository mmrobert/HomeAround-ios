//
//  ModifyJobTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-01.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ModifyJobTableViewController.h"
#import "JobCatTableViewCell.h"
#import "JobTitleTableViewCell.h"
#import "JobTimeToFinishTableViewCell.h"
#import "JobDetailTableViewCell.h"
#import "ModifyJobTitleViewController.h"
#import "ModifyFinishTimeViewController.h"
#import "ModifyDetailViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"

@interface ModifyJobTableViewController ()

@property NSArray *sectionNameList1;

@property (strong, nonatomic) NSString *catString;
@property (strong, nonatomic) NSString *statusString;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *timeToFinishString;
@property (strong, nonatomic) NSString *detailString;
@property (strong, nonatomic) NSString *timeCreatedString;
//@property (strong, nonatomic) NSString *postString;

@end

@implementation ModifyJobTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.sectionNameList1 = @[@"", @"", @"Job Title", @"Time to Finish", @"Job Details", @""];
    
    self.catString = [self.jobItem valueForKey:@"jobCat"];
    self.statusString = [self.jobItem valueForKey:@"jobStatus"];
    self.titleString = [self.jobItem valueForKey:@"jobTitle"];
    self.timeToFinishString = [self.jobItem valueForKey:@"timeToFinish"];
    self.detailString = [self.jobItem valueForKey:@"jobDetail"];
    self.timeCreatedString = [self.jobItem valueForKey:@"timeCreated"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTitleShow:) name:@"notificationTitleModify" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFinishTimeShow:) name:@"notificationFinishTimeModify" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDetailShow:) name:@"notificationDetailModify" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

#pragma notification functions

- (void)newTitleShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.titleString = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

- (void)newFinishTimeShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.timeToFinishString = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

- (void)newDetailShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.detailString = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

- (void)changeJobStatus:(JobStatusTableViewCell *)cellView {
    //   NSLog(@"123498765 -aaa - bbb");
    typedef void (^HandlerForChangeStatus)(UIAlertAction *action);
    
  //  NSString *alertTitle = @"Congratulations!";
    NSString *alertMessage = @"Congratulations!";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:alertMessage
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForChangeStatus handler = ^void (UIAlertAction *action) {
        
        if ([self.statusString isEqualToString:@"Saved"]) {
            [self updateJobPostOnServer];
        } else {
            [self updateJobStatusOnServer];
        }
    };
    
    NSString *firstActionTitle;
    if ([self.statusString isEqualToString:@"Saved"]) {
        firstActionTitle = @"Post the Job";
    } else if ([self.statusString isEqualToString:@"Posted"]) {
        firstActionTitle = @"Contract out the Job";
    } else if ([self.statusString isEqualToString:@"In Progress"]) {
        firstActionTitle = @"Complete the Job";
    }
    UIAlertAction *changeS = [UIAlertAction actionWithTitle:firstActionTitle
                                                      style:UIAlertActionStyleDefault
                                                    handler:handler];
    NSString *thirdActionTitle = @"Cancel";
    UIAlertAction *cancell = [UIAlertAction actionWithTitle:thirdActionTitle
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    [alert addAction:changeS];
    [alert addAction:cancell];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPresenter.sourceView = cellView;
        popPresenter.sourceRect = cellView.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)updateJobStatusForUI {
 //   NSString *oldJobStatus = self.statusString;
    NSString *newJobStatusStr;
    if ([self.statusString isEqualToString:@"Saved"]) {
        newJobStatusStr = @"Posted";
    } else if ([self.statusString isEqualToString:@"Posted"]) {
        newJobStatusStr = @"In Progress";
    } else if ([self.statusString isEqualToString:@"In Progress"]) {
        newJobStatusStr = @"Completed";
    }
    NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:0];
    JobStatusTableViewCell *cell = (JobStatusTableViewCell *)[self.tableView cellForRowAtIndexPath:temp];
    cell.statusL.text = [newJobStatusStr capitalizedString];
    if ([newJobStatusStr isEqualToString:@"Posted"]) {
        cell.changeStatusL.text = @"Contract Out";
        cell.changeContainer.userInteractionEnabled = YES;
    } else if ([newJobStatusStr isEqualToString:@"In Progress"]) {
        cell.changeStatusL.text = @"Complete the Job";
        cell.changeContainer.userInteractionEnabled = YES;
    } else {
        cell.changeStatusL.text = @"Take a Break";
        cell.changeContainer.userInteractionEnabled = NO;
    }
    
    self.statusString = newJobStatusStr;
}

#pragma networking

- (void)updateJobPostOnServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Posting job...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/topostjob"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", self.catString, @"jobcat", self.timeCreatedString, @"createdtime", "Posted", @"jobstatus", self.titleString, @"jobtitle", self.timeToFinishString, @"timetofinish", self.detailString, @"jobdetail", nil];
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
                    [self updateJobStatusForUI];
                    [self updateJobCoreData];
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

- (void)updateJobStatusOnServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Updating job status...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/updatejobstatus"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    NSString *newJobStatusString;
    if ([self.statusString isEqualToString:@"Saved"]) {
        newJobStatusString = @"Posted";
    } else if ([self.statusString isEqualToString:@"Posted"]) {
        newJobStatusString = @"In Progress";
    } else if ([self.statusString isEqualToString:@"In Progress"]) {
        newJobStatusString = @"Completed";
    }
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", newJobStatusString, @"jobstatus", self.timeCreatedString, @"createdtime", nil];
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
                    [self updateJobStatusForUI];
                    [self updateJobCoreData];
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

- (void)deleteTheJob:(JobDeleteTableViewCell *)cellView {
    // NSLog(@"123498765 -aaa - bbb");
    typedef void (^HandlerForDeleteJob)(UIAlertAction *action);
    
    NSString *alertTitle = @"Delete This Job?";
    //   NSString *alertMessage= @"";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:alertTitle
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForDeleteJob handler = ^void (UIAlertAction *action) {
        [self deleteJobOnServer];
        //  [self.tableView reloadData];
    };
    
    NSString *firstActionTitle = @"Delete";
    UIAlertAction *deleteS = [UIAlertAction actionWithTitle:firstActionTitle
                                                      style:UIAlertActionStyleDefault
                                                    handler:handler];
    NSString *thirdActionTitle = @"Cancel";
    UIAlertAction *cancell = [UIAlertAction actionWithTitle:thirdActionTitle
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    [alert addAction:deleteS];
    [alert addAction:cancell];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPresenter.sourceView = cellView;
        popPresenter.sourceRect = cellView.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma networking

- (void)deleteJobOnServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Deleting job...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/deletejob"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", self.timeCreatedString, @"createdtime", nil];
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
                    [self deleteJobCoreData];
                    [self performSegueWithIdentifier:@"FromModifyJob" sender:self];
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

- (void)deleteJobCoreData {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyJobEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:50];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeCreated == %@", self.timeCreatedString];
    [fetchRequest setPredicate:predicate];
    
    NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in tempArr) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.appDelegate saveContext];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return the number of sections
        return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return the number of rows
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 5) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        
        [tempView setBackgroundColor:[UIColor whiteColor]];
        
        return tempView;
    } else if (section == 1) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
        UIColor *aa = [UIColor colorWithRed:(185.0/255.0) green:(185.0/255.0) blue:(185.0/255.0) alpha:1.0];
        [tempView setBackgroundColor:aa];
        
        return tempView;
    } else {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 15, 20)];
        [tLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [tLabel setText:[self.sectionNameList1 objectAtIndex:section]];
        [tLabel setTextColor:[UIColor whiteColor]];
        //  [tLabel setBackgroundColor:[UIColor grayColor]];
        [tempView addSubview:tLabel];
        UIColor *aa = [UIColor colorWithRed:(185.0/255.0) green:(185.0/255.0) blue:(185.0/255.0) alpha:1.0];
        [tempView setBackgroundColor:aa];
        
        return tempView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 5) {
        return 0.0f;
    } else if (section == 1) {
        return 10.0f;
    } else {
        return 30.0f;
    }
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    if (self.situationCode == 1) {
        switch (section) {
            case 0:
                sectionName = @"";
                break;
            case 1:
                sectionName = @"Status";
                break;
            case 2:
                sectionName = @"Time to Finish";
                break;
            case 3:
                sectionName = @"Detail";
                break;
            case 4:
                sectionName = @"";
                break;
            default:
                sectionName = @"";
                break;
        }
    } else {
        switch (section) {
            case 0:
                sectionName = @"";
                break;
            case 1:
                sectionName = @"Status";
                break;
            case 2:
                sectionName = @"Time to Finish";
                break;
            case 3:
                sectionName = @"Detail";
                break;
            default:
                sectionName = @"";
                break;
        }
    }
    return sectionName;
}
*/
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JobStatusTableViewCell *cell = (JobStatusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobStatusCell" forIndexPath:indexPath];
        // Configure the cell...
        cell.statusL.text = [self.statusString capitalizedString];
        if ([self.statusString isEqualToString:@"Saved"]) {
            cell.changeStatusL.text = @"To Post";
            cell.changeContainer.userInteractionEnabled = YES;
        } else if ([self.statusString isEqualToString:@"Posted"]) {
            cell.changeStatusL.text = @"Contract Out";
            cell.changeContainer.userInteractionEnabled = YES;
        } else if ([self.statusString isEqualToString:@"In Progress"]) {
            cell.changeStatusL.text = @"Complete";
            cell.changeContainer.userInteractionEnabled = YES;
        } else {
            cell.changeStatusL.text = @"Take a Break";
            cell.changeContainer.userInteractionEnabled = NO;
        }
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        JobCatTableViewCell *cell = (JobCatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobCatCell" forIndexPath:indexPath];
        cell.jobCatLabel.text = self.catString;
        return cell;
    } else if (indexPath.section == 2) {
        JobTitleTableViewCell *cell = (JobTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobTitleCell" forIndexPath:indexPath];
        // Configure the cell...
        if (![self.titleString isStringEmpty]) {
            cell.jobTitleLabel.text = self.titleString;
            cell.jobTitleLabel.textColor = [UIColor blackColor];
        } else {
            cell.jobTitleLabel.text = @"Update job title";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.jobTitleLabel.textColor = aa;
        }
        return cell;
    } else if (indexPath.section == 3) {
        JobTimeToFinishTableViewCell *cell = (JobTimeToFinishTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobTimeToFinishCell" forIndexPath:indexPath];
        // Configure the cell...
        if (![self.timeToFinishString isStringEmpty]) {
            cell.timeToFinish.text = self.timeToFinishString;
            cell.timeToFinish.textColor = [UIColor blackColor];
        } else {
            cell.timeToFinish.text = @"Update finishing time";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.timeToFinish.textColor = aa;
        }
        return cell;
    } else if (indexPath.section == 4) {
        JobDetailTableViewCell *cell = (JobDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobDetailCell" forIndexPath:indexPath];
        // Configure the cell...
        if (![self.detailString isStringEmpty]) {
            cell.jobDetail.text = self.detailString;
            cell.jobDetail.textColor = [UIColor blackColor];
        } else {
            cell.jobDetail.text = @"Update job details";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.jobDetail.textColor = aa;
        }
        return cell;
    } else {
        JobDeleteTableViewCell *cell = (JobDeleteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobDeleteCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
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
    if ([[segue identifier] isEqualToString:@"modifyJobTitleSegue"]) {
    //   UINavigationController *nv = [segue destinationViewController];
        ModifyJobTitleViewController *mm = (ModifyJobTitleViewController *)[segue destinationViewController];
        
        mm.situationCode = 1;
        mm.titleStr = self.titleString;
        
        //  mm.hidesBottomBarWhenPushed = YES;
    }
    if ([[segue identifier] isEqualToString:@"modifyFinishTimeSegue"]) {
        //   UINavigationController *nv = [segue destinationViewController];
        ModifyFinishTimeViewController *mm = (ModifyFinishTimeViewController *)[segue destinationViewController];
        mm.situationCode = 1;
        mm.timeToFinishStr = self.timeToFinishString;
    }
    if ([[segue identifier] isEqualToString:@"modifyDetailSegue"]) {
        //   UINavigationController *nv = [segue destinationViewController];
        ModifyDetailViewController *mm = (ModifyDetailViewController *)[segue destinationViewController];
        mm.situationCode = 1;
        mm.detailStr = self.detailString;
    }
}

- (IBAction)saveJob:(id)sender {
    if ([self.statusString isEqualToString:@"Saved"]) {
        [self updateJobCoreData];
    } else {
        [self updateJobOnServer];
    }
}

#pragma networking

- (void)updateJobOnServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Updating job...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/updatejob"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", self.timeCreatedString, @"createdtime", self.statusString, @"jobstatus", self.titleString, @"jobtitle", self.timeToFinishString, @"timetofinish", self.detailString, @"jobdetail", nil];
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
                    [self updateJobCoreData];
                    [self performSegueWithIdentifier:@"FromModifyJob" sender:self];
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

- (void)updateJobCoreData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyJobEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeCreated == %@", self.timeCreatedString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *object = [tempArr objectAtIndex:0];
    [object setValue:self.statusString forKey:@"jobStatus"];
    [object setValue:self.timeToFinishString forKey:@"timeToFinish"];
    [object setValue:self.detailString forKey:@"jobDetail"];
    [object setValue:self.titleString forKey:@"jobTitle"];
    [self.appDelegate saveContext];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
