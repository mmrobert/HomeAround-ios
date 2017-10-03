//
//  PromotionTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-15.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "PromotionTableViewController.h"
#import "SWRevealViewController.h"
#import "ItemPromoTableViewCell.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "AppDelegate.h"

@interface PromotionTableViewController ()

@property (strong, nonatomic) NSMutableArray *promotionList;

@property (strong, nonatomic) NSString *lastTag;
@property BOOL moreload;
@property NSInteger lastSectionShowNo;

@end

@implementation PromotionTableViewController

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
    
    self.promotionList = [[NSMutableArray alloc] init];

  //  UIImage *hereImg = [UIImage imageNamed:@"User"];
  //  NSData *imgData = UIImageJPEGRepresentation(hereImg, 1.0);
  //  NSString *imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
  //  [self.promotionList addObject:imgStr];
    
    self.moreload = NO;
    self.lastSectionShowNo = 0;
    
    self.lastTag = @"0";
    
    [self loadMore:self.lastTag numberOfLoading:@"20"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// return the number of sections
    if ([self.promotionList count] < 1) {
        return 1;
    } else {
        return [self.promotionList count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.promotionList count] < 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noPromotion" forIndexPath:indexPath];
        return cell;
    } else {
        ItemPromoTableViewCell *cell = (ItemPromoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"promotionImg" forIndexPath:indexPath];
        // Configure the cell...
        NSString *imgStr = [self.promotionList objectAtIndex:indexPath.section];
        NSData *imgData = [[NSData alloc] initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        cell.promoImg.image = [UIImage imageWithData:imgData];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.moreload) {
        NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
        if (indexPath.section == lastSectionIndex) {
            [self loadMore:self.lastTag numberOfLoading:@"20"];
        }
    }
}

- (void)loadMore:(NSString *)loadingLast numberOfLoading:(NSString *)numberOfLoad {
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading Promotions...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/promotionload"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", loadingLast, @"loadednumber", numberOfLoad, @"numberofLoad", nil];
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
                    self.moreload = [[returnedDict objectForKey:@"morepromotion"] boolValue];
                    int tempaa = [[returnedDict objectForKey:@"loadedpromo"] intValue];
                    self.lastTag = [NSString stringWithFormat:@"%i", tempaa];
                    
                    NSArray *pReturned = [returnedDict objectForKey:@"list"];
                //        NSLog(@"p3-p3-p3--%lu", (unsigned long)[pReturned count]);
                    if ([pReturned count] > 0) {
                        [self.promotionList addObjectsFromArray:pReturned];
                        [self.tableView reloadData];
                        NSInteger tempNo = [pReturned count];
                        self.lastSectionShowNo = [self.tableView numberOfSections] - tempNo;
                        if (self.lastSectionShowNo >= 0) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.lastSectionShowNo];
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
