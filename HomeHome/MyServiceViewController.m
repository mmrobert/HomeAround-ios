//
//  MyServiceViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-04.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MyServiceViewController.h"
#import "SWRevealViewController.h"
#import "ServiceDetailTableViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"

@interface MyServiceViewController ()

@property (strong, nonatomic) NSArray *myServiceList;

@property (strong, nonatomic) NSArray *rateDownloaded;

@end

@implementation MyServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarItem setTarget:self.revealViewController];
        [self.sideBarItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
 //serviceRate = {@"false", @"hasReview", @"3.8", @"rating", @"21", @"reviewNo", nil};
    
   // NSLog(@"56-pp-56----xx787xx--%@", [svc1 objectForKey:@"rating"]);
    
    self.myServiceList = [[NSArray alloc] init];
    self.rateDownloaded = [[NSArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchServices];
    
    if ([self.myServiceList count] > 0) {
        [self fetchEmails];
    }
  //  [self.tableView reloadData];
}

- (void)fetchServices {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyServiceEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:50];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.myServiceList = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)fetchEmails {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyServiceEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:@[@"email"]];
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:50];
    // Edit the sort key as appropriate.
    //   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"email" ascending:YES];
    //   NSArray *sortDescriptors = @[sortDescriptor];
    //  [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSInteger tempNo = [tempArr count];
    NSMutableArray *hereArr = [[NSMutableArray alloc] init];
    for (int ii = 0; ii < tempNo; ii++) {
        NSDictionary *aab = [tempArr objectAtIndex:ii];
        [hereArr addObject:[aab objectForKey:@"email"]];
    }
 //   NSLog(@"xx98--xx--pp--xx787xx--%lu", (unsigned long)[hereArr count]);
    [self loadingRating:hereArr];
}


- (void)loadingRating:(NSArray *)emailArr {
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading Services...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/servicerating"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", emailArr, @"emailarr", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                //   NSLog(@"pp98-pp-pp89----xx787");
                NSLog(@"%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    //   NSString *token = [returnedDict objectForKey:@"sessionId"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    self.rateDownloaded = [returnedDict objectForKey:@"ratelist"];
                    [self.tableView reloadData];
                    //  NSString *qqq = self.moreload ? @"Yes" : @"No";
                    //  NSLog(@"xx98-pp-xx--%@--xx787xx--%d", qqq, tempaa);
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

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

- (IBAction)returnMyService:(UIStoryboardSegue *)segue {
    
}

- (void)deleteService:(ServiceListTableViewCell *)cellView {
    NSIndexPath *selectedRow = [self.tableView indexPathForRowAtPoint:cellView.center];
    NSManagedObject *toDelete = [self.myServiceList objectAtIndex:selectedRow.row];
                                
    typedef void (^HandlerForDeleteService)(UIAlertAction *action);
    
    //   NSString *alertTitle = @"";
    //   NSString *alertMessage= @"";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForDeleteService handler = ^void (UIAlertAction *action) {
        [self.managedObjectContext deleteObject:toDelete];
        
        [self.appDelegate saveContext];
        [self fetchServices];
        [self.tableView reloadData];
    };
    
    NSString *firstActionTitle = @"Delete the Service";
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

- (void)deleteSvcNoReview:(SvcListNoReviewTableViewCell *)cellView {
    NSIndexPath *selectedRow = [self.tableView indexPathForRowAtPoint:cellView.center];
    NSManagedObject *toDelete = [self.myServiceList objectAtIndex:selectedRow.row];
    
    typedef void (^HandlerForDeleteService)(UIAlertAction *action);
    
    //   NSString *alertTitle = @"";
    //   NSString *alertMessage= @"";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForDeleteService handler = ^void (UIAlertAction *action) {
        [self.managedObjectContext deleteObject:toDelete];
        
        [self.appDelegate saveContext];
        [self fetchServices];
        [self.tableView reloadData];
    };
    
    NSString *firstActionTitle = @"Delete the Service";
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows
    if ([self.myServiceList count] < 1) {
        return 1;
    } else {
        return [self.myServiceList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.myServiceList count] < 1) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"serviceNoItem" forIndexPath:indexPath];
        return cell;
    } else {
        NSManagedObject *item = [self.myServiceList objectAtIndex:indexPath.row];
        NSDictionary *ratingItem;
        if ([self.rateDownloaded count] > 0) {
            for (NSDictionary *wwt in self.rateDownloaded) {
                if ([[wwt objectForKey:@"email"] isEqualToString:[item valueForKey:@"email"]]) {
                    ratingItem = wwt;
                }
            }
        }
        if ([[ratingItem objectForKey:@"hasReview"] boolValue]) {
            ServiceListTableViewCell *cell = (ServiceListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"serviceItem" forIndexPath:indexPath];
            if ([[item valueForKey:@"name"] isStringEmpty] || [item valueForKey:@"name"] == nil) {
                cell.serviceName.text = [item valueForKey:@"cat"];
            } else {
                cell.serviceName.text = [item valueForKey:@"name"];
            }
            cell.distance.text = [item valueForKey:@"distance"];
            cell.serviceRating.text = [NSString stringWithFormat:@"%@ (%@ reviews)", [ratingItem objectForKey:@"rating"], [ratingItem objectForKey:@"reviewNo"]];
            cell.serviceDetail.text = [item valueForKey:@"detail"];
            
            NSArray *starList = @[cell.star1, cell.star2, cell.star3, cell.star4, cell.star5];
            for (int i = 0; i < 5; i++) {
                UIImageView *temp = [starList objectAtIndex:i];
                temp.image = [UIImage imageNamed:@"StarGrey"];
            }
            float aa = [[ratingItem objectForKey:@"rating"] floatValue];
            int aaInt = (int)floorf(aa);
            float aaDecimal = aa - floorf(aa);
            
            for (int i = 0; i < aaInt; i++) {
                UIImageView *temp = [starList objectAtIndex:i];
                temp.image = [UIImage imageNamed:@"StarFull"];
            }
            if (aaDecimal > 0.24 && aaDecimal < 0.75) {
                UIImageView *temp = [starList objectAtIndex:aaInt];
                temp.image = [UIImage imageNamed:@"StarHalf"];
            } else if (aaDecimal >= 0.75) {
                UIImageView *temp = [starList objectAtIndex:aaInt];
                temp.image = [UIImage imageNamed:@"StarFull"];
            }
            
            cell.delegate = self;
            return cell;
        } else {
            SvcListNoReviewTableViewCell *cell = (SvcListNoReviewTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"serviceItemNoReview" forIndexPath:indexPath];
            if ([[item valueForKey:@"name"] isStringEmpty] || [item valueForKey:@"name"] == nil) {
                cell.name.text = [item valueForKey:@"cat"];
            } else {
                cell.name.text = [item valueForKey:@"name"];
            }
            cell.distance.text = [item valueForKey:@"distance"];
            cell.detail.text = [item valueForKey:@"detail"];
            
            cell.delegate = self;
            return cell;
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"myToServiceDetail"] || [[segue identifier] isEqualToString:@"noReviewToDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        NSManagedObject *object = [self.myServiceList objectAtIndex:indexPath.row];
        UINavigationController *nv = [segue destinationViewController];
        ServiceDetailTableViewController *mm = (ServiceDetailTableViewController *)[nv topViewController];
 
        mm.situationCode = 1;
        NSString *email = [object valueForKey:@"email"];
        NSString *name;
        if ([object valueForKey:@"name"] == nil || [[object valueForKey:@"name"] isStringEmpty]) {
            name = @"";
        } else {
            name = [object valueForKey:@"name"];
        }
        NSString *distance;
        if ([object valueForKey:@"distance"] == nil || [[object valueForKey:@"distance"] isStringEmpty]) {
            distance = @"";
        } else {
            distance = [object valueForKey:@"distance"];
        }
     //   NSString *rating = [object valueForKey:@"rating"];
     //   NSString *reviewNo = [object valueForKey:@"noOfReview"];
        NSString *detail;
        if ([object valueForKey:@"detail"] == nil || [[object valueForKey:@"detail"] isStringEmpty]) {
            detail = @"";
        } else {
            detail = [object valueForKey:@"detail"];
        }
        
        NSDictionary *ratingItem;
        if ([self.rateDownloaded count] > 0) {
            for (NSDictionary *wwt in self.rateDownloaded) {
                if ([[wwt objectForKey:@"email"] isEqualToString:email]) {
                    ratingItem = wwt;
                }
            }
        }
        NSString *rating = [ratingItem objectForKey:@"rating"];
        NSString *reviewNo = [ratingItem objectForKey:@"reviewNo"];
        
        NSString *qqq = [[ratingItem objectForKey:@"hasReview"] boolValue] ? @"YES" : @"NO";

        NSDictionary *service1 = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", email, @"email", distance, @"distance", qqq, @"hasReview", reviewNo, @"reviewNo", rating, @"rating", detail, @"detail", nil];
        
        mm.serviceFindDict = service1;
        mm.serviceCatStr = [object valueForKey:@"cat"];
/*
        //  mm.hidesBottomBarWhenPushed = YES;
*/
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
