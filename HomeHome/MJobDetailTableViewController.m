//
//  MJobDetailTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MJobDetailTableViewController.h"
#import "MJobTimeTableViewCell.h"
#import "MJobDescriptionTableViewCell.h"
#import "MSendMsgViewController.h"

@interface MJobDetailTableViewController ()

@property NSArray *sectionNameList1;
@property (strong, nonatomic) NSArray *matchJob;

@end

@implementation MJobDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.sectionNameList1 = @[@"", @"", @"Time to Finish:", @"Job Details:", @""];

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.situationCode == 0) {
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MerJobEntity" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Set the batch size to a suitable number.
        // [fetchRequest setFetchBatchSize:50];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@ AND timePosted == %@", [self.jobItem objectForKey:@"email"], [self.jobItem objectForKey:@"timePosted"]];
        [fetchRequest setPredicate:predicate];
        
        self.matchJob = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [self.tableView reloadData];
    }
}

- (void)likeTheJob:(MJobInfoTableViewCell *)cellView {
    NSIndexPath *selectedRow = [self.tableView indexPathForRowAtPoint:cellView.center];
    MJobInfoTableViewCell *cell = (MJobInfoTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedRow];
    cell.heart.image = [UIImage imageNamed:@"Heart"];
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"MerJobEntity" inManagedObjectContext:self.managedObjectContext];
    
    [object setValue:[self.jobItem objectForKey:@"email"] forKey:@"email"];
    [object setValue:[self.jobItem objectForKey:@"name"] forKey:@"name"];
    [object setValue:[self.jobItem objectForKey:@"distance"] forKey:@"distance"];
    [object setValue:[self.jobItem objectForKey:@"jobTitle"] forKey:@"jobTitle"];
    [object setValue:[self.jobItem objectForKey:@"detail"] forKey:@"jobDetail"];
    [object setValue:@"contacting" forKey:@"jobStatus"];
    [object setValue:[self.jobItem objectForKey:@"timePosted"] forKey:@"timePosted"];
    [object setValue:[self.jobItem objectForKey:@"timeFinish"] forKey:@"timeFinish"];

    [self.appDelegate saveContext];
    //   NSLog(@"This a July 11.");
    cell.heart.userInteractionEnabled = NO;
}

- (void)changeTheStatus:(MJobStatusTableViewCell *)cellView {
 //   NSLog(@"123498765 -aaa - bbb");
    typedef void (^HandlerForChangeStatus)(UIAlertAction *action);
    
    NSString *alertTitle = @"Congratulations!";
    //   NSString *alertMessage= @"";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:alertTitle
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForChangeStatus handler = ^void (UIAlertAction *action) {
        NSString *newJobStatusStr;
        if ([self.jobStatusStr isEqualToString:@"contacting"]) {
            newJobStatusStr = @"active";
        } else if ([self.jobStatusStr isEqualToString:@"active"]) {
            newJobStatusStr = @"closed";
        }
        NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:0];
        MJobStatusTableViewCell *cell = (MJobStatusTableViewCell *)[self.tableView cellForRowAtIndexPath:temp];
        cell.statusL.text = [newJobStatusStr capitalizedString];
        if ([newJobStatusStr isEqualToString:@"contacting"]) {
            cell.changeStatusL.text = @"Get Contracted";
            cell.changeContainer.userInteractionEnabled = YES;
        } else if ([newJobStatusStr isEqualToString:@"active"]) {
            cell.changeStatusL.text = @"Complete the Job";
            cell.changeContainer.userInteractionEnabled = YES;
        } else {
            cell.changeStatusL.text = @"Take a Break";
            cell.changeContainer.userInteractionEnabled = NO;
        }
        
        self.jobStatusStr = newJobStatusStr;
        
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MerJobEntity" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Set the batch size to a suitable number.
        // [fetchRequest setFetchBatchSize:50];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [self.jobItem objectForKey:@"email"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *object in tempArr) {
            [object setValue:newJobStatusStr forKey:@"jobStatus"];
        }
        [self.appDelegate saveContext];
      //  [self.tableView reloadData];
    };
    
    NSString *firstActionTitle;
    if ([self.jobStatusStr isEqualToString:@"contacting"]) {
        firstActionTitle = @"Get Contracted";
    } else if ([self.jobStatusStr isEqualToString:@"active"]) {
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

- (void)deleteTheJob:(MJobDeleteTableViewCell *)cellView {
   // NSLog(@"123498765 -aaa - bbb");
    typedef void (^HandlerForDeleteJob)(UIAlertAction *action);
    
    NSString *alertTitle = @"Delete This Job?";
    //   NSString *alertMessage= @"";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:alertTitle
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForDeleteJob handler = ^void (UIAlertAction *action) {
        
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MerJobEntity" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Set the batch size to a suitable number.
        // [fetchRequest setFetchBatchSize:50];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [self.jobItem objectForKey:@"email"]];
        [fetchRequest setPredicate:predicate];
        
        NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *object in tempArr) {
            [self.managedObjectContext deleteObject:object];
        }
        [self.appDelegate saveContext];
        [self performSegueWithIdentifier:@"returnToMerJobs" sender:self];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// return the number of sections
    if (self.situationCode == 0) {
        return 3;
    } else {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// return the number of rows
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.situationCode == 0) {
        if (section == 0) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0)];
            UIColor *aa = [UIColor colorWithRed:(185.0/255.0) green:(185.0/255.0) blue:(185.0/255.0) alpha:1.0];
            [tempView setBackgroundColor:aa];
            
            return tempView;
        } else {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
            UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 15, 20)];
            [tLabel setFont:[UIFont boldSystemFontOfSize:16]];
            [tLabel setText:[self.sectionNameList1 objectAtIndex:(section + 1)]];
            [tLabel setTextColor:[UIColor whiteColor]];
            //  [tLabel setBackgroundColor:[UIColor grayColor]];
            [tempView addSubview:tLabel];
            UIColor *aa = [UIColor colorWithRed:(185.0/255.0) green:(185.0/255.0) blue:(185.0/255.0) alpha:1.0];
            [tempView setBackgroundColor:aa];
            
            return tempView;
        }
    } else {
        if (section == 0) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0)];
            UIColor *aa = [UIColor colorWithRed:(185.0/255.0) green:(185.0/255.0) blue:(185.0/255.0) alpha:1.0];
            [tempView setBackgroundColor:aa];
            
            return tempView;
        } else if (section == 4) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0)];
            UIColor *aa = [UIColor whiteColor];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.situationCode == 0) {
        if (section == 0) {
            return 10.0f;
        } else {
            return 30.0f;
        }
    } else {
        if (section == 0 || section == 1) {
            return 10.0f;
        } else if (section == 4) {
            return 0.0f;
        } else {
            return 30.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.situationCode == 0) {
        if (indexPath.section == 0) {
            MJobInfoTableViewCell *cell = (MJobInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobinfoCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.jobTitle.text = [self.jobItem objectForKey:@"jobTitle"];
            cell.distance.text = [self.jobItem objectForKey:@"distance"];
            cell.name.text = [self.jobItem objectForKey:@"name"];
            cell.timePostedL.text = [self.jobItem objectForKey:@"timePosted"];
            if ([self.matchJob count] > 0) {
                cell.heart.image = [UIImage imageNamed:@"Heart"];
                cell.heart.userInteractionEnabled = NO;
            } else {
                cell.heart.image = [UIImage imageNamed:@"HeartPre"];
                cell.heart.userInteractionEnabled = YES;
            }
            cell.delegate = self;
            return cell;
        } else if (indexPath.section == 1) {
            MJobTimeTableViewCell *cell = (MJobTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobtimeCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.time.text = [self.jobItem objectForKey:@"timeFinish"];
            return cell;
        } else {
            MJobDescriptionTableViewCell *cell = (MJobDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobdescriptionCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.detail.text = [self.jobItem objectForKey:@"detail"];
            return cell;
        }
    } else {
        if (indexPath.section == 0) {
            MJobStatusTableViewCell *cell = (MJobStatusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobStatusCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.statusL.text = [self.jobStatusStr capitalizedString];
            if ([self.jobStatusStr isEqualToString:@"contacting"]) {
                cell.changeStatusL.text = @"Get Contracted";
                cell.changeContainer.userInteractionEnabled = YES;
            } else if ([self.jobStatusStr isEqualToString:@"active"]) {
                cell.changeStatusL.text = @"Complete the Job";
                cell.changeContainer.userInteractionEnabled = YES;
            } else {
                cell.changeStatusL.text = @"Take a Break";
                cell.changeContainer.userInteractionEnabled = NO;
            }
            cell.delegate = self;
            return cell;
        } else if (indexPath.section == 1) {
            MJobInfoTableViewCell *cell = (MJobInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobinfoCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.jobTitle.text = [self.jobItem objectForKey:@"jobTitle"];
            cell.distance.text = [self.jobItem objectForKey:@"distance"];
            cell.name.text = [self.jobItem objectForKey:@"name"];
            cell.timePostedL.text = [self.jobItem objectForKey:@"timePosted"];
                cell.heart.image = [UIImage imageNamed:@"Heart"];
                cell.heart.userInteractionEnabled = NO;
        //    NSLog(@"123456--99 %lu", (unsigned long)[self.matchJob count]);
            cell.delegate = self;
            return cell;
        } else if (indexPath.section == 2) {
            MJobTimeTableViewCell *cell = (MJobTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobtimeCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.time.text = [self.jobItem objectForKey:@"timeFinish"];
            return cell;
        } else if (indexPath.section == 3) {
            MJobDescriptionTableViewCell *cell = (MJobDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"jobdescriptionCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.detail.text = [self.jobItem objectForKey:@"detail"];
            return cell;
        } else {
            MJobDeleteTableViewCell *cell = (MJobDeleteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"deleteJobCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.delegate = self;
            return cell;
        }
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
    if ([[segue identifier] isEqualToString:@"MsendMsgSegue"]) {
        MSendMsgViewController *mm = (MSendMsgViewController *)[segue destinationViewController];
        
        mm.customDict = self.jobItem;
    }
}

- (IBAction)cancelAct:(id)sender {
    if (self.situationCode == 0) {
        [self performSegueWithIdentifier:@"returnToJobPosted" sender:self];
    } else {
        [self performSegueWithIdentifier:@"returnToMerJobs" sender:self];
    }
}

@end
