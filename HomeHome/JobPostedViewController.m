//
//  JobPostedViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-18.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "JobPostedViewController.h"
#import "SWRevealViewController.h"
#import "PostedJobTableViewCell.h"
#import "MerchantCatTableViewController.h"
#import "AppConstants.h"
#import "MJobDetailTableViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"

@interface JobPostedViewController ()

@property (strong, nonatomic) NSMutableArray *jobsList;

- (void)loadMore:(NSString *)loadingLast numberOfLoading:(NSString *)numberOfLoad;

@property NSString *loadingLastTag;
@property BOOL moreload;
@property NSInteger lastRowShowNo;

@property (strong, nonatomic) NSString *jobShowCat;

@end

@implementation JobPostedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.catViewContainer.layer.borderWidth = 1;
    self.catViewContainer.layer.borderColor = [[UIColor grayColor] CGColor];
    self.catViewContainer.layer.cornerRadius = 10;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newChosedCatShow:) name:@"notificationCatChosed" object:nil];
    
    UITapGestureRecognizer *chooseCat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseIt:)];
    [self.catViewContainer addGestureRecognizer:chooseCat];
    self.catViewContainer.userInteractionEnabled = YES;
    
    NSString *tempCat = [[NSUserDefaults standardUserDefaults] objectForKey:merchantField];
    
    if (tempCat == nil || [tempCat isStringEmpty]) {
        NSString *expertise = [[NSUserDefaults standardUserDefaults] objectForKey:myExpertise];
        if (expertise == nil || [expertise isStringEmpty]) {
            self.jobShowCat = @"All";
        } else {
            NSArray *tempArr = [expertise componentsSeparatedByString:@",\n"];
            self.jobShowCat = [tempArr objectAtIndex:0];
        }
    } else {
        self.jobShowCat = tempCat;
    }
    self.serviceCatL.text = self.jobShowCat;
    
    self.loadingLastTag = @"0";
    self.moreload = NO;
    self.lastRowShowNo = 0;
    self.jobsList = [[NSMutableArray alloc] init];
    
    [self loadMore:self.loadingLastTag numberOfLoading:@"20"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnJobPosted:(UIStoryboardSegue *)segue {
    
}

- (IBAction)refreshAct:(id)sender {
    self.moreload = NO;
    self.lastRowShowNo = 0;
    
    self.loadingLastTag = @"0";
    
    [self.jobsList removeAllObjects];
    [self.tableView reloadData];
    [self loadMore:self.loadingLastTag numberOfLoading:@"20"];
}

#pragma notification functions

- (void)newChosedCatShow:(NSNotification *) note {
    // NSString *key = @"keyStr";
    //  self.titleString = [[note userInfo] objectForKey:key];
    self.jobShowCat = [[NSUserDefaults standardUserDefaults] objectForKey:merchantField];
    self.serviceCatL.text = self.jobShowCat;
    
    self.moreload = NO;
    self.lastRowShowNo = 0;
    self.loadingLastTag = @"0";
    
    [self.jobsList removeAllObjects];
    [self.tableView reloadData];
    [self loadMore:self.loadingLastTag numberOfLoading:@"20"];
}

- (void)chooseIt:(UITapGestureRecognizer *)tapGestureRecognizer {
  //  NSLog(@"12345TT- 99 --");
    MerchantCatTableViewController *controller = (MerchantCatTableViewController *)[[UIStoryboard storyboardWithName:@"Merchant" bundle:nil] instantiateViewControllerWithIdentifier:@"MerchantCatSB"];
/*
    NSString *tagStr = [NSString stringWithFormat:@"%ld", (long)tapGestureRecognizer.view.tag];
    //    NSLog(@"uuuuuuuuTTT---%@", tagStr);
    controller.viewTag = tagStr;
*/
    controller.chosedCat = self.jobShowCat;
    if ([self respondsToSelector:@selector(showViewController:sender:)]) {
        [self showViewController:controller sender:self];
    } else {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)loadMore:(NSString *)loadingLast numberOfLoading:(NSString *)numberOfLoad {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading Posted Jobs...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"merchant/jobsload"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", loadingLast, @"loadednumber", numberOfLoad, @"numberofLoad", self.jobShowCat, @"jobcat", nil];
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
                    int tempaa = [[returnedDict objectForKey:@"loadedjobs"] intValue];
                    self.loadingLastTag = [NSString stringWithFormat:@"%i", tempaa];
                    
                    NSArray *jobsReturned = [returnedDict objectForKey:@"list"];
                    //     NSLog(@"pp-pp-pp--%@--", [svReturned[1] objectForKey:@"name"]);
                    if ([jobsReturned count] > 0) {
                        [self.jobsList addObjectsFromArray:jobsReturned];
                        [self.tableView reloadData];
                        NSInteger tempNo = [jobsReturned count];
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

/*
- (void)downLoadJobs {
    NSDictionary *job1 = [NSDictionary dictionaryWithObjectsAndKeys:@"yy@tt.ca", @"email", @"Robert Lee", @"name", @"4.8 miles", @"distance", @"2016/07/20 10:00", @"timePosted", @"2016/07/28 16:00", @"timeFinish", @"Duct Cleaning", @"jobTitle", @"Here in the world, this is plumbing 1 --- repair the pipe in bashroom hjsgsaj jhasgjsa jhsg jsa sagjg saydybhsd usyduy.", @"detail", nil];
}
*/

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
    return [self.jobsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostedJobTableViewCell *cell = (PostedJobTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"postedJobItem" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[PostedJobTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postedJobItem"];
        // cell = [[SevenMsgTableViewCell alloc] initWithFrame:CGRectZero];
    }
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
 //   cell.delegate = self;
    return cell;
}

- (void)configureCell:(PostedJobTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //   float widthOfTableView = self.view.frame.size.width - 65;
    NSDictionary *item = [self.jobsList objectAtIndex:indexPath.row];
    cell.name.text = [item objectForKey:@"name"];
    cell.distance.text = [item objectForKey:@"distance"];
    // here should be job title, not job detail, because in list
    cell.detail.text = [item objectForKey:@"jobTitle"];
    cell.timeFinish.text = [item objectForKey:@"timeFinish"];
        
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.moreload) {
        NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:0] - 1;
        if (indexPath.row == lastRowIndex) {
            [self loadMore:self.loadingLastTag numberOfLoading:@"20"];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"MtoJobDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = [self.jobsList objectAtIndex:indexPath.row];
    //    UINavigationController *nv = [segue destinationViewController];
        MJobDetailTableViewController *mm = (MJobDetailTableViewController *)[segue destinationViewController];
        
        mm.situationCode = 0;
        mm.jobItem = object;
        //  mm.hidesBottomBarWhenPushed = YES;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
