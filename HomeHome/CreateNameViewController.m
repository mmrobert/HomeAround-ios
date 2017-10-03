//
//  CreateNameViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CreateNameViewController.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NSString+EmptyCheck.h"

@interface CreateNameViewController ()

@property CGFloat originalTopDistance;

@end

@implementation CreateNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //   self.containerView1.layer.cornerRadius = 10;
  //  CGFloat tempW = self.laterOutlet.frame.size.width;
  //  self.laterOutlet.layer.cornerRadius = tempW / 2;
    
    self.containerView1.layer.borderWidth = 1;
    self.containerView1.layer.borderColor = [[UIColor grayColor] CGColor];
 
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.nameTxt.delegate = self;
    
    self.originalTopDistance = self.topDistance.constant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTxt) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // workaround for jumping text bug
    [textField resignFirstResponder];
    [textField layoutIfNeeded];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void) keyboardWillShow:(NSNotification *)note {
    //  NSLog(@"key show");
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
    
    // [self.tableView layoutIfNeeded];
    self.topDistance.constant = 10;
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note {
    //  NSLog(@"key hide");
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set table view height
    // self.heightForTable.constant += keyboardBounds.size.height + 10;
    // [self.tableView layoutIfNeeded];
    self.topDistance.constant = self.originalTopDistance;
    //   self.enterViewBottom.constant -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self.view endEditing:YES];
}

- (IBAction)saveAct:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.nameTxt.text isStringEmpty] || self.nameTxt.text == nil) {
        NSString *alertMsg = @"Enter your name to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        [self connectingServer];
            //  NSLog(@"999--test here--999");
    }
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Saving name...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"setname"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:self.nameTxt.text, @"name", uToken, @"token", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    //   NSString *token = [returnedDict objectForKey:@"sessionId"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSString *nameStr = self.nameTxt.text;
                    [[NSUserDefaults standardUserDefaults] setObject:nameStr forKey:myNickName];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSegueWithIdentifier:@"NameToNextSegue" sender:self];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
