//
//  ForgotPasswordViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "AppDelegate.h"

@interface ForgotPasswordViewController ()

@property CGFloat originalTopDistance;
@property CGFloat originalTopReset;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.containerView1.layer.borderWidth = 1;
    self.containerView1.layer.borderColor = [[UIColor grayColor] CGColor];

  //  self.resetOutlet.layer.cornerRadius = 10;
    
    self.emailImg.image = [self.emailImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailImg setTintColor:[UIColor colorWithHue:0.7 saturation:0.9 brightness:0.7 alpha:1.0]];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.emailTxt.delegate = self;
    
    self.originalTopDistance = self.topDistance.constant;
    self.originalTopReset = self.topReset.constant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTxt) {
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
    
    //  NSLog(@"key hide %f", [duration doubleValue]);
    // [self.tableView layoutIfNeeded];
    self.topDistance.constant = 5;
    self.topReset.constant = 5;
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
    
    self.topDistance.constant = self.originalTopDistance;
    self.topReset.constant = self.originalTopReset;
    //   self.enterViewBottom.constant -= keyboardBounds.size.height + 5;
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

- (IBAction)resetAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.emailTxt.text isStringEmpty] || self.emailTxt.text == nil) {
        NSString *alertMsg = @"Please provide a email address.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL testResult = [emailTest evaluateWithObject:self.emailTxt.text];
        if (!testResult) {
            NSString *alertMsg = @"Not right email format.";
            NSString *okTitle = @"OK";
            [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
        } else {
            [self connectingServer];
          //  NSLog(@"999--test here--999");
           // net work here
        }
    }
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Connecting server...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"resetpw"]];
    NSString *emailOriginal = self.emailTxt.text;
    NSString *emailLcase = [emailOriginal lowercaseString];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:emailLcase, @"email", nil];
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
                    NSString *alertMessage = @"We've sent you an email with a link to reset your password.";
                    NSString *okTitle = @"OK";
                    UIAlertController *alert = [UIAlertController
                                                alertControllerWithTitle:nil
                                                message:alertMessage
                                                preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action){
                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                     }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];

      //              [self dismissViewControllerAnimated:YES completion:nil];
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
