//
//  MSendMsgViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MSendMsgViewController.h"
#import "AppConstants.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"

@interface MSendMsgViewController ()

@property CGFloat originalBottomDistance;

@end

@implementation MSendMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.originalBottomDistance = self.bottomDistance.constant;
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //   UITapGestureRecognizer *jobInclude = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseJob:)];
    //   [self.jobAttached addGestureRecognizer:jobInclude];
    //   self.jobAttached.userInteractionEnabled = YES;
    self.toWhom.text = [self.customDict objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *nameS = [[NSUserDefaults standardUserDefaults] objectForKey:myNickName];
    
    if (nameS == nil || [nameS isStringEmpty]) {
        NSString *alertMsg = @"Please enter your name in the Settings to send message.";
        NSString *okTitle = @"OK";
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:alertMsg
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
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
    
    self.bottomDistance.constant = keyboardBounds.size.height + 18;
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
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
    
    self.bottomDistance.constant = self.originalBottomDistance;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendAct:(id)sender {
    
    [self.view endEditing:YES];
    NSString *msgHere = self.msgDetail.text;
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"merchant/sendmessage"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    //   NSLog(@"xx-pp-xx----xx787xx--%@", tempMail);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *now = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:now];
    
    NSString *emailToSend = [self.customDict objectForKey:@"email"];
    //  self.msgDetail
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", emailToSend, @"emailToSend", self.msgDetail.text, @"msg", dateStr, @"timeMsg", nil];
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
                    [self saveMsgCoreData:self.msgDetail.text withTime:dateStr];
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
    
    [msg setValue:[self.customDict objectForKey:@"email"] forKey:@"email"];
    [msg setValue:[self.customDict objectForKey:@"name"] forKey:@"name"];
    [msg setValue:@"out" forKey:@"direction"];
    [msg setValue:message forKey:@"msgBody"];
    [msg setValue:time forKey:@"msgTime"];
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MerMsgBoxEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [self.customDict objectForKey:@"email"]];
    [fetchRequest setPredicate:predicate];
    NSArray *tempArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([tempArr count] < 1) {
        NSManagedObject *newChat = [NSEntityDescription insertNewObjectForEntityForName:@"MerMsgBoxEntity" inManagedObjectContext:self.managedObjectContext];
        
        [newChat setValue:[self.customDict objectForKey:@"email"] forKey:@"email"];
        [newChat setValue:[self.customDict objectForKey:@"name"] forKey:@"name"];
        [newChat setValue:message forKey:@"lastMsg"];
        [newChat setValue:time forKey:@"timeLastMsg"];
    } else {
        NSManagedObject *oldChat = [tempArr objectAtIndex:0];
        [oldChat setValue:message forKey:@"lastMsg"];
        [oldChat setValue:time forKey:@"timeLastMsg"];
    }
    [self.appDelegate saveContext];
    [self.navigationController popViewControllerAnimated:YES];
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
