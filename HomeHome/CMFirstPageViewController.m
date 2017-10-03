//
//  CMFirstPageViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-26.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CMFirstPageViewController.h"
#import "SWRevealViewController.h"
#import "JobItemTableViewCell.h"
#import "ModifyJobTableViewController.h"
#import "NSString+EmptyCheck.h"

@interface CMFirstPageViewController ()

@property NSArray *jobLists;

@end

@implementation CMFirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarButton setTarget:self.revealViewController];
        [self.sideBarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyJobEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:50];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeCreated" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    self.jobLists = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    [self.tableView reloadData];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

- (IBAction)returnToJobList:(UIStoryboardSegue *)segue {
    
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
    return [self.jobLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobItemTableViewCell *cell = (JobItemTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"jobItem" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[JobItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jobItem"];
        // cell = [[SevenMsgTableViewCell alloc] initWithFrame:CGRectZero];
    }
    // Configure the cell...
    NSManagedObject *item = [self.jobLists objectAtIndex:indexPath.row];
    NSString *titleHere = [item valueForKey:@"jobTitle"];
    if (titleHere == nil || [titleHere isStringEmpty]) {
        cell.titleLabel.text = [item valueForKey:@"jobCat"];
    } else {
        cell.titleLabel.text = [item valueForKey:@"jobTitle"];
    }
    
    NSString *timeCreatedStr = [item valueForKey:@"timeCreated"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *createdDate = [formatter dateFromString:timeCreatedStr];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    cell.timeLabel.text = [formatter stringFromDate:createdDate];
    cell.detailLabel.text = [item valueForKey:@"jobDetail"];
    cell.statusLabel.text = [item valueForKey:@"jobStatus"];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"JobModifySegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [self.jobLists objectAtIndex:indexPath.row];
      //  UINavigationController *nv = [segue destinationViewController];
        ModifyJobTableViewController *mm = (ModifyJobTableViewController *)[segue destinationViewController];
        
        mm.jobItem = object;
        //  mm.hidesBottomBarWhenPushed = YES;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
