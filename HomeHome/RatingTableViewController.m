//
//  RatingTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-24.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "RatingTableViewController.h"
#import "SWRevealViewController.h"
#import "RatingOverAllTableViewCell.h"
#import "RatingItemTableViewCell.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "AppDelegate.h"

@interface RatingTableViewController ()

@property BOOL hasReview;
@property (strong, nonatomic) NSString *overallRate;
@property (strong, nonatomic) NSString *noOfReview;

@property (strong, nonatomic) NSArray *reviewList;

@end

@implementation RatingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarItem setTarget:self.revealViewController];
        [self.sideBarItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.hasReview = NO;
  //  self.overallRate = @"3.6";
  //  self.noOfReview = @"18";
  //  NSDictionary *review1 = [NSDictionary dictionaryWithObjectsAndKeys:@"4.56", @"rating", @"Robert", @"name", @"2016/07/20 10:00", @"time", @"Here usyduy.", @"content", nil];
    self.reviewList = [[NSArray alloc] init];
    
  //  [self loadReviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadReviews];
    
    //  [self.tableView reloadData];
}

- (void)loadReviews {
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading reviews...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"merchant/reviewload"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    //   NSLog(@"xx-pp-xx----xx787xx--%@", tempMail);
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", nil];
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
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    self.reviewList = [returnedDict objectForKey:@"reviewlist"];
                    //   NSArray *tempA = [returnedDict objectForKey:@"reviewlist"];
                    //    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
                    
                    //    self.reviewList = [tempA sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
                    self.hasReview = [[returnedDict objectForKey:@"hasReview"] boolValue];
                   //   self.hasReview = NO;
                    self.overallRate = [returnedDict objectForKey:@"ratings"];
                    self.noOfReview = [returnedDict objectForKey:@"reviewNo"];
              //      NSLog(@"xx98-pp-loading--xx--%@", self.reviewList);
                    [self.tableView reloadData];
                    //  NSString *qqq = self.moreload ? @"Yes" : @"No";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// return the number of rows
    if (self.hasReview) {
     //   NSLog(@"xx98-IF-xx--xx--%lu", (unsigned long)[self.reviewList count] + 1);
        return [self.reviewList count] + 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasReview) {
        if (indexPath.row == 0) {
            RatingOverAllTableViewCell *cell = (RatingOverAllTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"overallCell" forIndexPath:indexPath];
            cell.overAllRate.text = self.overallRate;
            cell.reviewNo.text = [NSString stringWithFormat:@"%@ reviews", self.noOfReview];
            //  cell.delegate = self;
            
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

            return cell;
        } else {
            RatingItemTableViewCell *cell = (RatingItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"reviewItemCell" forIndexPath:indexPath];
            NSDictionary *item = [self.reviewList objectAtIndex:(indexPath.row - 1)];
    //     NSLog(@"xx98-cell-xx--HH--%@", [item objectForKey:@"rating"]);
            float tempFF =[[item objectForKey:@"rating"] floatValue];
            cell.rating.text = [NSString stringWithFormat:@"%1.2f", tempFF];
            cell.time.text = [item objectForKey:@"time"];
     //   NSLog(@"xx98-cell-xx--HH--%@", [item objectForKey:@"time"]);
            cell.name.text = [item objectForKey:@"name"];
            cell.content.text = [item objectForKey:@"content"];
        // NSLog(@"xx98-cell-xx--xx--Ha");
            NSArray *starList = @[cell.star1, cell.star2, cell.star3, cell.star4, cell.star5];
            
            for (int i = 0; i < 5; i++) {
                UIImageView *temp = [starList objectAtIndex:i];
                temp.image = [UIImage imageNamed:@"StarGrey"];
            }
            
            float aa = [[item objectForKey:@"rating"] floatValue];
            int aaInt = (int)floorf(aa);
            float aaDecimal = aa - floorf(aa);
     //   NSLog(@"xx98-cell-xx--xx--%f", aa);
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noReviewCell" forIndexPath:indexPath];
        //  cell.delegate = self;
        return cell;
    }
    // Configure the cell...
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

- (IBAction)refreshAct:(id)sender {
    [self loadReviews];
}

@end
