//
//  ComposeReviewViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-06.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ComposeReviewViewController.h"
#import "NSString+EmptyCheck.h"
#import "CBHelp.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "AppDelegate.h"

@interface ComposeReviewViewController ()

@property CGFloat originalBottomDis;

@end

@implementation ComposeReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.originalBottomDis = self.bottomDistance.constant;
    self.rateValue.delegate = self;
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.rateValue) {
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
    
    self.bottomDistance.constant = keyboardBounds.size.height + 15;
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
    
    self.bottomDistance.constant = self.originalBottomDis;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

/*
 - (void)textFieldDidBeginEditing:(UITextField *)textField {
 [UIView setAnimationsEnabled:YES];
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

- (IBAction)postIt:(id)sender {
    if ([self.rateValue.text isStringEmpty] || self.rateValue.text == nil) {
     //   NSString *alertTitle = @"";
        NSString *alertMessage = @"Please give a rate value.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMessage withConfirmTitle:okTitle];
    } else if (![CBHelp isNumeric:self.rateValue.text]) {
     //   NSString *alertTitle = @"";
        NSString *alertMessage = @"Rate value need to be decimal.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMessage withConfirmTitle:okTitle];
    } else if ([self.rateValue.text floatValue] > 5.0 || [self.rateValue.text floatValue] < 0.0) {
        //   NSString *alertTitle = @"";
        NSString *alertMessage = @"Rate value must be between 0.0 and 5.0.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMessage withConfirmTitle:okTitle];
    } else {
        [self postReview];
    }
}

- (void)postReview {
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Posting review...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/reviewpost"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    //   NSLog(@"xx-pp-xx----xx787xx--%@", tempMail);
    NSString *commentStr;
    if ([self.comments.text isStringEmpty] || self.comments.text == nil) {
        commentStr = @"No comment.";
    } else {
        commentStr = self.comments.text;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *now = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:now];
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", self.emailForReview, @"emailforpost", self.rateValue.text, @"rating", dateStr, @"timePosted", commentStr, @"comment", nil];
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
                    [self broadNotify];
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

- (void)broadNotify {
    NSString *key = @"keyStr";
    NSString *newValue = @"";

    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationReviewPost" object:nil userInfo:dictionary];
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
