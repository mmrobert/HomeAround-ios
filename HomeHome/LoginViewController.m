//
//  LoginViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property CGFloat originalTopDistance;
@property CGFloat originalTopLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    //   self.containerView1.layer.cornerRadius = 10;
    self.containerView1.layer.borderWidth = 1;
    self.containerView1.layer.borderColor = [[UIColor grayColor] CGColor];
  //  self.emailTxt.layer.borderWidth = 0;
  //  self.emailTxt.layer.borderColor = [[UIColor clearColor] CGColor];
  //  self.passwordTxt.layer.borderWidth = 0;
  //  self.passwordTxt.layer.borderColor = [[UIColor clearColor] CGColor];
  //  self.loginOutlet.layer.cornerRadius = 10;
    
    self.emailImg.image = [self.emailImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailImg setTintColor:[UIColor colorWithHue:0.7 saturation:0.9 brightness:0.7 alpha:1.0]];
    self.passwordImg.image = [self.passwordImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.passwordImg setTintColor:[UIColor colorWithHue:0.7 saturation:0.9 brightness:0.7 alpha:1.0]];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.emailTxt.delegate = self;
    self.passwordTxt.delegate = self;
    
    self.originalTopDistance = self.topDistance.constant;
    self.originalTopLogin = self.topLogin.constant;
  //  NSLog(@"This is a test: 999");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.emailTxt) || (textField == self.passwordTxt)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

/*
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView setAnimationsEnabled:YES];
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // workaround for jumping text bug
    [textField resignFirstResponder];
    [textField layoutIfNeeded];
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
    CGFloat tempH = self.view.frame.size.height - 18 - self.logoImg.frame.size.height - 18 - self.containerView1.frame.size.height - 5 - self.loginOutlet.frame.size.height - 10 - self.registerBtn.frame.size.height;
    CGFloat tempKH = keyboardBounds.size.height + 60;
    self.topLogin.constant = 5;
    if (!(self.topDistance.constant < 6)) {
        if (tempH < tempKH) {
            self.topDistance.constant -= tempKH - tempH - 2;
        }
    }
    // [self.tableView layoutIfNeeded];
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    // set table view scroll to bottom
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
    self.topLogin.constant = self.originalTopLogin;
 //   self.enterViewBottom.constant -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toRoleChoose"] || [[segue identifier] isEqualToString:@"toFindPW"]) {
        //   UINavigationController *nv = [segue destinationViewController];
        [self.view endEditing:YES];
    }
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.emailTxt.text isStringEmpty] || [self.passwordTxt.text isStringEmpty] || self.emailTxt.text == nil || self.passwordTxt.text == nil) {
        
     //   NSString *alertTitle = @"";
        NSString *alertMsg = @"Email and/or password can't be empty.";
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
            // net work
            [self connectingServer];
        }
    }
}

- (IBAction)returnToLogin:(UIStoryboardSegue *)segue {
    
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Logging in...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"login"]];
    
    BOOL allowRemote = [[NSUserDefaults standardUserDefaults] boolForKey:myRemoteNoteAllow];
    NSString *dToken;
    if (allowRemote) {
        dToken = [[NSUserDefaults standardUserDefaults] objectForKey:myDeviceToken];
    } else {
        dToken = @"0";
    }
    
    NSString *emailOriginal = self.emailTxt.text;
    NSString *emailLcase = [emailOriginal lowercaseString];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:emailLcase, @"email", self.passwordTxt.text, @"password", @"ios", @"platform", dToken, @"devicetoken", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
//  NSInteger code = [[returnedDict objectForKey:@"responseCode"] integerValue];
//  NSString *aa = (success) ? @"true" : @"false";
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSString *token = [returnedDict objectForKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:myToken];
                    NSString *emailOriginal = self.emailTxt.text;
                    NSString *email = [emailOriginal lowercaseString];
                    [[NSUserDefaults standardUserDefaults] setObject:email forKey:myEmail];
                    NSString *password = self.passwordTxt.text;
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:myPassword];
                    
                    NSString *role = [returnedDict objectForKey:@"role"];
                    [[NSUserDefaults standardUserDefaults] setObject:role forKey:myRole];
                    
                    NSDictionary *profile = [returnedDict objectForKey:@"userprofile"];
                    
                    if ([role isEqualToString:@"customer"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"name"] forKey:myNickName];
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"postcode"] forKey:myPostalCode];
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"country"] forKey:myCountry];
                    } else {
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"name"] forKey:myNickName];
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"postcode"] forKey:myPostalCode];
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"country"] forKey:myCountry];
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"phone"] forKey:myPhone];
                        NSArray *ttArr = [profile objectForKey:@"expertise"];
                        NSString *ttStr = [ttArr componentsJoinedByString:@",\n"];
                        [[NSUserDefaults standardUserDefaults] setObject:ttStr forKey:myExpertise];
                        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"biodetail"] forKey:myBio];
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self toMainPages];
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

- (void)toMainPages {
    NSString *uRole = [[NSUserDefaults standardUserDefaults] objectForKey:myRole];
    
    //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:myCountry];
    // NSLog(@"8888yyy: %@", userID);
    
    if ([uRole isEqualToString:@"customer"]) {
        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Custom" bundle:nil] instantiateViewControllerWithIdentifier:@"MainSlidingBaseCustom"];
        [self presentViewController:mainController animated:YES completion:nil];
        //   if ([[self appDelegate] connect]) {
        //   NSLog(@"show buddy list");
        //   }
        
    } else {
        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Merchant" bundle:nil] instantiateViewControllerWithIdentifier:@"MainSlidingBaseMerchant"];
        [self presentViewController:mainController animated:YES completion:nil];
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
