//
//  MsgBoxTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-13.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MsgBoxTableViewController.h"
#import "SWRevealViewController.h"
#import "MsgBoxItemTableViewCell.h"
#import "PersonalMsgViewController.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"

@interface MsgBoxTableViewController ()

@property (strong, nonatomic) NSMutableArray *msgBoxList;
@property (strong, nonatomic) NSArray *msgDownloaded;

@end

@implementation MsgBoxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarItem setTarget:self.revealViewController];
        [self.sideBarItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
   // self.msgBoxList = [[NSMutableArray alloc] init];
    [self fetchMsgBoxList];
    self.msgDownloaded = [[NSArray alloc] init];
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
    
  //  [self fetchMsgBoxList];
    [self loadMessages];
}

- (void)loadMessages {
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Loading messages...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/messagesload"]];
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
                    //   NSString *token = [returnedDict objectForKey:@"sessionId"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    BOOL hasNewMsg = [[returnedDict objectForKey:@"hasTheReturn"] boolValue];
                    if (hasNewMsg) {
                        self.msgDownloaded = [returnedDict objectForKey:@"msglist"];
                        for (NSDictionary *dictMsg in self.msgDownloaded) {
                            NSString *msgStr = [dictMsg objectForKey:@"msg"];
                            NSString *timeStr = [dictMsg objectForKey:@"time"];
                            NSString *emailStr = [dictMsg objectForKey:@"email"];
                            NSString *nameStr = [dictMsg objectForKey:@"name"];
                            [self saveMsgCoreData:msgStr withTime:timeStr withEmail:emailStr withName:nameStr];
                        }
                        [self.appDelegate saveContext];
                        [self fetchMsgBoxList];
                        [self.tableView reloadData];
                    }
                 //   [self fetchMsgBoxList];
                    //   NSArray *tempA = [returnedDict objectForKey:@"reviewlist"];
                    //    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
                    
                    //    self.reviewList = [tempA sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
                  //  [self.tableView reloadData];
                    //  NSString *qqq = self.moreload ? @"Yes" : @"No";
                    //  NSLog(@"xx98-pp-xx--%@--xx787xx--%d", qqq, tempaa);
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                  //  NSString *alertMsg = msg;
                  //  NSString *okTitle = @"OK";
                  //  [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
                }
            }
        }
    }];
}

- (void)saveMsgCoreData:(NSString *)message withTime:(NSString *)time withEmail:(NSString *)email withName:(NSString *)name {
    NSManagedObject *msg = [NSEntityDescription insertNewObjectForEntityForName:@"MsgEntity" inManagedObjectContext:self.managedObjectContext];
    
    [msg setValue:email forKey:@"email"];
    [msg setValue:name forKey:@"name"];
    [msg setValue:@"in" forKey:@"direction"];
    [msg setValue:message forKey:@"msgBody"];
    [msg setValue:time forKey:@"msgTime"];
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MsgBoxEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", email];
    [fetchRequest setPredicate:predicate];
    NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([tempArr count] < 1) {
        NSManagedObject *newChat = [NSEntityDescription insertNewObjectForEntityForName:@"MsgBoxEntity" inManagedObjectContext:self.managedObjectContext];
        
        [newChat setValue:email forKey:@"email"];
        [newChat setValue:name forKey:@"name"];
        [newChat setValue:message forKey:@"lastMsg"];
        [newChat setValue:time forKey:@"timeLastMsg"];
    } else {
        NSManagedObject *oldChat = [tempArr objectAtIndex:0];
        [oldChat setValue:message forKey:@"lastMsg"];
        [oldChat setValue:time forKey:@"timeLastMsg"];
    }
  //  [self.appDelegate saveContext];
  //  [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchMsgBoxList {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MsgBoxEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:50];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeLastMsg" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *temp = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.msgBoxList = [NSMutableArray arrayWithArray:temp];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// return the number of rows
    return [self.msgBoxList count];
  //  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgBoxItemTableViewCell *cell = (MsgBoxItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"msgBoxItem" forIndexPath:indexPath];
    // Configure the cell...
    NSManagedObject *object = [self.msgBoxList objectAtIndex:indexPath.row];
    cell.name.text = [object valueForKey:@"name"];
    cell.timeMsg.text = [object valueForKey:@"timeLastMsg"];
    cell.lastMsg.text = [object valueForKey:@"lastMsg"];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

        NSManagedObject *temp = [self.msgBoxList objectAtIndex:indexPath.row];
        NSString *emailH = [temp valueForKey:@"email"];
        [self.managedObjectContext deleteObject:temp];
        [self.msgBoxList removeObjectAtIndex:indexPath.row];
        [self deleteMsg:emailH];
 
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.appDelegate saveContext];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deleteMsg:(NSString *)email {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MsgEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", email];
    [fetchRequest setPredicate:predicate];
    
    NSArray *temp = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in temp) {
        [self.managedObjectContext deleteObject:object];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"personalChatSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [self.msgBoxList objectAtIndex:indexPath.row];
        
        //   UINavigationController *nv = [segue destinationViewController];
        PersonalMsgViewController *mm = (PersonalMsgViewController *)[segue destinationViewController];
        
        mm.chatItem = object;
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
