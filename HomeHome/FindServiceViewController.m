//
//  FindServiceViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-07.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "FindServiceViewController.h"
#import "ServiceDetailTableViewController.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "NSString+EmptyCheck.h"

@interface FindServiceViewController ()

@property NSMutableArray *services;
@property NSMutableArray *searchedServices;
@property BOOL shouldShowSearchResults;

- (void)loadMore:(NSString *)loadingLast numberOfLoading:(NSString *)numberOfLoad;

@property NSString *loadingLastTag;
@property BOOL moreload;
@property NSInteger lastRowShowNo;

@property NSArray *myServiceEmails;

@end

@implementation FindServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.definesPresentationContext = YES;

    self.searchBar.delegate = self;
    self.shouldShowSearchResults = NO;
    self.moreload = NO;
    self.lastRowShowNo = 0;
    
    self.navigationItem.title = self.serviceCat;
    
  //service = {@"", @"email", @"", @"name", @"", @"distance", @"true", @"hasReview",
  //  @"1.8", @"rating", @"21", @"reviewNo", @"Fgg", @"detail", nil};
    
  //  self.services = @[service1, service2];
    self.searchedServices = [[NSMutableArray alloc] init];
    self.services = [[NSMutableArray alloc] init];
    self.myServiceEmails = [[NSArray alloc] init];
    
    self.loadingLastTag = @"0";
    [self loadMore:self.loadingLastTag numberOfLoading:@"20"];
/*
    NSString *testT = @"q";
    BOOL testBool = [testT boolValue];
    if (testBool) {
        NSLog(@"test for str - bool 999");
    }
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    self.myServiceEmails = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    [self.tableView reloadData];
    
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        if (self.lastRowShowNo >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.lastRowShowNo inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (void)loadMore:(NSString *)loadingLast numberOfLoading:(NSString *)numberOfLoad {

    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading Services...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/serviceload"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", loadingLast, @"loadednumber", numberOfLoad, @"numberofLoad", self.serviceCat, @"servicecat", nil];
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
                 //   self.services = [returnedDict objectForKey:@"svclist"];
                    self.moreload = [[returnedDict objectForKey:@"moreloads"] boolValue];
                    int tempaa = [[returnedDict objectForKey:@"loadedsvc"] intValue];
                    self.loadingLastTag = [NSString stringWithFormat:@"%i", tempaa];
                    
                    NSArray *svReturned = [returnedDict objectForKey:@"svclist"];
           //     NSLog(@"pp-pp-pp--%@--", [svReturned[1] objectForKey:@"name"]);
                    if ([svReturned count] > 0) {
                        [self.services addObjectsFromArray:svReturned];
                        [self.tableView reloadData];
                        NSInteger tempNo = [svReturned count];
                        self.lastRowShowNo = [self.tableView numberOfRowsInSection:0] - tempNo;
                        if (self.lastRowShowNo >= 0) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.lastRowShowNo inSection:0];
                            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
                    }
                  //  NSString *qqq = self.moreload ? @"Yes" : @"No";
                  //  NSLog(@"xx98-pp-xx--%@--xx787xx--%d", qqq, tempaa);
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

- (IBAction)returnToFindService:(UIStoryboardSegue *)segue {
    
}

- (void)likeService:(ServiceFindTableViewCell *)cellView {
    NSIndexPath *selectedRow = [self.tableView indexPathForRowAtPoint:cellView.center];
    ServiceFindTableViewCell *cell = (ServiceFindTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedRow];
    cell.heart.image = [UIImage imageNamed:@"Heart"];
    
    NSDictionary *likeAdd;
    if (self.shouldShowSearchResults) {
        likeAdd = [self.searchedServices objectAtIndex:selectedRow.row];
    } else {
        likeAdd = [self.services objectAtIndex:selectedRow.row];
    }
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"MyServiceEntity" inManagedObjectContext:self.managedObjectContext];
    
    [object setValue:[likeAdd objectForKey:@"email"] forKey:@"email"];
    [object setValue:[likeAdd objectForKey:@"name"] forKey:@"name"];
    [object setValue:[likeAdd objectForKey:@"distance"] forKey:@"distance"];
    [object setValue:self.serviceCat forKey:@"cat"];
  //  [object setValue:[likeAdd objectForKey:@"rating"] forKey:@"rating"];
  //  [object setValue:[likeAdd objectForKey:@"reviewNo"] forKey:@"noOfReview"];
    [object setValue:[likeAdd objectForKey:@"detail"] forKey:@"detail"];
    [self.appDelegate saveContext];
  //   NSLog(@"This a July 11.");
    cell.heart.userInteractionEnabled = NO;
}

- (void)likeServiceNoReview:(SvcFindNoReviewTableViewCell *)cellView {
    NSIndexPath *selectedRow = [self.tableView indexPathForRowAtPoint:cellView.center];
    SvcFindNoReviewTableViewCell *cell = (SvcFindNoReviewTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedRow];
    cell.heart.image = [UIImage imageNamed:@"Heart"];
    
    NSDictionary *likeAdd;
    if (self.shouldShowSearchResults) {
        likeAdd = [self.searchedServices objectAtIndex:selectedRow.row];
    } else {
        likeAdd = [self.services objectAtIndex:selectedRow.row];
    }
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"MyServiceEntity" inManagedObjectContext:self.managedObjectContext];
    
    [object setValue:[likeAdd objectForKey:@"email"] forKey:@"email"];
    [object setValue:[likeAdd objectForKey:@"name"] forKey:@"name"];
    [object setValue:[likeAdd objectForKey:@"distance"] forKey:@"distance"];
    [object setValue:self.serviceCat forKey:@"cat"];
    //  [object setValue:[likeAdd objectForKey:@"rating"] forKey:@"rating"];
    //  [object setValue:[likeAdd objectForKey:@"reviewNo"] forKey:@"noOfReview"];
    [object setValue:[likeAdd objectForKey:@"detail"] forKey:@"detail"];
    [self.appDelegate saveContext];
    //   NSLog(@"This a July 11.");
    cell.heart.userInteractionEnabled = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows in section
    if (self.shouldShowSearchResults) {
        return [self.searchedServices count];
    } else {
        return [self.services count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shouldShowSearchResults) {
        NSDictionary *searched = [self.searchedServices objectAtIndex:indexPath.row];
        if ([[searched objectForKey:@"hasReview"] boolValue]) {
            ServiceFindTableViewCell *cell = (ServiceFindTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"serviceItemFind" forIndexPath:indexPath];
            NSString *emailH = [searched objectForKey:@"email"];
            for (NSDictionary *tempDic in self.myServiceEmails) {
                NSString *emailS = [tempDic objectForKey:@"email"];
                if ([emailS isEqualToString:emailH]) {
                    cell.heart.image = [UIImage imageNamed:@"Heart"];
                    cell.heart.userInteractionEnabled = NO;
                }
            }
            if ([[searched objectForKey:@"name"] isStringEmpty] || [searched objectForKey:@"name"] == nil) {
                cell.serviceName.text = self.serviceCat;
            } else {
                cell.serviceName.text = [searched objectForKey:@"name"];
            }
            cell.distance.text = [searched objectForKey:@"distance"];
            cell.rating.text = [NSString stringWithFormat:@"%@ (%@ reviews)", [searched objectForKey:@"rating"], [searched objectForKey:@"reviewNo"]];
            cell.detail.text = [searched objectForKey:@"detail"];
            
            NSArray *starList = @[cell.star1, cell.star2, cell.star3, cell.star4, cell.star5];
            for (int i = 0; i < 5; i++) {
                UIImageView *temp = [starList objectAtIndex:i];
                temp.image = [UIImage imageNamed:@"StarGrey"];
            }
            float aa = [[searched objectForKey:@"rating"] floatValue];
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
            SvcFindNoReviewTableViewCell *cell = (SvcFindNoReviewTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"svcItemFindNoReview" forIndexPath:indexPath];
            NSString *emailH = [searched objectForKey:@"email"];
            for (NSDictionary *tempDic in self.myServiceEmails) {
                NSString *emailS = [tempDic objectForKey:@"email"];
                if ([emailS isEqualToString:emailH]) {
                    cell.heart.image = [UIImage imageNamed:@"Heart"];
                    cell.heart.userInteractionEnabled = NO;
                }
            }
            if ([[searched objectForKey:@"name"] isStringEmpty] || [searched objectForKey:@"name"] == nil) {
                cell.name.text = self.serviceCat;
            } else {
                cell.name.text = [searched objectForKey:@"name"];
            }
            cell.distance.text = [searched objectForKey:@"distance"];
            cell.detail.text = [searched objectForKey:@"detail"];
            cell.delegate = self;
            return cell;
        }
    } else {
        NSDictionary *svcItem = [self.services objectAtIndex:indexPath.row];
        if ([[svcItem objectForKey:@"hasReview"] boolValue]) {
            ServiceFindTableViewCell *cell = (ServiceFindTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"serviceItemFind" forIndexPath:indexPath];
            NSString *emailH = [svcItem objectForKey:@"email"];
            for (NSDictionary *tempDic in self.myServiceEmails) {
                NSString *emailS = [tempDic objectForKey:@"email"];
                if ([emailS isEqualToString:emailH]) {
                    cell.heart.image = [UIImage imageNamed:@"Heart"];
                    cell.heart.userInteractionEnabled = NO;
                }
            }
            if ([[svcItem objectForKey:@"name"] isStringEmpty] || [svcItem objectForKey:@"name"] == nil) {
                cell.serviceName.text = self.serviceCat;
            } else {
                cell.serviceName.text = [svcItem objectForKey:@"name"];
            }
            cell.distance.text = [svcItem objectForKey:@"distance"];
            cell.rating.text = [NSString stringWithFormat:@"%@ (%@ reviews)", [svcItem objectForKey:@"rating"], [svcItem objectForKey:@"reviewNo"]];
            
            NSArray *starList = @[cell.star1, cell.star2, cell.star3, cell.star4, cell.star5];
            
            for (int i = 0; i < 5; i++) {
                UIImageView *temp = [starList objectAtIndex:i];
                temp.image = [UIImage imageNamed:@"StarGrey"];
            }
            
            float aa = [[svcItem objectForKey:@"rating"] floatValue];
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
            
            cell.detail.text = [svcItem objectForKey:@"detail"];
            cell.delegate = self;
            return cell;
        } else {
            SvcFindNoReviewTableViewCell *cell = (SvcFindNoReviewTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"svcItemFindNoReview" forIndexPath:indexPath];
            NSString *emailH = [svcItem objectForKey:@"email"];
            for (NSDictionary *tempDic in self.myServiceEmails) {
                NSString *emailS = [tempDic objectForKey:@"email"];
                if ([emailS isEqualToString:emailH]) {
                    cell.heart.image = [UIImage imageNamed:@"Heart"];
                    cell.heart.userInteractionEnabled = NO;
                }
            }
            if ([[svcItem objectForKey:@"name"] isStringEmpty] || [svcItem objectForKey:@"name"] == nil) {
                cell.name.text = self.serviceCat;
            } else {
                cell.name.text = [svcItem objectForKey:@"name"];
            }
            cell.distance.text = [svcItem objectForKey:@"distance"];
            cell.detail.text = [svcItem objectForKey:@"detail"];
            cell.delegate = self;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.shouldShowSearchResults) {
        if (self.moreload) {
            NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:0] - 1;
            if (indexPath.row == lastRowIndex) {
                [self loadMore:self.loadingLastTag numberOfLoading:@"20"];
            }
        }
    }
}

#pragma search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *searchStr = searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(detail contains[c] %@) OR (name contains[c] %@) OR (distance contains[c] %@)", searchStr, searchStr, searchStr];
  //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchStr];
    self.searchedServices = [NSMutableArray arrayWithArray:[self.services filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = YES;
    [self.searchedServices removeAllObjects];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.text = @"";
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = NO;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!self.shouldShowSearchResults) {
        self.shouldShowSearchResults = YES;
        [self.tableView reloadData];
    } else {
/*
        NSString *searchStr = self.searchBar.text;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchStr];
        self.searchedServices = [NSMutableArray arrayWithArray:[self.services filteredArrayUsingPredicate:predicate]];
*/
        self.searchBar.showsCancelButton = NO;
        self.searchBar.text = @"";

    //    [self.tableView reloadData];
    }
    [self.searchBar resignFirstResponder];
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
    
    if ([[segue identifier] isEqualToString:@"findToServiceDetail"] || [[segue identifier] isEqualToString:@"findNoReviewToDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        self.lastRowShowNo = indexPath.row;
        
        //     NSManagedObject *object = [self.jobLists objectAtIndex:indexPath.row];
        UINavigationController *nv = [segue destinationViewController];
        ServiceDetailTableViewController *mm = (ServiceDetailTableViewController *)[nv topViewController];
        
        mm.situationCode = 0;
        mm.serviceCatStr = self.serviceCat;
        
        if (self.shouldShowSearchResults) {
            mm.serviceFindDict = [self.searchedServices objectAtIndex:indexPath.row];
        } else {
            mm.serviceFindDict = [self.services objectAtIndex:indexPath.row];
        }

        /*
         mm.titleStr = [object valueForKey:@"jobTitle"];
         mm.statusStr = [object valueForKey:@"jobStatus"];
         mm.timeToFinishStr = [object valueForKey:@"timeToFinish"];
         mm.detailStr = [object valueForKey:@"jobDetail"];
         mm.timeCreatedStr = [object valueForKey:@"timeCreated"];
         //  mm.hidesBottomBarWhenPushed = YES;
         */
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (IBAction)cancelAct:(id)sender {
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    [self performSegueWithIdentifier:@"FindToMyService" sender:self];
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
