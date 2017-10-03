//
//  CreateJobTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-08-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CreateJobTableViewController.h"
#import "CjobCatTableViewCell.h"
#import "CjobTitleTableViewCell.h"
#import "CjobTimeFinishTableViewCell.h"
#import "CjobDetailTableViewCell.h"
#import "ModifyJobTitleViewController.h"
#import "ModifyFinishTimeViewController.h"
#import "ModifyDetailViewController.h"
#import "NSString+EmptyCheck.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"

@interface CreateJobTableViewController ()

@property NSArray *sectionNameList1;

@end

@implementation CreateJobTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.sectionNameList1 = @[@"", @"Job Title", @"Time to Finish", @"Job Details", @""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTitleShow:) name:@"notificationTitleC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFinishTimeShow:) name:@"notificationFinishTimeC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDetailShow:) name:@"notificationDetailC" object:nil];
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

- (void)newTitleShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.titleStr = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

- (void)newFinishTimeShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.timeToFinishStr = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

- (void)newDetailShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.detailStr = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return the number of rows
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        //  [tLabel setBackgroundColor:[UIColor grayColor]];
        [tempView setBackgroundColor:[UIColor whiteColor]];
        
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
    if (section == 0) {
        return 0.0f;
    } else {
        return 30.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CjobCatTableViewCell *cell = (CjobCatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cJobCatCell" forIndexPath:indexPath];
        // Configure the cell...
        cell.catLabel.text = self.catStr;
        return cell;
    } else if (indexPath.section == 1) {
        CjobTitleTableViewCell *cell = (CjobTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cJobTitleCell" forIndexPath:indexPath];
        // Configure the cell...
        if (![self.titleStr isStringEmpty]) {
            cell.jobTitleLabel.text = self.titleStr;
            cell.jobTitleLabel.textColor = [UIColor blackColor];
        } else {
            cell.jobTitleLabel.text = @"Your job title";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.jobTitleLabel.textColor = aa;
        }
        return cell;
    } else if (indexPath.section == 2) {
        CjobTimeFinishTableViewCell *cell = (CjobTimeFinishTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cTimeFinishCell" forIndexPath:indexPath];
        // Configure the cell...
        if (![self.timeToFinishStr isStringEmpty]) {
            cell.timeFinishLabel.text = self.timeToFinishStr;
            cell.timeFinishLabel.textColor = [UIColor blackColor];
        } else {
            cell.timeFinishLabel.text = @"Time to finish";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.timeFinishLabel.textColor = aa;
        }
        return cell;
    } else {
        CjobDetailTableViewCell *cell = (CjobDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cJobDetailCell" forIndexPath:indexPath];
        // Configure the cell...
        if (![self.detailStr isStringEmpty]) {
            cell.jobDetailLabel.text = self.detailStr;
            cell.jobDetailLabel.textColor = [UIColor blackColor];
        } else {
            cell.jobDetailLabel.text = @"Your job detail";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.jobDetailLabel.textColor = aa;
        }
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"createTitleSegue"]) {
        //   UINavigationController *nv = [segue destinationViewController];
        ModifyJobTitleViewController *mm = (ModifyJobTitleViewController *)[segue destinationViewController];
        
        mm.situationCode = 0;
        mm.titleStr = self.titleStr;
        
        //  mm.hidesBottomBarWhenPushed = YES;
    }
    if ([[segue identifier] isEqualToString:@"cToFinishTime"]) {
        //   UINavigationController *nv = [segue destinationViewController];
        ModifyFinishTimeViewController *mm = (ModifyFinishTimeViewController *)[segue destinationViewController];
        mm.situationCode = 0;
        mm.timeToFinishStr = self.timeToFinishStr;
    }
    if ([[segue identifier] isEqualToString:@"cToJobDetail"]) {
        //   UINavigationController *nv = [segue destinationViewController];
        ModifyDetailViewController *mm = (ModifyDetailViewController *)[segue destinationViewController];
        mm.situationCode = 0;
        mm.detailStr = self.detailStr;
    }
}

- (IBAction)savePost:(id)sender {
    if ([self.detailStr isStringEmpty] || self.detailStr == nil) {
        NSString *alertMsg = @"Please enter your job detail.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        [self savePostHandlingH];
    }
}

- (void)savePostHandlingH {
    typedef void (^HandlerForSavePost)(UIAlertAction *action);
    
    //   NSString *alertTitle = @"";
    //   NSString *alertMessage= @"";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForSavePost handlerSave = ^void (UIAlertAction *action) {
        [self setUpDateAndStatus:@"Saved"];
        [self saveIt];
        //   [self performSegueWithIdentifier:@"controllerReturn" sender:self];
    };
    HandlerForSavePost handlerPost = ^void (UIAlertAction *action) {
        [self setUpDateAndStatus:@"Posted"];
        [self savePostIt];
        //  [self performSegueWithIdentifier:@"controllerReturn" sender:self];
    };
    
    NSString *firstActionTitle = @"Save & Post";
    UIAlertAction *savePost = [UIAlertAction actionWithTitle:firstActionTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:handlerPost];
    NSString *secondActionTitle = @"Save Only";
    UIAlertAction *saveOnly = [UIAlertAction actionWithTitle:secondActionTitle style:UIAlertActionStyleDefault handler:handlerSave];
    NSString *thirdActionTitle = @"Cancel";
    UIAlertAction *cancell = [UIAlertAction actionWithTitle:thirdActionTitle
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    [alert addAction:savePost];
    [alert addAction:saveOnly];
    [alert addAction:cancell];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPresenter.sourceView = self.view;
        popPresenter.sourceRect = CGRectMake(10, 10, 10, 10);
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)saveIt {
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"MyJobEntity" inManagedObjectContext:self.managedObjectContext];
    
    [object setValue:self.timeCreatedStr forKey:@"timeCreated"];
    [object setValue:self.catStr forKey:@"jobCat"];
    [object setValue:self.statusStr forKey:@"jobStatus"];
    [object setValue:self.titleStr forKey:@"jobTitle"];
    [object setValue:self.timeToFinishStr forKey:@"timeToFinish"];
    [object setValue:self.detailStr forKey:@"jobDetail"];
    
    [self.appDelegate saveContext];
    
    [self performSegueWithIdentifier:@"controllerReturn" sender:self];
}

- (void)savePostIt {
    [self connectingServer];
}

- (void)setUpDateAndStatus:(NSString *)statusH {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:now];
    self.timeCreatedStr = dateStr;
    
    if ([self.titleStr isStringEmpty] || self.titleStr == nil) {
        self.titleStr = self.catStr;
    }
    
    self.statusStr = statusH;
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Posting job...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/topostjob"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", self.catStr, @"jobcat", self.timeCreatedStr, @"createdtime", self.statusStr, @"jobstatus", self.titleStr, @"jobtitle", self.timeToFinishStr, @"timetofinish", self.detailStr, @"jobdetail", nil];
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
                    [self saveIt];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
