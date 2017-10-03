//
//  MerJobsViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-21.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MerJobsViewController.h"
#import "SWRevealViewController.h"
#import "MerJobsTableViewCell.h"
#import "MJobDetailTableViewController.h"
#import "NSString+EmptyCheck.h"

@interface MerJobsViewController ()

@property (strong, nonatomic) NSArray *contactingJobs;
@property (strong, nonatomic) NSArray *activeJobs;
@property (strong, nonatomic) NSArray *closedJobs;

@end

@implementation MerJobsViewController

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
    
    self.contactingJobs = [[NSArray alloc] init];
    self.activeJobs = [[NSArray alloc] init];
    self.closedJobs = [[NSArray alloc] init];
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

- (IBAction)returnMerJobs:(UIStoryboardSegue *)segue {
    
}

- (IBAction)segmentChangedAct:(id)sender {
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchJobs];
    
    [self.tableView reloadData];
}

- (void)fetchJobs {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MerJobEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:50];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jobStatus == %@", @"contacting"];
    [fetchRequest setPredicate:predicate];
    
    self.contactingJobs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    predicate = [NSPredicate predicateWithFormat:@"jobStatus == %@", @"active"];
    [fetchRequest setPredicate:predicate];
    
    self.activeJobs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    predicate = [NSPredicate predicateWithFormat:@"jobStatus == %@", @"closed"];
    [fetchRequest setPredicate:predicate];
    
    self.closedJobs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
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
    NSInteger noOfRows;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            noOfRows = [self.contactingJobs count];
            break;
        case 1:
            noOfRows = [self.activeJobs count];
            break;
        case 2:
            noOfRows = [self.closedJobs count];
            break;
            
        default:
            break;
    }
    
    return noOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MerJobsTableViewCell *cell = (MerJobsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"MmyJobCell" forIndexPath:indexPath];
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
  //  cell.delegate = self;
    return cell;
}

- (void)configureCell:(MerJobsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //   float widthOfTableView = self.view.frame.size.width - 65;
    NSManagedObject *item;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            item = [self.contactingJobs objectAtIndex:indexPath.row];
            cell.jobTitle.text = [item valueForKey:@"jobTitle"];
            cell.distance.text = [item valueForKey:@"distance"];
            cell.name.text = [item valueForKey:@"name"];
            cell.time.text = [item valueForKey:@"timeFinish"];
            break;
        case 1:
            item = [self.activeJobs objectAtIndex:indexPath.row];
            cell.jobTitle.text = [item valueForKey:@"jobTitle"];
            cell.distance.text = [item valueForKey:@"distance"];
            cell.name.text = [item valueForKey:@"name"];
            cell.time.text = [item valueForKey:@"timeFinish"];
            break;
        case 2:
            item = [self.closedJobs objectAtIndex:indexPath.row];
            cell.jobTitle.text = [item valueForKey:@"jobTitle"];
            cell.distance.text = [item valueForKey:@"distance"];
            cell.name.text = [item valueForKey:@"name"];
            cell.time.text = [item valueForKey:@"timeFinish"];
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"MerToJobDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSManagedObject *item;
        NSDictionary *object;
        NSString *jobStatusStr;
//
        NSString *email;
        NSString *name;
        NSString *distance;
        NSString *timePosted;
        NSString *timeFinish;
        NSString *jobTitle;
        NSString *detail;
//
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 0:
                item = [self.contactingJobs objectAtIndex:indexPath.row];

                email = [item valueForKey:@"email"];
                name = [item valueForKey:@"name"];
                distance = [item valueForKey:@"distance"];
                timePosted = [item valueForKey:@"timePosted"];
                timeFinish = [item valueForKey:@"timeFinish"];
                jobTitle = [item valueForKey:@"jobTitle"];
                detail = [item valueForKey:@"jobDetail"];
                
                if (name == nil || [name isStringEmpty]) {
                    name = @"";
                }
                if (distance == nil || [distance isStringEmpty]) {
                    distance = @"";
                }
                if (timeFinish == nil || [timeFinish isStringEmpty]) {
                    timeFinish = @"";
                }
                if (jobTitle == nil || [jobTitle isStringEmpty]) {
                    jobTitle = @"";
                }
                if (detail == nil || [detail isStringEmpty]) {
                    detail = @"";
                }
                
                object = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", name, @"name", distance, @"distance", timePosted, @"timePosted", timeFinish, @"timeFinish", jobTitle, @"jobTitle", detail, @"detail", nil];
                jobStatusStr = [item valueForKey:@"jobStatus"];
 
                break;
            case 1:
                item = [self.activeJobs objectAtIndex:indexPath.row];
                
                email = [item valueForKey:@"email"];
                name = [item valueForKey:@"name"];
                distance = [item valueForKey:@"distance"];
                timePosted = [item valueForKey:@"timePosted"];
                timeFinish = [item valueForKey:@"timeFinish"];
                jobTitle = [item valueForKey:@"jobTitle"];
                detail = [item valueForKey:@"jobDetail"];
                
                if (name == nil || [name isStringEmpty]) {
                    name = @"";
                }
                if (distance == nil || [distance isStringEmpty]) {
                    distance = @"";
                }
                if (timeFinish == nil || [timeFinish isStringEmpty]) {
                    timeFinish = @"";
                }
                if (jobTitle == nil || [jobTitle isStringEmpty]) {
                    jobTitle = @"";
                }
                if (detail == nil || [detail isStringEmpty]) {
                    detail = @"";
                }

                object = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", name, @"name", distance, @"distance", timePosted, @"timePosted", timeFinish, @"timeFinish", jobTitle, @"jobTitle", detail, @"detail", nil];
                jobStatusStr = [item valueForKey:@"jobStatus"];
                
                break;
            case 2:
                item = [self.closedJobs objectAtIndex:indexPath.row];
                
                email = [item valueForKey:@"email"];
                name = [item valueForKey:@"name"];
                distance = [item valueForKey:@"distance"];
                timePosted = [item valueForKey:@"timePosted"];
                timeFinish = [item valueForKey:@"timeFinish"];
                jobTitle = [item valueForKey:@"jobTitle"];
                detail = [item valueForKey:@"jobDetail"];
                
                if (name == nil || [name isStringEmpty]) {
                    name = @"";
                }
                if (distance == nil || [distance isStringEmpty]) {
                    distance = @"";
                }
                if (timeFinish == nil || [timeFinish isStringEmpty]) {
                    timeFinish = @"";
                }
                if (jobTitle == nil || [jobTitle isStringEmpty]) {
                    jobTitle = @"";
                }
                if (detail == nil || [detail isStringEmpty]) {
                    detail = @"";
                }

                object = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", name, @"name", distance, @"distance", timePosted, @"timePosted", timeFinish, @"timeFinish", jobTitle, @"jobTitle", detail, @"detail", nil];
                jobStatusStr = [item valueForKey:@"jobStatus"];
                
                break;
                
            default:
                break;
        }

     //   UINavigationController *nv = [segue destinationViewController];
        MJobDetailTableViewController *mm = (MJobDetailTableViewController *)[segue destinationViewController];
        
        mm.situationCode = 1;
        mm.jobItem = object;
        mm.jobStatusStr = jobStatusStr;
        //  mm.hidesBottomBarWhenPushed = YES;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
