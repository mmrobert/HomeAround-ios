//
//  ServiceDetailTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-05.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ServiceDetailTableViewController.h"
#import "ServiceReviewTableViewCell.h"
#import "SendMsgViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "ComposeReviewViewController.h"

@interface ServiceDetailTableViewController ()

@property (strong, nonatomic) NSArray *matchSvc;

@property BOOL hasReview;
@property (strong, nonatomic) NSString *overallRate;
@property (strong, nonatomic) NSString *noOfReview;

@property (strong, nonatomic) NSArray *reviewList;

@end

@implementation ServiceDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.matchSvc = [[NSArray alloc] init];
    
    self.hasReview = [[self.serviceFindDict objectForKey:@"hasReview"] boolValue];
  //  self.hasReview = YES;
    self.overallRate = [self.serviceFindDict objectForKey:@"rating"];
    self.noOfReview = [self.serviceFindDict objectForKey:@"reviewNo"];
//reviewItem={@"4.5", @"rating", @"R", @"name", @"2016/07", @"time", @"H", @"content", nil};
    self.reviewList = [[NSArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newReviewShow:) name:@"notificationReviewPost" object:nil];
    
    if (self.hasReview) {
        [self loadReviews];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.situationCode == 0) {
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyServiceEntity" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Set the batch size to a suitable number.
        // [fetchRequest setFetchBatchSize:50];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [self.serviceFindDict objectForKey:@"email"]];
        [fetchRequest setPredicate:predicate];
        
        self.matchSvc = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [self.tableView reloadData];
    }
}

#pragma notification functions

- (void)newReviewShow:(NSNotification *) note {
   // NSString *key = @"keyStr";
  //  self.titleString = [[note userInfo] objectForKey:key];
    [self loadReviews];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

- (void)loadReviews {
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading reviews...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/reviewload"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSString *tempMail = [self.serviceFindDict objectForKey:@"email"];
    
 //   NSLog(@"xx-pp-xx----xx787xx--%@", tempMail);
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", tempMail, @"emailreview", nil];
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
                    
                    self.reviewList = [returnedDict objectForKey:@"reviewlist"];
                 //   NSArray *tempA = [returnedDict objectForKey:@"reviewlist"];
                //    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
                    
                //    self.reviewList = [tempA sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
                    self.hasReview = [[returnedDict objectForKey:@"hasReview"] boolValue];
                    //  self.hasReview = YES;
                    self.overallRate = [returnedDict objectForKey:@"ratings"];
                    self.noOfReview = [returnedDict objectForKey:@"reviewNo"];
                    [self.tableView reloadData];
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

- (void)likeTheService:(ServiceDescriptionTableViewCell *)cellView {
    NSIndexPath *selectedRow = [self.tableView indexPathForRowAtPoint:cellView.center];
    ServiceDescriptionTableViewCell *cell = (ServiceDescriptionTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedRow];
    cell.ratingStar.image = [UIImage imageNamed:@"Heart"];

    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"MyServiceEntity" inManagedObjectContext:self.managedObjectContext];
    
    [object setValue:[self.serviceFindDict objectForKey:@"email"] forKey:@"email"];
    [object setValue:[self.serviceFindDict objectForKey:@"name"] forKey:@"name"];
    [object setValue:[self.serviceFindDict objectForKey:@"distance"] forKey:@"distance"];
   // [object setValue:[self.serviceFindDict objectForKey:@"rating"] forKey:@"rating"];
   // [object setValue:[self.serviceFindDict objectForKey:@"reviewNo"] forKey:@"noOfReview"];
    [object setValue:[self.serviceFindDict objectForKey:@"detail"] forKey:@"detail"];
    [object setValue:self.serviceCatStr forKey:@"cat"];
    [self.appDelegate saveContext];
    //   NSLog(@"This a July 11.");
    cell.ratingStar.userInteractionEnabled = NO;
}

- (void)likeTheServiceNoReview:(NoReviewDesTableViewCell *)cellView {
    NSIndexPath *selectedRow = [self.tableView indexPathForRowAtPoint:cellView.center];
    NoReviewDesTableViewCell *cell = (NoReviewDesTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedRow];
  //  cellView.heart.image = [UIImage imageNamed:@"Heart"];
    cell.heart.image = [UIImage imageNamed:@"Heart"];
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"MyServiceEntity" inManagedObjectContext:self.managedObjectContext];
    
    [object setValue:[self.serviceFindDict objectForKey:@"email"] forKey:@"email"];
    [object setValue:[self.serviceFindDict objectForKey:@"name"] forKey:@"name"];
    [object setValue:[self.serviceFindDict objectForKey:@"distance"] forKey:@"distance"];
    // [object setValue:[self.serviceFindDict objectForKey:@"rating"] forKey:@"rating"];
    // [object setValue:[self.serviceFindDict objectForKey:@"reviewNo"] forKey:@"noOfReview"];
    [object setValue:[self.serviceFindDict objectForKey:@"detail"] forKey:@"detail"];
    [object setValue:self.serviceCatStr forKey:@"cat"];
    [self.appDelegate saveContext];
    //   NSLog(@"This a July 11.");
    cell.heart.userInteractionEnabled = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return the number of rows
    if (self.hasReview) {
        return [self.reviewList count] + 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasReview) {
        if (indexPath.row == 0) {
            ServiceDescriptionTableViewCell *cell = (ServiceDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"serviceDescription" forIndexPath:indexPath];
            
            if ([[self.serviceFindDict objectForKey:@"name"] isStringEmpty] || [self.serviceFindDict objectForKey:@"name"] == nil) {
                cell.serviceName.text = self.serviceCatStr;
            } else {
                cell.serviceName.text = [self.serviceFindDict objectForKey:@"name"];
            }
            cell.distance.text = [self.serviceFindDict objectForKey:@"distance"];
            cell.reviewSum.text = [NSString stringWithFormat:@"%@ (%@ reviews)", self.overallRate, self.noOfReview];
            
            NSArray *starList = @[cell.star1, cell.star2, cell.star3, cell.star4, cell.star5];
            for (int i = 0; i < 5; i++) {
                UIImageView *temp = [starList objectAtIndex:i];
                temp.image = [UIImage imageNamed:@"StarGrey"];
            }
            float aa = [self.overallRate floatValue];
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
            cell.serviceDes.text = [self.serviceFindDict objectForKey:@"detail"];
            
            if (self.situationCode == 0) {
                if ([self.matchSvc count] > 0) {
                    cell.ratingStar.image = [UIImage imageNamed:@"Heart"];
                    cell.ratingStar.userInteractionEnabled = NO;
                }
            } else {
                cell.ratingStar.image = [UIImage imageNamed:@"Heart"];
                cell.ratingStar.userInteractionEnabled = NO;
            }
            cell.delegate = self;
            return cell;
        } else {
            ServiceReviewTableViewCell *cell = (ServiceReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"serviceReview" forIndexPath:indexPath];
            NSDictionary *item = [self.reviewList objectAtIndex:(indexPath.row - 1)];
            cell.reviewTime.text = [item objectForKey:@"time"];
            cell.reviewER.text = [item objectForKey:@"name"];
            cell.reviewContent.text = [item objectForKey:@"content"];
            
            NSArray *starList = @[cell.star1, cell.star2, cell.star3, cell.star4, cell.star5];
            for (int i = 0; i < 5; i++) {
                UIImageView *temp = [starList objectAtIndex:i];
                temp.image = [UIImage imageNamed:@"StarGrey"];
            }
            
            float aa = [[item objectForKey:@"rating"] floatValue];
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

            return cell;
        }
    } else {
        NoReviewDesTableViewCell *cell = (NoReviewDesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"serviceDesNoReview" forIndexPath:indexPath];
        if ([[self.serviceFindDict objectForKey:@"name"] isStringEmpty] || [self.serviceFindDict objectForKey:@"name"] == nil) {
            cell.name.text = self.serviceCatStr;
        } else {
            cell.name.text = [self.serviceFindDict objectForKey:@"name"];
        }
        cell.distance.text = [self.serviceFindDict objectForKey:@"distance"];
        cell.content.text = [self.serviceFindDict objectForKey:@"detail"];
        
        if (self.situationCode == 0) {
          //  cell.name.text = [self.serviceFindDict objectForKey:@"name"];
            if ([self.matchSvc count] > 0) {
                cell.heart.image = [UIImage imageNamed:@"Heart"];
                cell.heart.userInteractionEnabled = NO;
            }
        } else {
         //   cell.name.text = [self.serviceFindDict objectForKey:@"name"];
            cell.heart.image = [UIImage imageNamed:@"Heart"];
            cell.heart.userInteractionEnabled = NO;
        }
        cell.delegate = self;
        return cell;
    }
    // Configure the cell...
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
    if ([[segue identifier] isEqualToString:@"SendMsgSegue"] || [[segue identifier] isEqualToString:@"sendMsgNoReview"]) {
        SendMsgViewController *mm = (SendMsgViewController *)[segue destinationViewController];
        
        mm.serviceDict = self.serviceFindDict;
    }
    if ([[segue identifier] isEqualToString:@"composeReview1"]) {
        ComposeReviewViewController *kkp = (ComposeReviewViewController *)[segue destinationViewController];
        kkp.emailForReview = [self.serviceFindDict objectForKey:@"email"];
    }

}

- (IBAction)cancelAct:(id)sender {
    if (self.situationCode == 0) {
        [self performSegueWithIdentifier:@"serviceDetailToFindService" sender:self];
    } else {
        [self performSegueWithIdentifier:@"serviceDetailToMyService" sender:self];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
