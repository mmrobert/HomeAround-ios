//
//  PersonalMsgViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-13.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "PersonalMsgViewController.h"
#import "MeTableViewCell.h"
#import "OtherTableViewCell.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"
#import "NSString+EmptyCheck.h"

@interface PersonalMsgViewController ()

@end

@implementation PersonalMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
  //  [self.textView setContentInset:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)];
  //  self.title = [self.chatItem valueForKey:@"name"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSInteger noOfSections = 1;
    NSInteger lastRowNo = [self.tableView numberOfRowsInSection:noOfSections - 1] - 1;
    if (lastRowNo >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRowNo inSection:noOfSections - 1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.view endEditing:YES];
    }
}
*/

#pragma mark - coredata

@synthesize fetchedResultsController = _fetchedResultsController;


- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

#pragma mark - TextView delegate

/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        // do when return pressed
        return NO;
    }
    return YES;
}
*/

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width + 22.0;
 //   CGFloat oldHeight = textView.frame.size.height;
    [textView setFont:[UIFont systemFontOfSize:15.0]];
//    [textView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
 //   [textView layoutIfNeeded];
 //   CGRect newFrame = textView.frame;
 //   newFrame.size = CGSizeMake(fixedWidth, newSize.height);
  //  CGFloat increment = newSize.height - oldHeight;
    
    if (newSize.height > 100) {
        return;
    }
    
    // textView.frame = newFrame;
    self.textViewHeight.constant = newSize.height;
 //   [textView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
//    NSLog(@"123456789 -- %f", newSize.height);
 //   [textView layoutIfNeeded];
 //   [textView updateConstraints];
 //   textView.textContainerInset = UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0);
    
    [UIView animateWithDuration:0.1 animations:^{[self.view layoutIfNeeded];}];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // needs to translate the bounds to account for rotation
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // animation settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.bottomDistance.constant += keyboardBounds.size.height;
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    // set table view scroll to bottom

    NSInteger noOfSections = 1;
    NSInteger lastRowNo = [self.tableView numberOfRowsInSection:noOfSections - 1] - 1;
    if (lastRowNo >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRowNo inSection:noOfSections - 1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.bottomDistance.constant -= keyboardBounds.size.height;
    [self.view layoutIfNeeded];
    // set table view scroll to bottom
    
    [UIView commitAnimations];
}

#pragma mark - Datasource for Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
    // return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
    // return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isMeOrOther:indexPath]) {
        MeTableViewCell *cell = (MeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"meMsg" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MeTableViewCell alloc] initWithFrame:CGRectZero];
        }
        [self configureCellme:cell atIndexPath:indexPath];
        return cell;
    } else {
        OtherTableViewCell *cell = (OtherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"otherMsg" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[OtherTableViewCell alloc] initWithFrame:CGRectZero];
        }
        [self configureCellother:cell atIndexPath:indexPath];
        return cell;
    }
}

- (BOOL)isMeOrOther:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *directionStr = [object valueForKey:@"direction"];
    
    if ([directionStr isEqualToString:@"in"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)configureCellme:(MeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    //  cell.photo.image = [UIImage imageWithData:object.photo];
    
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:myPhoto];
    if (imgData) {
        cell.photo.image = [UIImage imageWithData:imgData];
    } else {
        cell.photo.image = [UIImage imageNamed:@"User"];
    }
    
    cell.time.text = [object valueForKey:@"msgTime"];
    cell.message.text = [object valueForKey:@"msgBody"];
}

- (void)configureCellother:(OtherTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    //    cell.photo.image = [UIImage imageWithData:object.photo];
    
    cell.time.text = [object valueForKey:@"msgTime"];
    cell.message.text = [object valueForKey:@"msgBody"];
    cell.name.text = [object valueForKey:@"name"];
    //  UIImage *bubbleImage = [[UIImage imageNamed:@"inMsg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    //  [cell.bubble setFrame:CGRectMake(40, 15, widthOfTextView + 3, sizeOfTextView.height + 10)];
    //   cell.bubble.image = bubbleImage;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MsgEntity" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [self.chatItem valueForKey:@"email"]];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgTime" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //   NSString *chatCache = @"ChatDetail";
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[MeTableViewCell class]]) {
                [self configureCellme:(MeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            } else if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[OtherTableViewCell class]]) {
                [self configureCellother:(OtherTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (IBAction)sendAct:(id)sender {
    NSString *msgHere = self.textView.text;
    //     NSLog(@"uuu-ggg- %@", sexH);
    if (msgHere == nil || [msgHere isStringEmpty]) {
        NSString *alertMsg = @"There is no message to send.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        //  self.msgDetail.text = @"";
        //  [self textViewDidChange:self.msgDetail];
        [self sendMsgOnServer];
    }

}

- (void)sendMsgOnServer {
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Sending message...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/sendmessage"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    //   NSLog(@"xx-pp-xx----xx787xx--%@", tempMail);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *now = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:now];
    
    NSString *emailToSend = [self.chatItem valueForKey:@"email"];
    //  self.msgDetail
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", emailToSend, @"emailToSend", self.textView.text, @"msg", dateStr, @"timeMsg", nil];
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
                    [self saveMsgCoreData:self.textView.text withTime:dateStr];
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

- (void)saveMsgCoreData:(NSString *)message withTime:(NSString *)time {
    
    NSManagedObject *msg = [NSEntityDescription insertNewObjectForEntityForName:@"MsgEntity" inManagedObjectContext:self.managedObjectContext];
    [msg setValue:[self.chatItem valueForKey:@"email"] forKey:@"email"];
    [msg setValue:[self.chatItem valueForKey:@"name"] forKey:@"name"];
    [msg setValue:@"out" forKey:@"direction"];
    [msg setValue:message forKey:@"msgBody"];
    [msg setValue:time forKey:@"msgTime"];
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MsgBoxEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [self.chatItem valueForKey:@"email"]];
    [fetchRequest setPredicate:predicate];
    NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *oldChat;
    if ([tempArr count] > 0) {
        oldChat = [tempArr objectAtIndex:0];
        [oldChat setValue:time forKey:@"timeLastMsg"];
        [oldChat setValue:message forKey:@"lastMsg"];
    }
    
    [self.appDelegate saveContext];
    
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
    
    NSInteger noOfSections = 1;
    NSInteger lastRowNo = [self.tableView numberOfRowsInSection:noOfSections - 1] - 1;
    if (lastRowNo >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRowNo inSection:noOfSections - 1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
